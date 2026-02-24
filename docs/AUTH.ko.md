# Stateless Token Authentication Architecture

## 개요

이 템플릿은 **stateful(상태 저장) 세션 기반 인증** 대신 **stateless(무상태) JWT(JWS) 인증 시스템**을 구현합니다. 인증 처리는 전적으로 백엔드에서 수행하며, 모바일 클라이언트는 토큰을 저장하고 전송하는 역할만 담당합니다.

## 아키텍처

```mermaid
sequenceDiagram
    participant User
    participant Mobile
    participant OAuthProvider
    participant Backend
    participant API

    User->>OAuthProvider: Social Login (OAuth)
    OAuthProvider->>Mobile: OAuth Access Token
    Mobile->>Backend: POST /api/v1/auth/login (OAuth Token)
    Backend->>Backend: OAuth Token Re-verification (Provider API)
    Backend->>Backend: User Creation/Update (DB)
    Backend->>Backend: JWT Token Issuance (access + refresh)
    Backend->>Mobile: JWT Token Return
    Mobile->>API: Authorization Header (access_token)
    API->>API: JWT Token Verification
    API->>User: Protected Resource Return
```

## 핵심 구성 요소

### 1. 백엔드 (FastAPI - `apps/api/`)

**필수 파일:**

- `src/lib/auth.py` - JWT 토큰 생성/검증, OAuth 검증
- `src/auth/router.py` - 인증 endpoint
- `src/users/model.py` - User DB 모델
- `src/lib/dependencies.py` - 인증용 dependency injection

**핵심 함수:**

- `create_access_token(user_id)` - 만료 1시간의 JWT access token 생성
- `create_refresh_token(user_id)` - 만료 7일의 JWT refresh token 생성
- `decode_token(token)` - JWT 토큰 검증 및 payload 추출
- `verify_oauth_token(provider, token)` - OAuth 토큰 재검증 (Google/GitHub/Facebook)
- `get_current_user(request)` - Authorization header에서 사용자 추출

**Endpoints:**

- `POST /api/v1/auth/login` - OAuth 로그인
- `POST /api/v1/auth/refresh` - 토큰 갱신
- `POST /api/v1/auth/logout` - 로그아웃

**보안:**

- JWT 서명 (HS256 / HMAC-SHA256)
- Access Token: 만료 1시간
- Refresh Token: 만료 7일
- Authorization header 기반 전송

## 토큰 관리

### Access Token

- **형식:** JWT (JSON Web Token, JWS)
- **알고리즘:** HS256 (HMAC-SHA256)
- **만료:** 1시간
- **저장 위치:** 모바일 디바이스 보안 저장소
- **사용:** API 요청 시 `Authorization: Bearer {token}` header

### Refresh Token

- **형식:** JWT (JWS)
- **알고리즘:** HS256
- **만료:** 7일
- **저장 위치:** 모바일 디바이스 보안 저장소
- **사용:** access token 만료 시 갱신에 사용

## 인증 플로우

### 1. 소셜 로그인

```
User: "Google 로그인" 탭
    ↓
Mobile: OAuth provider redirect
    ↓
OAuthProvider: OAuth access token 발급
    ↓
Mobile: OAuth access token 수신
    ↓
Mobile: POST /api/v1/auth/login { provider, access_token }
    ↓
Backend: OAuth token re-verification (Google API)
    ↓
Backend: User DB lookup/creation
    ↓
Backend: JWT token issuance (access: 1h, refresh: 7d)
    ↓
Mobile: JWT token 보안 저장소 저장
```

### 2. 보호된 API 요청

```
Mobile: API Request
    ↓
HTTP Client: access_token auto add to Authorization header
    ↓
Backend: Authorization header verification
    ↓
Backend: JWT token decoding
    ↓
Backend: user_id extraction
    ↓
Backend: User lookup in DB
    ↓
API: Protected resource return
```

### 3. 토큰 갱신 (자동)

```
Access Token Expired (1 hour)
    ↓
401 error on API request
    ↓
HTTP Client: auto use refresh_token
    ↓
Backend: POST /api/v1/auth/refresh
    ↓
Backend: New access_token issuance
    ↓
Mobile: 보안 저장소 업데이트
    ↓
Request auto retry
```

### 4. 로그아웃

```
User: "로그아웃" 탭
    ↓
Mobile: 저장된 토큰 삭제
    ↓
Mobile: POST /api/v1/auth/logout
    ↓
Backend: Logout processing (client token invalidation if needed)
```

## 보안 기능

### 1. JWT 서명

- **HMAC-SHA256:** 공유 비밀 키로 payload 서명
- **알고리즘:** HS256
- **무결성:** 서명을 통해 토큰이 변조되지 않았음을 보장
- **HTTPS:** 전송 계층 암호화가 토큰 payload를 전송 중 보호

### 2. Stateless 특성

- **서버 세션 없음:** 세션 상태를 서버에 저장할 필요 없음
- **확장 용이:** 로드 밸런싱이 쉬움
- **스케일 아웃:** 서버 증설이 쉬움

### 3. 토큰 만료 전략

- **Access Token:** 짧은 만료(1시간) - 보안 최적화
- **Refresh Token:** 긴 만료(7일) - 사용자 편의성
- **Auto Refresh:** 만료 시 자동 갱신

## 데이터베이스 스키마

### Users 테이블

```python
class User(Base):
    id: UUID (PK)
    email: String (unique, indexed)
    name: String (nullable)
    image: String (nullable)
    email_verified: Boolean (default: False)
    provider: String (nullable)       # OAuth provider: google | github | facebook
    provider_id: String (nullable)    # Provider별 사용자 ID
    role: String (default: "host")    # host | concierge | care_worker | organization
    created_at: DateTime
    updated_at: DateTime
```

## 환경 변수

### 백엔드 (apps/api/.env)

```bash
# JWT (stateless authentication)
JWT_SECRET=strong-secret-key-32-chars-or-more

# Database
DATABASE_URL=postgresql+asyncpg://postgres:postgres@localhost:5433/juny

# CORS
CORS_ORIGINS=http://localhost:3200,http://localhost:8080
```

## API Endpoints

### POST /api/v1/auth/login

**목적:** OAuth token을 백엔드 JWT로 교환

**Request Body:**

```json
{
  "provider": "google" | "github" | "facebook",
  "access_token": "<OAuth provider token>"
}
```

**Response:**

```json
{
  "access_token": "<JWT signed access token>",
  "refresh_token": "<JWT signed refresh token>",
  "token_type": "bearer"
}
```

Email과 name은 OAuth 토큰을 provider API로 재검증하여 획득합니다.

### POST /api/v1/auth/refresh

**목적:** refresh token으로 새로운 access token 발급

**Request Body:**

```json
{
  "refresh_token": "<JWT signed refresh token>"
}
```

**Response:**

```json
{
  "access_token": "<JWT signed new access token>",
  "refresh_token": "<JWT signed refresh token>",
  "token_type": "bearer"
}
```

### POST /api/v1/auth/logout

**목적:** 클라이언트 측 토큰 정리

**Response:** 204 No Content

## OAuth Providers

### 지원 Provider

| Provider | Client ID Environment Variable | Client Secret Environment Variable | API Endpoint |
|----------|------------------------------|-----------------------------------|--------------|
| Google | `GOOGLE_CLIENT_ID` | `GOOGLE_CLIENT_SECRET` | `https://www.googleapis.com/oauth2/v3/userinfo` |
| GitHub | `GITHUB_CLIENT_ID` | `GITHUB_CLIENT_SECRET` | `https://api.github.com/user` |
| Facebook | `FACEBOOK_CLIENT_ID` | `FACEBOOK_CLIENT_SECRET` | `https://graph.facebook.com/v19.0/me?fields=id,name,email,picture` |

## 주요 장점

### 1. 성능 개선

- Stateless JWT 검증으로 최소한의 오버헤드
- 백엔드 부하 감소

### 2. 확장성

- 서버 상태가 없어서 손쉬운 스케일링
- 로드 밸런싱 용이

### 3. 모바일 친화적

- Authorization header 방식은 모바일에 최적
- cookie 기반 인증보다 단순

### 4. 디버깅 편의성

- JWT 토큰은 jwt.io에서 디코딩하여 디버깅 가능
- 모든 언어와 프레임워크에서 호환되는 표준 포맷

## FAQ

**Q: 왜 JWT(JWS)를 사용하나요?**
A: 토큰 payload에 `user_id`와 `role`만 포함되어 암호화가 필요한 민감 데이터가 없습니다. HS256 서명의 JWT(JWS)는 무결성 검증을 제공하면서, jwt.io를 통한 디버깅 용이성, 플랫폼 간 라이브러리 지원, Flutter/모바일 연동 단순화 등의 이점이 있습니다. HTTPS가 이미 전송 구간 보호를 담당합니다.

**Q: 왜 OAuth token을 재검증하나요?**
A: OAuth provider API를 통해 사용자 정보를 재확인하여 보안을 강화하기 위함입니다. 토큰 탈취 시 공격을 완화하는 데 도움이 됩니다.

**Q: 왜 access token 만료 시간이 1시간인가요?**
A: 짧은 만료 시간은 보안 측면에서 중요합니다. 토큰이 탈취되었을 때 피해 범위를 최소화합니다. refresh token(7일)으로 갱신할 수 있습니다.

## 참고 자료

- [JWS (JSON Web Signature) RFC 7515](https://datatracker.ietf.org/doc/html/rfc7515)
- [OAuth 2.0 RFC 6749](https://datatracker.ietf.org/doc/html/rfc6749)
- [JWT Best Practices](https://tools.ietf.org/html/rfc8725)

**Last Updated:** 2026-02-24
