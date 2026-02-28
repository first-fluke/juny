"""Tests for worker telemetry module."""

from __future__ import annotations

from unittest.mock import MagicMock, patch

from opentelemetry import trace

from src.lib.telemetry import configure_telemetry, get_tracer


class TestConfigureTelemetry:
    @patch("src.lib.telemetry.settings")
    @patch("src.lib.telemetry.trace")
    @patch("src.lib.telemetry.TracerProvider")
    def test_configure_with_otlp_endpoint(
        self,
        mock_provider_cls: MagicMock,
        mock_trace: MagicMock,
        mock_settings: MagicMock,
    ) -> None:
        mock_settings.PROJECT_NAME = "juny"
        mock_settings.PROJECT_ENV = "staging"
        mock_settings.OTEL_EXPORTER_OTLP_ENDPOINT = "http://otel:4317"

        provider_instance = MagicMock()
        mock_provider_cls.return_value = provider_instance

        configure_telemetry()

        mock_provider_cls.assert_called_once()
        provider_instance.add_span_processor.assert_called_once()
        mock_trace.set_tracer_provider.assert_called_once_with(provider_instance)

    @patch("src.lib.telemetry.settings")
    @patch("src.lib.telemetry.trace")
    @patch("src.lib.telemetry.TracerProvider")
    def test_configure_local_console_exporter(
        self,
        mock_provider_cls: MagicMock,
        mock_trace: MagicMock,
        mock_settings: MagicMock,
    ) -> None:
        mock_settings.PROJECT_NAME = "juny"
        mock_settings.PROJECT_ENV = "local"
        mock_settings.OTEL_EXPORTER_OTLP_ENDPOINT = None

        provider_instance = MagicMock()
        mock_provider_cls.return_value = provider_instance

        configure_telemetry()

        provider_instance.add_span_processor.assert_called_once()

    @patch("src.lib.telemetry.settings")
    @patch("src.lib.telemetry.trace")
    @patch("src.lib.telemetry.TracerProvider")
    def test_configure_prod_no_endpoint_no_exporter(
        self,
        mock_provider_cls: MagicMock,
        mock_trace: MagicMock,
        mock_settings: MagicMock,
    ) -> None:
        mock_settings.PROJECT_NAME = "juny"
        mock_settings.PROJECT_ENV = "prod"
        mock_settings.OTEL_EXPORTER_OTLP_ENDPOINT = None

        provider_instance = MagicMock()
        mock_provider_cls.return_value = provider_instance

        configure_telemetry()

        provider_instance.add_span_processor.assert_not_called()


class TestGetTracer:
    def test_returns_tracer(self) -> None:
        t = get_tracer("test-module")
        assert isinstance(t, trace.Tracer)
