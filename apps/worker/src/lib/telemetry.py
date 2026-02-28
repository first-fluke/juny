"""OpenTelemetry configuration for the worker process."""

from fastapi import FastAPI
from opentelemetry import trace
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor
from opentelemetry.instrumentation.httpx import HTTPXClientInstrumentor
from opentelemetry.sdk.resources import Resource
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor, ConsoleSpanExporter

from src.lib.config import settings


def configure_telemetry() -> None:
    """Configure OpenTelemetry tracing with OTLP exporter."""
    resource = Resource.create(
        {
            "service.name": f"{settings.PROJECT_NAME}-worker",
            "service.version": "0.1.0",
            "deployment.environment": settings.PROJECT_ENV,
        }
    )

    provider = TracerProvider(resource=resource)

    if settings.OTEL_EXPORTER_OTLP_ENDPOINT:
        otlp_exporter = OTLPSpanExporter(
            endpoint=settings.OTEL_EXPORTER_OTLP_ENDPOINT,
            insecure=settings.PROJECT_ENV != "prod",
        )
        provider.add_span_processor(BatchSpanProcessor(otlp_exporter))
    elif settings.PROJECT_ENV == "local":
        provider.add_span_processor(BatchSpanProcessor(ConsoleSpanExporter()))

    trace.set_tracer_provider(provider)


def instrument_app(app: FastAPI) -> None:
    """Instrument FastAPI and outgoing HTTP clients."""
    FastAPIInstrumentor.instrument_app(
        app,
        excluded_urls="health",
    )
    HTTPXClientInstrumentor().instrument()


def get_tracer(name: str = __name__) -> trace.Tracer:
    """Get a tracer instance for manual instrumentation."""
    return trace.get_tracer(name)
