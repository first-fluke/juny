from collections.abc import AsyncIterator
from contextlib import asynccontextmanager

import structlog
from fastapi import FastAPI

from src.lib.config import settings
from src.routers import health, pubsub, tasks

logger = structlog.get_logger(__name__)


@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncIterator[None]:
    # Trigger auto-discovery of all job modules
    import src.jobs  # noqa: F401
    from src.jobs.base import list_jobs
    from src.lib.telemetry import configure_telemetry, instrument_app

    configure_telemetry()
    instrument_app(app)
    logger.info("worker_started", registered_jobs=list_jobs())
    yield
    logger.info("worker_shutdown")


app = FastAPI(
    title=f"{settings.PROJECT_NAME} Worker",
    version="0.1.0",
    lifespan=lifespan,
    docs_url="/docs" if settings.PROJECT_ENV != "prod" else None,
)

app.include_router(health.router)
app.include_router(tasks.router, prefix="/tasks")
app.include_router(pubsub.router, prefix="/tasks")
