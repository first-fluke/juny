# juny 사용 가이드

[English](./USAGE.md) | [한국어](./USAGE.ko.md)

juny는 실시간 멀티모달 AI 어시스턴트입니다. **Host**(카메라/오디오 스트리밍 주 사용자)와 **Concierge**(모니터링 및 오디오 개입)가 같은 LiveKit Room에 접속하고, AI가 Host의 스트림을 실시간 분석합니다.

---

## 사전 요구 사항

- [mise](https://mise.jdx.dev/) (폴리글랏 도구 관리자)
- Docker (로컬 PostgreSQL, Redis, MinIO 용)

```bash
# 모든 도구 버전 설치 (Node, Python, Flutter, Terraform 등)
mise install
```

---

## 빠른 시작

### 1. 로컬 인프라 실행

```bash
mise infra:up
```

Docker Compose로 다음 서비스가 시작됩니다:

| 서비스 | 호스트 포트 | 인증 정보 |
|--------|-----------|-----------|
| PostgreSQL 16 | `5433` | postgres / postgres |
| Redis 7 | `6380` | — |
| MinIO (S3 호환) | `9010` (API), `9011` (콘솔) | minioadmin / minioadmin |

### 2. 환경 설정

```bash
cp apps/api/.env.example apps/api/.env
# .env 편집 — JWT_SECRET, GEMINI_API_KEY, LIVEKIT_* 등 설정
```

### 3. 데이터베이스 마이그레이션

```bash
mise db:migrate
```

### 4. 개발 서버 시작

```bash
# API + Worker (백엔드)
mise dev

# 또는 API + Mobile (풀 스택)
mise dev:mobile
```

API 서버는 **포트 8200** (`http://localhost:8200`)에서 실행됩니다.

---

## 핵심 워크플로우

### 인증 (OAuth + JWT)

1. 사용자가 모바일에서 OAuth 제공자(Google, GitHub, Facebook)로 인증
2. 모바일이 OAuth 토큰을 `POST /api/v1/auth/login`으로 전송
3. 백엔드가 제공자와 재검증, 사용자 생성/조회 후 JWT 토큰 발급
4. 이후 모든 API 호출에 `Authorization: Bearer <access_token>` 사용

자세한 내용은 [AUTH.ko.md](./AUTH.ko.md) 참고.

### 실시간 AI 세션 (LiveKit + Gemini)

1. 인증된 사용자가 LiveKit 토큰 요청: `GET /api/v1/live/token?room_name=...&role=host`
2. Host가 카메라와 마이크로 LiveKit Room에 접속
3. Host가 WebSocket 브릿지 연결: `WS /api/v1/live/ws?token=...&room=...`
4. 백엔드가 Host의 오디오/비디오를 Gemini Multimodal Live API로 스트리밍
5. Gemini가 스트림을 분석하고 도구 호출 가능:
   - **log_wellness** — 건강 관찰 기록 (normal / warning / emergency)
   - **register_medication** — 복약 일정 추가
   - **scan_medication_schedule** — 카메라 피드에서 복약 정보 일괄 추출
6. Concierge가 같은 Room에 접속하여 모니터링 및 오디오로 개입

### 복약 관리

```
POST   /api/v1/medications          — 복약 일정 생성
GET    /api/v1/medications?host_id= — 복약 목록 조회 (페이지네이션)
GET    /api/v1/medications/{id}     — 단건 조회
PATCH  /api/v1/medications/{id}     — 수정 (예: 복용 완료 표시)
DELETE /api/v1/medications/{id}     — 삭제
```

### 웰니스 로깅

```
POST   /api/v1/wellness             — 웰니스 로그 생성
GET    /api/v1/wellness?host_id=    — 로그 목록 조회 (페이지네이션)
GET    /api/v1/wellness/{id}        — 단건 조회
```

### 돌봄 관계 (RBAC)

```
POST   /api/v1/relations            — Host-Caregiver 관계 생성
GET    /api/v1/relations?host_id=   — Host 기준 조회
GET    /api/v1/relations?caregiver_id= — Caregiver 기준 조회
PATCH  /api/v1/relations/{id}       — 수정 (비활성화, 역할 변경)
DELETE /api/v1/relations/{id}       — 삭제
```

역할: `host`, `concierge`, `care_worker`, `organization`. Host는 caregiver 역할을 가질 수 없습니다.

---

## 주요 명령어

모든 명령어는 mise를 사용합니다. `mise tasks --all`로 전체 목록을 확인할 수 있습니다.

| 명령어 | 설명 |
|--------|------|
| `mise dev` | API + Worker 시작 |
| `mise dev:mobile` | API + Mobile 시작 |
| `mise test` | 전체 백엔드 테스트 |
| `mise lint` | 전체 린트 |
| `mise format` | 전체 포맷 |
| `mise typecheck` | API 타입 체크 (mypy) |
| `mise db:migrate` | Alembic 마이그레이션 실행 |
| `mise gen:api` | OpenAPI 스키마 + 모바일 클라이언트 재생성 |
| `mise i18n:build` | i18n 파일 빌드 |
| `mise tokens:build` | 디자인 토큰 빌드 |
| `mise infra:up` / `infra:down` | 로컬 Docker 서비스 시작 / 중지 |

### 앱별 명령어

```bash
mise //apps/api:dev | :test | :lint | :format | :typecheck | :migrate
mise //apps/worker:dev | :test | :lint | :format
mise //apps/mobile:dev | :build | :test | :lint | :format | :gen:api | :gen:l10n
```

### 단일 테스트 실행

```bash
# API
cd apps/api && uv run pytest tests/test_health.py -v
cd apps/api && uv run pytest tests/test_health.py::test_health_check -v

# E2E (Docker PostgreSQL 필요)
cd apps/api && uv run pytest tests/e2e/ -v

# Mobile
cd apps/mobile && flutter test test/core/utils_test.dart
```

---

## 코드 생성 파이프라인

API 엔드포인트 변경 후:

```bash
mise gen:api
```

동작 과정:
1. FastAPI가 `openapi.json` 내보내기
2. `swagger_parser`가 모바일 Retrofit 클라이언트 + Freezed 모델 생성

---

## 프로젝트 구조

```
juny/
├── apps/
│   ├── api/           # FastAPI 백엔드 (포트 8200)
│   ├── worker/        # 백그라운드 태스크 워커 (Cloud Tasks / Pub/Sub)
│   ├── mobile/        # Flutter 모바일 앱
│   └── infra/         # Terraform (GCP Cloud Run, Cloud SQL 등)
├── packages/
│   ├── design-tokens/ # OKLCH 토큰 → Flutter 테마
│   └── i18n/          # ARB 소스 → Flutter 로컬라이제이션
├── mise.toml          # 모노레포 태스크 러너
└── CLAUDE.md          # AI 코딩 어시스턴트 지침
```

---

## 환경 변수

`apps/api/.env`의 주요 변수:

| 변수 | 설명 | 기본값 |
|------|------|--------|
| `DATABASE_URL` | 비동기 PostgreSQL 연결 | `postgresql+asyncpg://...localhost:5433/juny` |
| `JWT_SECRET` | JWT 서명 시크릿 | (프로덕션에서 변경 필수) |
| `REDIS_URL` | Redis 연결 (선택) | `redis://localhost:6380` |
| `LIVEKIT_API_URL` | LiveKit 서버 URL | — |
| `LIVEKIT_API_KEY` | LiveKit API 키 | — |
| `LIVEKIT_API_SECRET` | LiveKit API 시크릿 | — |
| `AI_PROVIDER` | AI 백엔드 (`gemini` 또는 `openai`) | `gemini` |
| `GEMINI_API_KEY` | Gemini API 키 (AI Studio) | — |
| `STORAGE_BACKEND` | 오브젝트 스토리지 (`gcs`, `s3`, `minio`) | `minio` |

전체 목록은 `apps/api/.env.example` 참고.

---

## 배포

GitHub Actions가 `main` 브랜치 push 시 GCP Cloud Run으로 배포 (앱별 경로 필터). Workload Identity Federation 사용 (키리스, 서비스 계정 키 불필요).

- **API** → Cloud Run (`us-central1`)
- **Worker** → Cloud Run (`us-central1`)
- **Mobile** → App Store / Google Play (Fastlane)

---

## 문서

- [AUTH.ko.md](./AUTH.ko.md) — 인증 아키텍처
- [WHY.ko.md](./WHY.ko.md) — 기술 스택 선정 이유
