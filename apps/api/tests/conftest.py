from collections.abc import Generator
from unittest.mock import AsyncMock, patch

import pytest
from fastapi.testclient import TestClient

from src.lib.auth import create_access_token
from src.lib.rate_limit import reset_rate_limiters
from src.main import app

TEST_USER_ID = "00000000-0000-4000-8000-000000000099"
TEST_USER_ROLE = "host"
TEST_CAREGIVER_ID = "00000000-0000-4000-8000-000000000098"
TEST_HOST_ID_ALT = "00000000-0000-4000-8000-000000000097"
TEST_CARE_WORKER_ID = "00000000-0000-4000-8000-000000000096"
TEST_ORGANIZATION_ID = "00000000-0000-4000-8000-000000000095"


@pytest.fixture(autouse=True)
def _reset_rate_limiters() -> Generator[None, None, None]:
    """Reset rate limiter state and force in-memory backend for tests."""
    reset_rate_limiters()
    with patch("src.lib.rate_limit.settings") as mock_settings:
        mock_settings.REDIS_URL = None
        yield
    reset_rate_limiters()


@pytest.fixture
def client() -> TestClient:
    """Test client fixture."""
    return TestClient(app)


@pytest.fixture
def auth_headers() -> dict[str, str]:
    """Authorization headers with a valid access token."""
    token = create_access_token(TEST_USER_ID, role=TEST_USER_ROLE)
    return {"Authorization": f"Bearer {token}"}


@pytest.fixture
def authed_client(auth_headers: dict[str, str]) -> TestClient:
    """Test client with pre-set auth headers."""
    c = TestClient(app)
    c.headers.update(auth_headers)
    return c


@pytest.fixture
def caregiver_auth_headers() -> dict[str, str]:
    """Authorization headers for a caregiver user."""
    token = create_access_token(TEST_CAREGIVER_ID, role="concierge")
    return {"Authorization": f"Bearer {token}"}


@pytest.fixture
def caregiver_client(caregiver_auth_headers: dict[str, str]) -> TestClient:
    """Test client with caregiver auth headers."""
    c = TestClient(app)
    c.headers.update(caregiver_auth_headers)
    return c


@pytest.fixture
def care_worker_auth_headers() -> dict[str, str]:
    """Authorization headers for a care worker user."""
    token = create_access_token(TEST_CARE_WORKER_ID, role="care_worker")
    return {"Authorization": f"Bearer {token}"}


@pytest.fixture
def care_worker_client(care_worker_auth_headers: dict[str, str]) -> TestClient:
    """Test client with care worker auth headers."""
    c = TestClient(app)
    c.headers.update(care_worker_auth_headers)
    return c


@pytest.fixture
def organization_auth_headers() -> dict[str, str]:
    """Authorization headers for an organization user."""
    token = create_access_token(TEST_ORGANIZATION_ID, role="organization")
    return {"Authorization": f"Bearer {token}"}


@pytest.fixture
def organization_client(organization_auth_headers: dict[str, str]) -> TestClient:
    """Test client with organization auth headers."""
    c = TestClient(app)
    c.headers.update(organization_auth_headers)
    return c


@pytest.fixture
def mock_db() -> AsyncMock:
    """Mock database session.

    ``add()`` is sync on ``AsyncSession`` — use ``MagicMock`` to avoid
    'coroutine was never awaited' warnings.
    """
    from unittest.mock import MagicMock

    db = AsyncMock()
    db.add = MagicMock()
    return db
