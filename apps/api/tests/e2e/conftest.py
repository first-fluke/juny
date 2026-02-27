"""E2E test fixtures — real PostgreSQL, table truncation per test."""

import uuid
import warnings
from collections.abc import AsyncGenerator

import pytest
from httpx import ASGITransport, AsyncClient
from sqlalchemy import create_engine, text
from sqlalchemy.ext.asyncio import (
    AsyncSession,
    async_sessionmaker,
    create_async_engine,
)

from src.lib.auth import create_access_token
from src.lib.config import settings
from src.lib.database import Base, get_db
from src.lib.rate_limit import reset_rate_limiters
from src.main import app
from src.users.model import User

# ── Test DB URLs ────────────────────────────────────────────────────
_BASE_SYNC_URL = settings.DATABASE_URL_SYNC.rsplit("/", 1)[0]
_BASE_ASYNC_URL = settings.DATABASE_URL.rsplit("/", 1)[0]
TEST_DB_NAME = "juny_test"
TEST_ASYNC_URL = f"{_BASE_ASYNC_URL}/{TEST_DB_NAME}"

# Deterministic UUIDs for seed data
HOST_USER_ID = uuid.UUID("00000000-0000-4000-8000-000000000e01")
CAREGIVER_USER_ID = uuid.UUID("00000000-0000-4000-8000-000000000e02")
UNRELATED_USER_ID = uuid.UUID("00000000-0000-4000-8000-000000000e03")
ORGANIZATION_USER_ID = uuid.UUID("00000000-0000-4000-8000-000000000e04")

# All table names for truncation (order doesn't matter with CASCADE)
_ALL_TABLES = [
    "device_tokens",
    "wellness_logs",
    "medications",
    "care_relations",
    "users",
]


# ── Session-scoped: create / drop test database (sync) ─────────────
@pytest.fixture(scope="session", autouse=True)
def _setup_test_db() -> None:
    """Create test DB + tables once per session (sync, no event-loop issues)."""
    admin_engine = create_engine(
        f"{_BASE_SYNC_URL}/postgres",
        isolation_level="AUTOCOMMIT",
    )
    with admin_engine.connect() as conn:
        conn.execute(
            text(
                "SELECT pg_terminate_backend(pid) "  # noqa: S608
                "FROM pg_stat_activity "
                f"WHERE datname = '{TEST_DB_NAME}' AND pid <> pg_backend_pid()"
            )
        )
        conn.execute(text(f"DROP DATABASE IF EXISTS {TEST_DB_NAME}"))
        conn.execute(text(f"CREATE DATABASE {TEST_DB_NAME}"))
    admin_engine.dispose()

    # Create tables using sync engine pointed at test DB
    sync_url = f"{_BASE_SYNC_URL}/{TEST_DB_NAME}"
    table_engine = create_engine(sync_url)
    Base.metadata.create_all(table_engine)
    table_engine.dispose()

    yield  # ---- tests run ----

    # Teardown: drop test database
    admin_engine = create_engine(
        f"{_BASE_SYNC_URL}/postgres",
        isolation_level="AUTOCOMMIT",
    )
    with admin_engine.connect() as conn:
        conn.execute(
            text(
                "SELECT pg_terminate_backend(pid) "  # noqa: S608
                "FROM pg_stat_activity "
                f"WHERE datname = '{TEST_DB_NAME}' AND pid <> pg_backend_pid()"
            )
        )
        conn.execute(text(f"DROP DATABASE IF EXISTS {TEST_DB_NAME}"))
    admin_engine.dispose()


# ── Rate limiter reset per test ────────────────────────────────────
@pytest.fixture(autouse=True)
async def _reset_rate_limiters() -> AsyncGenerator[None, None]:
    """Reset rate limiter state and flush Redis keys between tests."""
    reset_rate_limiters()
    if settings.REDIS_URL:
        import redis.asyncio as aioredis

        client = aioredis.from_url(settings.REDIS_URL)  # type: ignore[no-untyped-call]
        keys = await client.keys("rate_limit:*")
        if keys:
            await client.delete(*keys)
        await client.aclose()
    yield
    reset_rate_limiters()


# ── Function-scoped: engine + session + client ─────────────────────
@pytest.fixture
async def test_engine():
    """Function-scoped async engine (created on the test's event loop)."""
    engine = create_async_engine(TEST_ASYNC_URL, echo=False)
    yield engine
    await engine.dispose()


@pytest.fixture
async def db_session(test_engine) -> AsyncGenerator[AsyncSession, None]:
    """Provide a DB session that commits, then truncate tables at teardown."""
    factory = async_sessionmaker(test_engine, expire_on_commit=False)
    async with factory() as session:
        yield session

    # Cleanup: truncate all tables after each test
    async with test_engine.begin() as conn:
        for table in _ALL_TABLES:
            await conn.execute(text(f"TRUNCATE TABLE {table} CASCADE"))


@pytest.fixture
async def client(test_engine) -> AsyncGenerator[AsyncClient, None]:
    """ASGI test client with get_db overridden to use the test engine."""
    factory = async_sessionmaker(test_engine, expire_on_commit=False)

    async def _override_get_db() -> AsyncGenerator[AsyncSession, None]:
        async with factory() as session:
            try:
                yield session
                await session.commit()
            except Exception:
                await session.rollback()
                raise

    app.dependency_overrides[get_db] = _override_get_db
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as ac:
        yield ac
    app.dependency_overrides.clear()


# ── Seed helpers ───────────────────────────────────────────────────
@pytest.fixture
async def seed_host(db_session: AsyncSession) -> User:
    """Insert a HOST user into the test database."""
    user = User(
        id=HOST_USER_ID,
        email="host@test.com",
        name="Test Host",
        role="host",
        provider="google",
        provider_id="google-host-001",
        email_verified=True,
    )
    db_session.add(user)
    await db_session.commit()
    await db_session.refresh(user)
    return user


@pytest.fixture
async def seed_caregiver(db_session: AsyncSession) -> User:
    """Insert a CONCIERGE user into the test database."""
    user = User(
        id=CAREGIVER_USER_ID,
        email="caregiver@test.com",
        name="Test Caregiver",
        role="concierge",
        provider="google",
        provider_id="google-cg-001",
        email_verified=True,
    )
    db_session.add(user)
    await db_session.commit()
    await db_session.refresh(user)
    return user


@pytest.fixture
async def seed_unrelated_user(db_session: AsyncSession) -> User:
    """Insert an unrelated user with no care relations."""
    user = User(
        id=UNRELATED_USER_ID,
        email="unrelated@test.com",
        name="Unrelated User",
        role="concierge",
        provider="google",
        provider_id="google-unrel-001",
        email_verified=True,
    )
    db_session.add(user)
    await db_session.commit()
    await db_session.refresh(user)
    return user


# ── Authenticated clients ──────────────────────────────────────────
def _create_token(user_id: str, role: str | None) -> str:
    """Create a JWT token suppressing InsecureKeyLengthWarning."""
    import jwt.warnings

    with warnings.catch_warnings():
        warnings.simplefilter("ignore", jwt.warnings.InsecureKeyLengthWarning)
        return create_access_token(user_id, role=role)


@pytest.fixture
async def host_client(client: AsyncClient, seed_host: User) -> AsyncClient:
    """AsyncClient with host bearer token."""
    token = _create_token(str(seed_host.id), seed_host.role)
    client.headers["Authorization"] = f"Bearer {token}"
    return client


@pytest.fixture
async def caregiver_client(client: AsyncClient, seed_caregiver: User) -> AsyncClient:
    """AsyncClient with caregiver bearer token."""
    token = _create_token(str(seed_caregiver.id), seed_caregiver.role)
    client.headers["Authorization"] = f"Bearer {token}"
    return client


@pytest.fixture
async def unrelated_client(
    client: AsyncClient, seed_unrelated_user: User
) -> AsyncClient:
    """AsyncClient with an unrelated user's bearer token."""
    token = _create_token(str(seed_unrelated_user.id), seed_unrelated_user.role)
    client.headers["Authorization"] = f"Bearer {token}"
    return client


@pytest.fixture
async def seed_organization_user(db_session: AsyncSession) -> User:
    """Insert an ORGANIZATION user into the test database."""
    user = User(
        id=ORGANIZATION_USER_ID,
        email="org@test.com",
        name="Test Organization",
        role="organization",
        provider="google",
        provider_id="google-org-001",
        email_verified=True,
    )
    db_session.add(user)
    await db_session.commit()
    await db_session.refresh(user)
    return user


@pytest.fixture
async def organization_client(
    client: AsyncClient, seed_organization_user: User
) -> AsyncClient:
    """AsyncClient with organization bearer token."""
    token = _create_token(str(seed_organization_user.id), seed_organization_user.role)
    client.headers["Authorization"] = f"Bearer {token}"
    return client
