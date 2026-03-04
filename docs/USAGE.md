# How to Use juny

[English](./USAGE.md) | [한국어](./USAGE.ko.md)

juny is a real-time multimodal AI assistant. A **Host** (primary user with camera/audio streaming) and a **Concierge** (caregiver monitoring and audio intervention) connect to the same LiveKit Room, where AI analyzes the Host's stream in real time.

---

## Prerequisites

- [mise](https://mise.jdx.dev/) (polyglot tool manager)
- Docker (for local PostgreSQL, Redis, MinIO)

```bash
# Install all tool versions (Node, Python, Flutter, Terraform, etc.)
mise install
```

---

## Quick Start

### 1. Start Local Infrastructure

```bash
mise infra:up
```

This launches via Docker Compose:

| Service | Host Port | Credentials |
|---------|-----------|-------------|
| PostgreSQL 16 | `5433` | postgres / postgres |
| Redis 7 | `6380` | — |
| MinIO (S3-compatible) | `9010` (API), `9011` (console) | minioadmin / minioadmin |

### 2. Configure Environment

```bash
cp apps/api/.env.example apps/api/.env
# Edit .env — set JWT_SECRET, GEMINI_API_KEY, LIVEKIT_* as needed
```

For mobile runtime configuration, pass values via `--dart-define`:

```bash
cd apps/mobile
flutter run \
  --dart-define=API_BASE_URL=http://localhost:8200 \
  --dart-define=LIVEKIT_URL=wss://<your-livekit-host>
```

### 3. Run Database Migrations

```bash
mise db:migrate
```

### 4. Start Development Servers

```bash
# API + Worker (backend)
mise dev

# Or API + Mobile (full stack)
mise dev:mobile
```

The API server runs on **port 8200** (`http://localhost:8200`).
The Worker runs on **port 8280** (`http://localhost:8280`).

---

## Core Workflows

### Authentication (OAuth + JWT)

1. User authenticates via Google OAuth on mobile
2. Mobile sends the OAuth token to `POST /api/v1/auth/login`
3. Backend re-verifies with the provider, creates/finds the user, and issues JWT tokens
4. All subsequent API calls use `Authorization: Bearer <access_token>`

> Note: The current mobile app UI supports Google sign-in. The backend OAuth
> API can validate Google/GitHub/Facebook tokens.

```
POST   /api/v1/auth/login           — Exchange OAuth token for JWT
POST   /api/v1/auth/refresh         — Refresh access token
POST   /api/v1/auth/logout          — Invalidate session
```

See [AUTH.md](./AUTH.md) for full details.

### Users

```
GET    /api/v1/users/me             — Get current user profile
PATCH  /api/v1/users/me             — Update current user profile
DELETE /api/v1/users/me             — Delete current user account
GET    /api/v1/users/me/export      — Export current user data (GDPR)
GET    /api/v1/users                — List all users (ORGANIZATION only)
GET    /api/v1/users/{user_id}      — Get user by ID
PATCH  /api/v1/users/{user_id}/role — Update user role
DELETE /api/v1/users/{user_id}      — Delete user
```

### Real-time AI Session (LiveKit + Gemini)

1. Authenticated user requests a LiveKit token: `GET /api/v1/live/token?room_name=...&role=host`
2. Host connects to the LiveKit Room with camera and microphone
3. Host opens a WebSocket bridge: `WS /api/v1/live/ws?token=...&room=...`
4. The backend streams Host's audio/video to Gemini Multimodal Live API
5. Gemini analyzes the stream and can invoke tools:
   - **log_wellness** — Record wellness observation (normal / warning / emergency)
   - **register_medication** — Add a medication schedule
   - **scan_medication_schedule** — Batch extract medications from camera feed
   - **confirm_medication** — Mark a medication as taken by name
   - **start_navigation** — Start walking navigation to a destination
   - **cancel_navigation** — Cancel the active navigation session
   - **get_navigation_step** — Get current/next navigation instruction
6. Concierge joins the same Room to monitor and intervene via audio

### Medication Management

```
POST   /api/v1/medications              — Create medication schedule
GET    /api/v1/medications?host_id=     — List medications (paginated)
GET    /api/v1/medications/{id}         — Get single medication
PATCH  /api/v1/medications/{id}         — Update (e.g., mark as taken)
DELETE /api/v1/medications/{id}         — Delete medication
GET    /api/v1/medications/adherence?host_id=&start_date=&end_date= — Medication adherence stats
```

### Wellness Logging

```
POST   /api/v1/wellness             — Create wellness log
GET    /api/v1/wellness?host_id=    — List logs (paginated)
GET    /api/v1/wellness/{id}        — Get single log
GET    /api/v1/wellness/trends?host_id=&start_date=&end_date= — Wellness trend analysis
```

### Care Relations (RBAC)

```
POST   /api/v1/relations            — Create host-caregiver relation
GET    /api/v1/relations?host_id=   — List by host
GET    /api/v1/relations?caregiver_id= — List by caregiver
PATCH  /api/v1/relations/{id}       — Update (deactivate, change role)
DELETE /api/v1/relations/{id}       — Delete relation
```

Roles: `host`, `concierge`, `care_worker`, `organization`. A Host cannot be assigned a caregiver role.

### Navigation

```
POST   /api/v1/navigation/sessions              — Start navigation session
GET    /api/v1/navigation/sessions/active        — Get active session (by host_id)
GET    /api/v1/navigation/sessions/{session_id}  — Get session by ID
POST   /api/v1/navigation/sessions/{session_id}/cancel  — Cancel session
POST   /api/v1/navigation/sessions/{session_id}/reroute — Reroute from current location
POST   /api/v1/navigation/waypoints             — Record GPS waypoint
POST   /api/v1/navigation/waypoints/batch       — Record multiple waypoints
GET    /api/v1/navigation/location/{host_id}    — Get latest location
GET    /api/v1/navigation/trace/{session_id}    — Get waypoint trace
```

### Notifications

```
POST   /api/v1/notifications/device-tokens      — Register device token
GET    /api/v1/notifications/device-tokens       — List active device tokens
DELETE /api/v1/notifications/device-tokens/{id}  — Deactivate device token
```

### Notification Logs

```
GET    /api/v1/notification-logs                  — List notification logs
GET    /api/v1/notification-logs/preferences      — Get notification preferences
PUT    /api/v1/notification-logs/preferences      — Update notification preferences
PATCH  /api/v1/notification-logs/{log_id}/status  — Update delivery status
```

### Files

```
POST   /api/v1/files/upload         — Upload file (max 10 MB)
GET    /api/v1/files/{key}          — Download file (signed URL redirect)
DELETE /api/v1/files/{key}          — Delete file
```

### Admin

```
POST   /api/v1/admin/cleanup              — Clean up old data
GET    /api/v1/admin/inactive-relations    — List inactive relations
GET    /api/v1/admin/wellness/aggregate    — Daily wellness stats
POST   /api/v1/admin/tokens/deactivate    — Deactivate failed FCM tokens
GET    /api/v1/admin/audit-logs            — List audit logs
GET    /api/v1/admin/export/{user_id}     — Export user data (GDPR)
```

---

## Common Commands

All commands use mise. Run `mise tasks --all` for the full list.

| Command | Description |
|---------|-------------|
| `mise dev` | Start API + Worker |
| `mise dev:mobile` | Start API + Mobile |
| `mise test` | Run all backend tests |
| `mise lint` | Lint all apps |
| `mise format` | Format all apps |
| `mise typecheck` | Type-check API (mypy) |
| `mise db:migrate` | Run Alembic migrations |
| `mise gen:api` | Regenerate OpenAPI schema + mobile client |
| `mise i18n:build` | Build i18n files |
| `mise tokens:build` | Build design tokens |
| `mise infra:up` / `infra:down` | Start / stop local Docker services |

### Per-app commands

```bash
mise //apps/api:dev | :test | :lint | :format | :typecheck | :migrate
mise //apps/worker:dev | :test | :lint | :format
mise //apps/mobile:dev | :build | :test | :lint | :format | :gen:api | :gen:l10n
```

### Running a single test

```bash
# API
cd apps/api && uv run pytest tests/test_health.py -v
cd apps/api && uv run pytest tests/test_health.py::test_health_check -v

# E2E (requires Docker PostgreSQL)
cd apps/api && uv run pytest tests/e2e/ -v

# Mobile
cd apps/mobile && flutter test
```

---

## Code Generation Pipeline

After changing API endpoints:

```bash
mise gen:api
```

This triggers:
1. FastAPI exports `openapi.json`
2. `swagger_parser` generates mobile Retrofit clients + Freezed models

---

## Project Structure

```
juny/
├── apps/
│   ├── api/           # FastAPI backend (port 8200)
│   ├── worker/        # Background task worker (port 8280, Cloud Tasks / Pub/Sub)
│   ├── mobile/        # Flutter mobile app
│   └── infra/         # Terraform (GCP Cloud Run, Cloud SQL, etc.)
├── packages/
│   ├── design-tokens/ # OKLCH tokens → Flutter theme
│   └── i18n/          # ARB source → Flutter localization
├── mise.toml          # Monorepo task runner
└── CLAUDE.md          # AI coding assistant instructions
```

---

## Environment Variables

Key variables in `apps/api/.env`:

| Variable | Description | Default |
|----------|-------------|---------|
| `DATABASE_URL` | Async PostgreSQL connection | `postgresql+asyncpg://...localhost:5433/juny` |
| `JWT_SECRET` | JWT signing secret | (change in production) |
| `REDIS_URL` | Redis connection (optional) | `redis://localhost:6380` |
| `LIVEKIT_API_URL` | LiveKit server URL | — |
| `LIVEKIT_API_KEY` | LiveKit API key | — |
| `LIVEKIT_API_SECRET` | LiveKit API secret | — |
| `AI_PROVIDER` | AI backend (`gemini` or `openai`) | `gemini` |
| `GEMINI_API_KEY` | Gemini API key (AI Studio) | — |
| `STORAGE_BACKEND` | Object storage (`gcs`, `s3`, `minio`) | `minio` |

See `apps/api/.env.example` for the full list.

---

## Deployment

GitHub Actions deploys to GCP Cloud Run on push to `main` (per-app path filters). Uses Workload Identity Federation (keyless, no service account keys).

- **API** → Cloud Run (`us-central1`)
- **Worker** → Cloud Run (`us-central1`)
- **Mobile** → App Store / Google Play via Fastlane

---

## Documentation

- [AUTH.md](./AUTH.md) — Authentication architecture
- [WHY.md](./WHY.md) — Tech stack rationale
