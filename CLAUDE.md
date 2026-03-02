# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**juny** — 실시간 멀티모달 AI 어시스턴트. Host(카메라/오디오 스트리밍 주 사용자)와 Concierge(모니터링 및 오디오 개입)가 같은 LiveKit Room에 접속하고, AI가 Host의 스트림을 실시간 분석하는 구조. 역할명은 `host`/`concierge` 사용 — 시니어에 한정되지 않고 장애인 등으로 확장 가능한 중립적 명칭. Monorepo with four apps and two shared packages, orchestrated by **mise** (monorepo mode with `//path:task` syntax). No root package.json — mise is the sole task runner.

| App/Package | Stack | Package Manager |
|---|---|---|
| `apps/api` | Python 3.12, FastAPI, SQLAlchemy async, Alembic, Redis, LiveKit (WebRTC), Gemini Multimodal Live API | uv + poethepoet |
| `apps/worker` | Python 3.12, FastAPI, Cloud Tasks/Pub/Sub, tenacity | uv + poethepoet |
| `apps/mobile` | Flutter 3.38, Dart, Riverpod 3, Freezed, go_router | flutter/dart |
| `apps/infra` | Terraform, GCP (Cloud Run, Cloud SQL, etc.) | terraform |
| `packages/design-tokens` | TypeScript, OKLCH tokens → Flutter theme | bun |
| `packages/i18n` | ARB source → Flutter ARB (mobile) | bun |

## Common Commands

All commands use mise. Run `mise tasks --all` to see everything.

```bash
# Root-level
mise dev                    # Start all services (api + worker)
mise test                   # Test all apps
mise lint                   # Lint all apps
mise format                 # Format all apps
mise typecheck              # Type check all apps
mise gen:api                # Generate OpenAPI schema + mobile API client
mise i18n:build             # Build i18n files
mise tokens:build           # Build design tokens

# Local infrastructure (PostgreSQL 16, Redis 7, MinIO)
mise infra:up               # Start
mise infra:down             # Stop

# Database
mise db:migrate             # Run migrations
mise //apps/api:migrate:create "description"  # Create new migration
cd apps/api && uv run alembic downgrade -1    # Rollback one migration
```

### Per-app commands (pattern: `mise //apps/<app>:<task>`)

```bash
# API
mise //apps/api:dev | :test | :lint | :format | :typecheck | :migrate

# Worker
mise //apps/worker:dev | :test | :lint | :format

# Mobile
mise //apps/mobile:dev | :build | :test | :lint | :format | :gen:api | :gen:l10n
```

### Running a single test

```bash
# API — single file or test function
cd apps/api && uv run pytest tests/test_health.py -v
cd apps/api && uv run pytest tests/test_health.py::test_health_check -v

# Mobile
cd apps/mobile && flutter test test/core/utils_test.dart
```

### Underlying tool commands (when mise is unavailable)

```bash
# API/Worker
cd apps/api && uv run poe dev|test|lint|format|typecheck|migrate
```

## Architecture

### API (`apps/api/src/`)

Feature-based module structure following **router → service → repository → schemas/models**:

- `auth/` — Authentication (PyJWT (JWS), integrated with better-auth)
- `users/` — User management
- `relations/` — CareRelation (N:M host↔caregiver, 4-Tier RBAC)
- `wellness/` — WellnessLog (append-only, JSONB details)
- `medications/` — Medication schedules (is_taken tracking)
- `navigation/` — NavigationSession, LocationWaypoint (실시간 GPS 네비게이션, off-route 감지)
- `common/` — Shared enums (`UserRole`, `WellnessStatus`, `NavigationStatus`), models (`PaginatedResponse[T]`), utilities
- `lib/` — Infrastructure: database, dependencies (FastAPI DI), AI providers (ABC-based, `lib/ai/`), maps provider (ABC-based, `lib/maps/`), LiveKit WebRTC provider (`lib/livekit/`), storage (ABC-based), rate limiting, OpenTelemetry + structlog
- `routers/` — Cross-domain routers (e.g., `live.py` for real-time WebSocket)

Async-first with explicit session passing. Business logic lives in services, not routers. Do NOT modify or break existing `auth` or `health` routers.

### Worker (`apps/worker/src/`)

HTTP-based background worker: `routers/` receive tasks from Cloud Tasks/Pub/Sub, `jobs/` contain execution logic, `lib/` has shared infrastructure.

### Mobile (`apps/mobile/lib/`)

Feature-first with Riverpod 3 DI, Freezed models, go_router, Retrofit+Dio networking (API client generated from OpenAPI via swagger_parser).

### Shared Packages

- **design-tokens**: Single source of truth (`src/tokens.ts`, OKLCH color space) → generates `generated_theme.dart` (mobile)
- **i18n**: ARB files (en/ko/ja) → Flutter ARB for mobile.

### Code Generation Pipeline

`mise gen:api` triggers: API OpenAPI schema export → swagger_parser generates mobile client (Retrofit). Run this after changing API endpoints.

## Commit Conventions

Conventional Commits enforced by commitlint + git hooks:

```
<type>(<scope>): <lower-case subject>
```

- **Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`
- **Scopes** (required): `api`, `mobile`, `worker`, `infra`, `deps`, `docs`, `root`

Branch naming: `feature/*`, `fix/*`, `hotfix/*`, `release/*`

## Linting & Formatting

| Language | Tool | Config |
|---|---|---|
| Python | Ruff | `apps/api/ruff.toml`, `apps/worker/ruff.toml` — double quotes, 4-space indent, 88 chars |
| Dart | very_good_analysis | `apps/mobile/analysis_options.yaml` |
| Terraform | `terraform fmt` | Built-in |
| Python types | mypy (strict) | `apps/api/pyproject.toml` — pydantic plugin enabled |

## Testing

| App | Framework | Config |
|---|---|---|
| API | pytest + pytest-asyncio | `apps/api/pyproject.toml` — `asyncio_mode = "auto"`, testpaths: `tests/` |
| Worker | pytest + pytest-asyncio | `apps/worker/pyproject.toml` — `asyncio_mode = "auto"` |
| Mobile | flutter_test + mocktail | `test/**/*_test.dart` |
| Design tokens | Vitest | `packages/design-tokens/` |

## Key Patterns

- **Clean Code 원칙**: 임포트는 반드시 파일 최상단에 배치. `# noqa: E402`로 하단 임포트를 회피하지 않는다. 함수 내부 임포트는 순환 참조 방지나 lazy loading 등 명확한 사유가 있을 때만 허용. lazy loading 주장 시 해당 패키지가 실제로 optional dependency인지 `pyproject.toml`에서 확인 필수 — required dependency를 함수 내부에서 import하지 않는다.
- **API 버전 프리픽스**: 모든 API 엔드포인트는 `/api/v1/` 프리픽스 필수. `main.py`에서 `APIRouter(prefix="/api/v1")`로 라우터를 묶어 등록.
- **확장성 우선**: 하드코딩 대신 자동 탐색/등록 패턴 사용 (예: `pkgutil.iter_modules()`로 tool 자동 로딩). 새 모듈 추가 시 기존 코드 수정이 불필요하도록 설계.
- **한글 응답**: 사용자에게 한글로 응답할 것.
- **Python**: Type hints required everywhere. Pydantic models for request/response. ABCs for extensible providers (AI, storage). SQLAlchemy 2.0 style only. All code must pass `ruff check`, `ruff format`, and `mypy` before finalizing.
- **File naming**: kebab-case across the project. Generated files use `*.gen.ts` suffix.
- **Auth**: PyJWT (JWT/JWS) on API side.
- **Observability**: OpenTelemetry instrumentation (FastAPI, SQLAlchemy, httpx, Redis) + structlog.
- **Real-time AI**: Gemini Multimodal Live API (`google-genai`, NOT deprecated `google-generativeai`) + LiveKit (`livekit-api`) for WebRTC. Tool Registry 패턴으로 Gemini Function Calling 도구를 관리 — core websocket loop을 건드리지 않고 새 도구 추가 가능.
- **mypy + untyped libs**: `livekit`, `google.genai`는 type stub 없음 — `pyproject.toml`에 `[[tool.mypy.overrides]]` ignore_missing_imports 필요
- **4-Tier RBAC**: `HOST`, `CONCIERGE`, `CARE_WORKER`, `ORGANIZATION`. CareRelation은 N:M (한 host에 여러 caregiver, 한 caregiver가 여러 host 관리). HOST는 caregiver 역할 불가 (서비스 레이어에서 검증).
- **도메인 모듈 4계층**: 각 feature 폴더는 `model.py` → `schemas.py` → `repository.py` → `service.py` → `router.py`. repository는 데이터 접근만, service는 비즈니스 로직만, router는 HTTP 핸들링만 담당. 계층 간 책임을 혼합하지 않는다.
- **Alembic env.py**: `_include_object` 필터로 모델에 정의된 테이블만 관리. 레거시/외부 테이블을 무시하여 autogenerate 충돌 방지.
- **테스트 인증**: `tests/conftest.py`에 `authed_client` fixture 제공 (`create_access_token` → Bearer header). 서비스 테스트는 `@patch("src.xxx.repository.method")`로 repository를 mock하여 격리.
- **AI Tool context 주입**: `get_tool_handler(context={"db": session, "host_id": uuid})` 패턴으로 WebSocket에서 DB 세션을 도구에 전달.
- **Testing**: 외부 의존성(LiveKit API, Gemini WebSocket 등)은 반드시 mock 처리. 네트워크 호출 없이 테스트가 동작해야 함.
- **AI Tools (Function Calling)**: Tool의 `execute()`에서 절대 직접 `db.add()`/`db.flush()` 하지 않음 — 반드시 service 함수 호출 (4-layer 준수). Tool 테스트 시 service 함수를 patch.
- **WebSocket 인증**: `?token=` query param → `decode_token()` → `token_type == "access"` 검증. `exp` 만료는 PyJWT가 `decode()` 시 자동 검증. 실패 시 `WS_1008_POLICY_VIOLATION`.
- **asyncio bidirectional streaming**: 양방향 무한 루프 coroutine은 `asyncio.create_task` + `try/finally` cancel 패턴 사용 (`asyncio.gather`만 쓰면 후속 코드 unreachable).
- **Ruff S105/S106 주의**: 테스트에서 `token_type = "access"` 할당 → S105 오탐, `token="fcm-token-abc"` 함수 인자 → S106 오탐. 각각 `# noqa: S105`, `# noqa: S106` 필요.
- **테스트 결정론**: fixture의 UUID는 `uuid.uuid4()` 대신 deterministic 값 사용 (e.g., `"00000000-0000-4000-8000-000000000099"`).
- **Mock 구현 로그**: mock/stub 구현체는 `logger.warning` + `_mock` suffix 이벤트명 사용 (real 구현과 구별).
- **Debug 도구 게이팅**: `PingTool` 등 개발용 도구는 `settings.PROJECT_ENV != "prod"` 조건으로 등록.
- **Alembic 마이그레이션 전략**: 첫 배포 전에는 마이그레이션을 단일 `0001_initial.py`로 유지. 불필요한 incremental migration 누적 금지.
- **OpenAPI 재생성**: 엔드포인트 변경 후 `mise gen:api` 실행 (openapi.json 생성 → 모바일 swagger_parser 클라이언트 자동 재생성).
- **LiveKit role 동기화**: `LiveRole` Literal (`livekit/auth.py`), `_ROLE_SOURCES` dict, 라우터 Query param — 3곳 모두 역할 추가/변경 시 동기화 필수.
- **OAuth User 모델**: `provider`(OAuth 제공자명) + `provider_id`(제공자별 사용자 ID) 컬럼 필수. 로그인 시 auth router에서 저장.
- **리소스 인가 패턴**: 도메인 라우터에서 `authorize_host_access(db, user=user, host_id=...)` / `authorize_relation_access(db, user=user, relation=...)` 호출 필수 (`lib/authorization.py`). 인증(CurrentUser)과 인가(리소스 접근 권한)를 혼동하지 않는다.
- **auth 모듈도 4계층 준수**: `auth/` 역시 `router.py` → `service.py` → `repository.py` 구조. login/refresh 로직은 service에, DB 쿼리는 repository에 위치. 라우터에 `db.add()` / `select()` 직접 사용 금지.
- **`TYPE_CHECKING` + `cast` 주의**: `if TYPE_CHECKING:` 블록의 심볼을 `cast(SomeType, ...)` 첫 인자로 사용하면 runtime NameError. 문자열 리터럴 `cast("module.Type", ...)` 사용.
- **Settings 캐시**: `get_settings()`가 `@lru_cache`이므로 `.env` 변경 시 서버 프로세스 완전 재시작 필요 (uvicorn auto-reload로는 캐시 미갱신).
- **Seed 데이터 UUID 체계**: `scripts/seed.py`의 deterministic UUID — Users: `...0100`~, Relations: `...0200`~, Wellness: `...0300`~, Medications: `...0400`~. 테스트 토큰 생성 시 실제 seed UUID 확인 필수.

- **E2E 테스트 (tests/e2e/)**: 실제 PostgreSQL 사용. DB 생성은 sync fixture (session scope), engine은 function-scoped async. ASGI transport는 별도 세션 사용하므로 transaction rollback 불가 — `TRUNCATE CASCADE`로 격리. seed fixture에서 `flush()` 대신 `commit()` 필수.
- **commitlint subject-case**: subject는 lower-case 시작 필수. `add E2E tests` (X) → `add e2e tests` (O).
- **Flutter build_runner**: `mise exec -- dart run build_runner build --delete-conflicting-outputs`. `dart`/`flutter` 직접 실행 불가 — 반드시 `mise exec --` 접두사 사용.
- **Ruff S608 주의**: E2E 테스트에서 `CREATE DATABASE` 등 관리 SQL이 SQL injection으로 오탐 — `# noqa: S608` 필요. 단, f-string 첫 줄에만 주석 추가.

- **FastAPI status codes**: `HTTP_422_UNPROCESSABLE_ENTITY`는 deprecated — `HTTP_422_UNPROCESSABLE_CONTENT` 사용. `HTTP_413_REQUEST_ENTITY_TOO_LARGE`도 deprecated — `HTTP_413_CONTENT_TOO_LARGE` 사용.
- **pytest 0 warnings 원칙**: 테스트 실행 시 warning이 있으면 반드시 원인을 찾아 수정. 경고를 무시하지 않는다.
- **로컬 포트**: API는 `8200`, Worker는 `8280`. 기본 FastAPI 포트(8000) 아님.
- **커밋 작성자**: Co-Authored-By 라인 추가하지 않는다.
- **mise Flutter 플러그인**: `vfox:mise-plugins/vfox-flutter` 사용 (기본 asdf 플러그인은 3.22.1까지만 지원). `mise.toml`에서 `"vfox:mise-plugins/vfox-flutter" = "3"` 형태로 선언.
- **PyJWT InsecureKeyLengthWarning**: 테스트에서 짧은 시크릿 사용 시 발생하는 경고 경로는 `jwt.warnings.InsecureKeyLengthWarning` (`jwt.exceptions`가 아님). `@pytest.mark.filterwarnings("ignore::jwt.warnings.InsecureKeyLengthWarning")` 사용.
- **Optional dep 테스트 mock**: `firebase_admin`, `google.cloud.tasks_v2` 등 optional dep를 테스트할 때 `patch.dict(sys.modules, {"firebase_admin": MagicMock(), ...})` + `sys.modules.pop("src.lib.xxx", None)` (캐시된 모듈 제거) 패턴 사용.
- **`lib/` vs 도메인 모듈**: `lib/notifications/`는 provider 인프라 (ABC + factory), `src/notifications/`는 DeviceToken 도메인 4계층. `lib/storage/`, `lib/maps/`도 동일 패턴 — provider 인프라만 담당하고 비즈니스 로직은 도메인 모듈에 위치.
- **Navigation 모듈**: `navigation/`는 실시간 GPS 네비게이션 도메인. `NavigationSession` (경로 + 진행 상태) + `LocationWaypoint` (GPS 기록). `lib/maps/`는 MapProvider ABC (Google Maps 구현). AI tools: `start_navigation`, `cancel_navigation`, `get_navigation_step`. `live.py`에서 location 메시지 → waypoint 저장, off-route 감지, Gemini 컨텍스트 피드.
- **Router에서 repository 직접 import**: `navigation/router.py`처럼 router가 service와 repository를 모두 직접 import 가능 (`from src.navigation import repository, service`). `service.repository` 접근은 mypy strict에서 attr-defined 에러 발생.
- **데코레이터 타입 보존 (mypy strict)**: `Callable[..., object]` 반환 시 `untyped-decorator` 에러. `TypeVar("_F", bound=Callable[..., object])` + `Callable[[_F], _F]` 패턴 사용.
- **AsyncMock sync 메서드 주의**: `AsyncSession.add()`, `.expire()` 등은 sync — `AsyncMock()` 사용 시 `db.add = MagicMock()` 명시적 오버라이드 필요 (coroutine-never-awaited 방지).
- **Rate limiter 테스트 격리**: 로컬 Redis 실행 중이면 rate limit 상태 누적 → 429. `conftest.py`의 autouse fixture에서 `settings.REDIS_URL = None` 패치로 in-memory limiter 강제.
- **Blocking I/O → `asyncio.to_thread`**: 스토리지(MinIO/GCS), FCM, Cloud Tasks 등 sync 라이브러리 호출은 반드시 `asyncio.to_thread()`로 래핑. 이벤트 루프를 직접 블로킹하지 않는다.
- **Redis 캐시 싱글톤**: `lib/cache.py`의 `_get_redis_sync()`로 모듈 레벨 싱글톤 Redis 클라이언트 관리. 매 호출마다 `aclose()` 하지 않음. shutdown 시 `close_cache()` 호출 (`main.py` lifespan).
- **Rate limiter 구현**: `InMemoryRateLimiter`는 빈 키 자동 정리 (메모리 누수 방지). `RedisRateLimiter`는 Lua 스크립트(`_LUA_SLIDING_WINDOW`)로 ZADD+ZCARD 원자화. shutdown 시 `close_rate_limiters()` 호출 (`main.py` lifespan).
- **WebSocket TOCTOU 방지**: `_active_bridges` dict 접근 시 `_bridges_lock` (asyncio.Lock)으로 보호. 중복 연결 체크와 등록을 원자적으로 수행.
- **WebSocket location 핸들러 DB 세션**: `_handle_location()`은 장수 WebSocket 세션의 stale 객체 방지를 위해 `async with async_session_factory() as loc_db:` short-lived 세션 사용. reroute 후 `active_nav` 재할당 필수.
- **LIKE 와일드카드 이스케이프**: repository에서 `.ilike()` 사용 시 `_escape_like()`로 `%`, `_`, `\` 이스케이프. 사용자 입력이 와일드카드로 해석되는 것을 방지.
- **Worker 재시도 정책**: `_retry_if_server_error`로 HTTP 5xx만 재시도. 4xx 클라이언트 에러는 즉시 실패. `RETRYABLE_EXCEPTIONS`는 `ConnectError` + `TimeoutException`만 포함.
- **Worker 에러 응답 최소화**: 태스크 라우터의 에러 detail에 내부 job 목록을 노출하지 않음. `GET /tasks/jobs`로만 조회 가능.
- **CLAUDE.md gitignore**: CLAUDE.md가 `.gitignore`에 포함됨. 커밋 시 `git add -f CLAUDE.md` 필수.
- **`defaultdict` 빈 키 정리 주의**: `defaultdict(list)`에서 빈 키 삭제 후 early return하면 새 엔트리가 기록되지 않음. 삭제와 기록을 분리하여 정상 흐름으로 fall-through 시킬 것.

## Local Infrastructure

`apps/api/docker-compose.infra.yml` provides:
- PostgreSQL 16 — `localhost:5433` (postgres/postgres/juny)
- Redis 7 — `localhost:6380`
- MinIO — `localhost:9010` (API), `localhost:9011` (console), minioadmin/minioadmin

## CI/CD

GitHub Actions deploys to GCP Cloud Run on push to main (per-app path filters). PRs run Ruff + Flutter analyze via reviewdog. Release Please handles versioning. All GCP deployments use Workload Identity Federation (keyless).
