from functools import lru_cache
from typing import Literal

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """Application settings loaded from environment variables."""

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=True,
        extra="ignore",
    )

    # Project
    PROJECT_NAME: str = "juny-api"
    PROJECT_ENV: Literal["local", "staging", "prod"] = "local"

    # Database
    DATABASE_URL: str = "postgresql+asyncpg://postgres:postgres@localhost:5433/juny"
    DATABASE_URL_SYNC: str = "postgresql://postgres:postgres@localhost:5433/juny"

    # Database connection pool (Supabase PgBouncer compatible)
    DB_POOL_SIZE: int = 10
    DB_MAX_OVERFLOW: int = 20
    DB_POOL_TIMEOUT: int = 30
    DB_POOL_RECYCLE: int = 1800  # 30 minutes

    # CORS (comma-separated string in .env)
    CORS_ORIGINS: str = "http://localhost:3200"

    # Auth (better-auth)
    BETTER_AUTH_URL: str = "http://localhost:3200"

    # JWT (stateless authentication)
    JWT_SECRET: str = "your-super-secret-jwt-key-change-in-production"  # noqa: S105

    # Redis (optional)
    REDIS_URL: str | None = None

    # LiveKit (optional)
    LIVEKIT_API_URL: str | None = None
    LIVEKIT_API_KEY: str | None = None
    LIVEKIT_API_SECRET: str | None = None

    # OpenTelemetry (optional)
    OTEL_EXPORTER_OTLP_ENDPOINT: str | None = None
    OTEL_SERVICE_NAME: str | None = None

    # AI (optional)
    AI_PROVIDER: Literal["gemini", "openai"] = "gemini"
    GEMINI_BACKEND: Literal["ai_studio", "vertex_ai"] = "ai_studio"
    GEMINI_LIVE_MODEL: str | None = None
    GOOGLE_CLOUD_PROJECT: str | None = None
    GOOGLE_CLOUD_LOCATION: str = "us-central1"
    GEMINI_API_KEY: str | None = None
    OPENAI_API_KEY: str | None = None

    # Notifications
    NOTIFICATION_PROVIDER: Literal["mock", "fcm"] = "mock"

    # Internal service auth (Worker → API)
    INTERNAL_API_KEY: str | None = None

    # Worker dispatch
    WORKER_URL: str = "http://localhost:8280"
    CLOUD_TASKS_QUEUE: str | None = None
    CLOUD_TASKS_LOCATION: str = "asia-northeast3"

    # Storage (optional)
    STORAGE_BACKEND: Literal["gcs", "minio"] = "minio"
    GCS_BUCKET_NAME: str | None = None
    MINIO_ENDPOINT: str = "localhost:9000"
    MINIO_ACCESS_KEY: str = "minioadmin"
    MINIO_SECRET_KEY: str = "minioadmin"  # noqa: S105

    @property
    def gemini_configured(self) -> bool:
        """Check whether Gemini is ready (AI Studio or Vertex AI)."""
        if self.GEMINI_BACKEND == "vertex_ai":
            return bool(self.GOOGLE_CLOUD_PROJECT)
        return bool(self.GEMINI_API_KEY)

    @property
    def cors_origins(self) -> list[str]:
        """Parse CORS_ORIGINS into a list of origin strings."""
        return [o.strip() for o in self.CORS_ORIGINS.split(",") if o.strip()]


@lru_cache
def get_settings() -> Settings:
    """Cached settings instance."""
    return Settings()


settings = get_settings()
