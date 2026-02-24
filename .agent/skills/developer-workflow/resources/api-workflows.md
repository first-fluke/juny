# API Generation Workflows

Generate API clients from OpenAPI schemas.

## OpenAPI to Client Pipeline

```bash
# 1. Generate OpenAPI schema from backend
mise run //apps/api:gen:openapi

# 2. Generate Dart client for mobile
mise run //apps/mobile:gen:api
```

## Backend Tasks

```toml
# apps/api/mise.toml
[tasks.gen:openapi]
description = "Generate OpenAPI schema"
run = "uv run python -c 'from src.main import app; import json; print(json.dumps(app.openapi()))' > openapi.json"
```

## Mobile Tasks

```toml
# apps/mobile/mise.toml
[tasks.gen:api]
description = "Generate API client from OpenAPI"
depends = ["//apps/api:gen:openapi"]
run = "flutter pub run swagger_parser"
```

## Root-Level API Generation

```toml
# Root mise.toml
[tasks.gen:api]
description = "Generate API clients for mobile"
depends = [
  "//apps/api:gen:openapi",
]
run = [{ tasks = ["//apps/mobile:gen:api"] }]
```
