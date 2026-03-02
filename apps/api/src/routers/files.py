"""File upload / download / delete endpoints."""

import uuid

import structlog
from fastapi import APIRouter, Request, UploadFile, status
from fastapi.responses import RedirectResponse
from pydantic import BaseModel

from src.common.errors import AUTHZ_002, SVC_005, VAL_003, raise_api_error
from src.lib.auth import CurrentUserInfo
from src.lib.dependencies import CurrentUser, StorageDep
from src.lib.rate_limit import rate_limit

logger = structlog.get_logger(__name__)

router = APIRouter()

DEFAULT_BUCKET = "juny-uploads"
MAX_FILE_SIZE = 10 * 1024 * 1024  # 10 MB
_ALLOWED_EXTENSIONS: set[str] = {
    ".jpg",
    ".jpeg",
    ".png",
    ".gif",
    ".webp",
    ".heic",
    ".pdf",
    ".txt",
    ".csv",
}


class FileUploadResponse(BaseModel):
    """Response after a successful file upload."""

    key: str
    url: str
    content_type: str
    size: int


def _check_file_ownership(key: str, user: CurrentUserInfo) -> None:
    """Verify the file key belongs to the requesting user."""
    if ".." in key or key.startswith("/"):
        raise_api_error(AUTHZ_002, status.HTTP_403_FORBIDDEN)
    owner_id = key.split("/", 1)[0] if "/" in key else ""
    if owner_id != user.id:
        raise_api_error(AUTHZ_002, status.HTTP_403_FORBIDDEN)


@router.post(
    "/upload",
    response_model=FileUploadResponse,
    status_code=status.HTTP_201_CREATED,
)
@rate_limit(requests=20, window=60)
async def upload_file(
    request: Request,
    file: UploadFile,
    user: CurrentUser,
    storage: StorageDep,
) -> FileUploadResponse:
    """Upload a file (max 10 MB)."""
    data = await file.read()
    if len(data) > MAX_FILE_SIZE:
        raise_api_error(
            SVC_005,
            status.HTTP_413_CONTENT_TOO_LARGE,
            message="File too large (max 10 MB)",
        )

    ext = ""
    if file.filename and "." in file.filename:
        ext = "." + file.filename.rsplit(".", 1)[-1].lower()

    if ext and ext not in _ALLOWED_EXTENSIONS:
        raise_api_error(
            VAL_003,
            status.HTTP_422_UNPROCESSABLE_CONTENT,
            message=f"File type '{ext}' is not allowed",
        )

    key = f"{user.id}/{uuid.uuid4()}{ext}"
    content_type = file.content_type or "application/octet-stream"

    try:
        await storage.upload(DEFAULT_BUCKET, key, data, content_type=content_type)
    except Exception:
        logger.exception("file_upload_storage_error")
        raise_api_error(
            SVC_005,
            status.HTTP_500_INTERNAL_SERVER_ERROR,
            message="File upload failed",
        )

    url = f"/api/v1/files/{key}"
    return FileUploadResponse(
        key=key, url=url, content_type=content_type, size=len(data)
    )


@router.get("/{key:path}")
async def get_file(
    key: str,
    user: CurrentUser,
    storage: StorageDep,
) -> RedirectResponse:
    """Redirect to a signed URL for the requested file."""
    _check_file_ownership(key, user)
    signed_url = await storage.get_signed_url(DEFAULT_BUCKET, key)
    return RedirectResponse(
        url=signed_url,
        status_code=status.HTTP_307_TEMPORARY_REDIRECT,
    )


@router.delete("/{key:path}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_file(
    key: str,
    user: CurrentUser,
    storage: StorageDep,
) -> None:
    """Delete a file from storage."""
    _check_file_ownership(key, user)
    await storage.delete(DEFAULT_BUCKET, key)
