"""Job package — auto-discovers and registers all job modules."""

import importlib
import pkgutil

import structlog

logger = structlog.get_logger(__name__)


def _auto_discover() -> None:
    """Import all sub-modules so their register_job() calls execute."""
    package_path = __path__
    for module_info in pkgutil.iter_modules(package_path):
        if module_info.name == "base":
            continue
        module_name = f"{__name__}.{module_info.name}"
        try:
            importlib.import_module(module_name)
        except Exception:
            logger.exception("job_module_import_failed", module=module_name)


_auto_discover()
