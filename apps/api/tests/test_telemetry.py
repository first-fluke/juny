"""Smoke tests for the OpenTelemetry telemetry module."""

from __future__ import annotations

from unittest.mock import MagicMock, patch

import pytest
from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider

from src.lib.telemetry import configure_telemetry, get_tracer, instrument_app


@pytest.fixture(autouse=True)
def _reset_tracer_provider():
    """Reset global tracer provider after each test."""
    yield
    # Reset to default no-op provider
    trace.set_tracer_provider(trace.ProxyTracerProvider())


class TestConfigureTelemetry:
    @patch("src.lib.telemetry.settings")
    def test_configure_local_console_exporter(self, mock_settings: MagicMock) -> None:
        """local env with no OTLP endpoint → ConsoleSpanExporter."""
        mock_settings.PROJECT_NAME = "juny"
        mock_settings.PROJECT_ENV = "local"
        mock_settings.OTEL_EXPORTER_OTLP_ENDPOINT = None

        configure_telemetry()

        provider = trace.get_tracer_provider()
        assert isinstance(provider, TracerProvider)
        # Verify a span processor was added (ConsoleSpanExporter)
        processors = provider._active_span_processor._span_processors  # type: ignore[attr-defined]
        assert len(processors) == 1

    @patch("src.lib.telemetry.OTLPSpanExporter")
    @patch("src.lib.telemetry.settings")
    def test_configure_with_otlp_endpoint(
        self, mock_settings: MagicMock, mock_otlp_cls: MagicMock
    ) -> None:
        """OTLP endpoint set → OTLPSpanExporter."""
        mock_settings.PROJECT_NAME = "juny"
        mock_settings.PROJECT_ENV = "staging"
        mock_settings.OTEL_EXPORTER_OTLP_ENDPOINT = "http://collector:4317"

        configure_telemetry()

        mock_otlp_cls.assert_called_once_with(
            endpoint="http://collector:4317",
            insecure=True,
        )


class TestGetTracer:
    def test_returns_tracer_instance(self) -> None:
        tracer = get_tracer("test-module")
        assert tracer is not None


class TestInstrumentApp:
    @patch("src.lib.telemetry.RedisInstrumentor")
    @patch("src.lib.telemetry.HTTPXClientInstrumentor")
    @patch("src.lib.telemetry.SQLAlchemyInstrumentor")
    @patch("src.lib.telemetry.FastAPIInstrumentor")
    @patch("src.lib.database.engine")
    def test_instrument_app_calls_instrumentors(
        self,
        mock_engine: MagicMock,
        mock_fastapi: MagicMock,
        mock_sqla: MagicMock,
        mock_httpx: MagicMock,
        mock_redis: MagicMock,
    ) -> None:
        mock_engine.sync_engine = MagicMock()
        mock_app = MagicMock()

        instrument_app(mock_app)

        mock_fastapi.instrument_app.assert_called_once()
        mock_sqla.return_value.instrument.assert_called_once()
        mock_httpx.return_value.instrument.assert_called_once()
