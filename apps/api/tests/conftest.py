from unittest.mock import AsyncMock

import pytest
from fastapi.testclient import TestClient

from src.lib.auth import create_access_token
from src.main import app

TEST_USER_ID = "00000000-0000-4000-8000-000000000099"
TEST_USER_ROLE = "host"
TEST_CAREGIVER_ID = "00000000-0000-4000-8000-000000000098"
TEST_HOST_ID_ALT = "00000000-0000-4000-8000-000000000097"


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
def mock_db() -> AsyncMock:
    """Mock database session."""
    return AsyncMock()
