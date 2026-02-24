# Stateless Token Authentication Architecture

## Overview

This template implements a **stateless JWT(JWS) authentication system** instead of **stateful session-based authentication**. Authentication processing is performed entirely on the backend, and the mobile client is responsible only for storing and transmitting tokens.

## Architecture

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
    Backend->>Mobile: Return JWT Token
    Mobile->>API: Authorization Header (access_token)
    API->>API: JWT Token Verification
    API->>User: Return Protected Resource
```

## Key Components

### 1. Backend (FastAPI - `apps/api/`)

**Essential Files:**

- `src/lib/auth.py` - JWT token generation/validation, OAuth validation
- `src/auth/router.py` - Authentication endpoints
- `src/users/model.py` - User DB model
- `src/lib/dependencies.py` - Dependency injection for auth

**Key Functions:**

- `create_access_token(user_id)` - Create JWT access token (1 hour expiry)
- `create_refresh_token(user_id)` - Create JWT refresh token (7 days expiry)
- `decode_token(token)` - Verify JWT token and extract payload
- `verify_oauth_token(provider, token)` - Re-verify OAuth token (Google/GitHub/Facebook)
- `get_current_user(request)` - Extract user from Authorization header

**Endpoints:**

- `POST /api/v1/auth/login` - OAuth login
- `POST /api/v1/auth/refresh` - Refresh token
- `POST /api/v1/auth/logout` - Logout

**Security:**

- JWT Signing (HS256 / HMAC-SHA256)
- Access Token: 1 hour expiry
- Refresh Token: 7 days expiry
- Authorization header based transmission

## Token Management

### Access Token

- **Format:** JWT (JSON Web Token, JWS)
- **Algorithm:** HS256 (HMAC-SHA256)
- **Expiry:** 1 hour
- **Storage:** Secure storage on mobile device
- **Usage:** `Authorization: Bearer {token}` header in API requests

### Refresh Token

- **Format:** JWT (JWS)
- **Algorithm:** HS256
- **Expiry:** 7 days
- **Storage:** Secure storage on mobile device
- **Usage:** Used to renew access token when expired

## Auth Flow

### 1. Social Login

```
User: Tap "Google Login"
    ↓
Mobile: OAuth provider redirect
    ↓
OAuthProvider: OAuth access token issued
    ↓
Mobile: OAuth access token received
    ↓
Mobile: POST /api/v1/auth/login { provider, access_token, email, name }
    ↓
Backend: OAuth token re-verification (Google API)
    ↓
Backend: User DB lookup/creation
    ↓
Backend: JWT token issuance (access: 1h, refresh: 7d)
    ↓
Mobile: JWT token secure storage
```

### 2. Protected API Request

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

### 3. Token Refresh (Auto)

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
Mobile: Secure storage update
    ↓
Request auto retry
```

### 4. Logout

```
User: Tap "Logout"
    ↓
Mobile: Clear stored tokens
    ↓
Mobile: POST /api/v1/auth/logout
    ↓
Backend: Logout processing (client token invalidation if needed)
```

## Security Features

### 1. JWT Signing

- **HMAC-SHA256:** Signs the payload with a shared secret key
- **Algorithm:** HS256
- **Integrity:** Signature ensures the token has not been tampered with
- **HTTPS:** Transport-layer encryption protects the token payload in transit

### 2. Stateless Nature

- **No Server Session:** No need to store session state on the server
- **Easy Scaling:** Easy load balancing
- **Scale Out:** Easy to add more servers

### 3. Token Expiry Strategy

- **Access Token:** Short expiry (1 hour) - Security optimization
- **Refresh Token:** Long expiry (7 days) - User convenience
- **Auto Refresh:** Automatic renewal upon expiry

## Database Schema

### Users Table

```python
class User(Base):
    id: UUID (PK)
    email: String (unique, indexed)
    name: String (nullable)
    image: String (nullable)
    email_verified: Boolean (default: False)
    provider: String (nullable)       # OAuth provider: google | github | facebook
    provider_id: String (nullable)    # Provider-specific user ID
    role: String (default: "host")    # host | concierge | care_worker | organization
    created_at: DateTime
    updated_at: DateTime
```

## Environment Variables

### Backend (apps/api/.env)

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

**Purpose:** Exchange OAuth token for Backend JWT

**Request Body:**

```json
{
  "provider": "google" | "github" | "facebook",
  "access_token": "<OAuth provider token>"
}
```

Email and name are obtained by re-verifying the OAuth token with the provider API.

**Response:**

```json
{
  "access_token": "<JWT signed access token>",
  "refresh_token": "<JWT signed refresh token>",
  "token_type": "bearer"
}
```

### POST /api/v1/auth/refresh

**Purpose:** Issue new access token using refresh token

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

**Purpose:** Client-side token cleanup

**Response:** 204 No Content

## OAuth Providers

### Supported Providers

| Provider | Client ID Environment Variable | Client Secret Environment Variable | API Endpoint |
|----------|------------------------------|-----------------------------------|--------------|
| Google | `GOOGLE_CLIENT_ID` | `GOOGLE_CLIENT_SECRET` | `https://www.googleapis.com/oauth2/v3/userinfo` |
| GitHub | `GITHUB_CLIENT_ID` | `GITHUB_CLIENT_SECRET` | `https://api.github.com/user` |
| Facebook | `FACEBOOK_CLIENT_ID` | `FACEBOOK_CLIENT_SECRET` | `https://graph.facebook.com/v19.0/me?fields=id,name,email,picture` |

## Key Benefits

### 1. Performance Improvement

- Minimal overhead with stateless JWT verification
- Reduced backend load

### 2. Scalability

- Easy scaling due to stateless server
- Easy load balancing

### 3. Mobile Friendly

- Authorization header method is optimal for mobile
- Simpler than cookie-based authentication

### 4. Simplified Debugging

- JWT tokens can be inspected at jwt.io for debugging
- Standard format compatible with all languages and frameworks

## FAQ

**Q: Why use JWT(JWS)?**
A: The token payload contains only `user_id` and `role` — no sensitive data that requires encryption. JWT(JWS) with HS256 signing provides integrity verification while enabling easier debugging (jwt.io), better library support across platforms, and simpler Flutter/mobile integration. HTTPS already protects the token in transit.

**Q: Why re-verify the OAuth token?**
A: To reinforce security by re-confirming user information through the OAuth provider API. It helps mitigate attacks in case of token theft.

**Q: Why is the access token expiry time 1 hour?**
A: A short expiry time is important for security. It minimizes the damage scope if a token is compromised. It can be renewed using the refresh token (7 days).

## References

- [JWS (JSON Web Signature) RFC 7515](https://datatracker.ietf.org/doc/html/rfc7515)
- [OAuth 2.0 RFC 6749](https://datatracker.ietf.org/doc/html/rfc6749)
- [JWT Best Practices](https://tools.ietf.org/html/rfc8725)

**Last Updated:** 2026-02-24
