# Why This Tech Stack?

[English](./WHY.md) | [한국어](./WHY.ko.md)

This document explains the reasoning behind each technology choice in juny.

## Backend

### FastAPI

- **AI/ML ecosystem**: Direct access to Python's AI libraries (LangChain, Transformers, etc.)
- **Async-first**: Built on Starlette with native async/await support
- **Auto-generated docs**: OpenAPI (Swagger) and ReDoc out of the box
- **Pydantic validation**: Request/response validation with type hints
- **Scalability**: Easy horizontal scaling with stateless design

### SQLAlchemy (async)

- **ORM flexibility**: Can write raw SQL when needed, ORM when convenient
- **Async support**: Native asyncio with asyncpg driver
- **Migration-friendly**: Alembic integration for schema versioning
- **Mature ecosystem**: Battle-tested in production for decades

### PostgreSQL 16

- **ACID compliance**: Data integrity guaranteed
- **JSON support**: JSONB for flexible semi-structured data
- **Vector extension**: pgvector for AI embeddings and similarity search
- **Performance**: Advanced query planner, parallel queries, partitioning
- **Extensions**: PostGIS, full-text search built-in

### Redis 7

- **Sub-millisecond latency**: In-memory data structure store
- **Versatile**: Cache, session store, pub/sub, rate limiting
- **Persistence options**: RDB snapshots or AOF for durability
- **Cluster support**: Horizontal scaling when needed

### MinIO

- **S3 Compatible**: Drop-in replacement for AWS S3 API, seamless migration to production Cloud Storage
- **Local development**: Same API as production environment, no vendor lock-in during development
- **Self-hosted**: Runs locally with Docker/Podman, no external dependencies or service accounts required
- **Open source**: Enterprise-grade object storage with full control over data

## Mobile

### Flutter 3.38

- **Korea eGovFrame v5**: Selected as the official mobile framework by Korea e-Government Standard Framework
- **Flexible versioning**: Easy to pin and upgrade Flutter/Dart versions per project
- **Hot reload**: Sub-second UI iteration during development
- **Native performance**: Compiled to ARM, no JavaScript bridge

### Riverpod 3

- **Compile-safe**: Dependencies checked at compile time
- **Testable**: Easy to mock and test in isolation
- **No context required**: Access state from anywhere without BuildContext
- **Code generation**: Reduces boilerplate with riverpod_generator

### go_router 17

- **Declarative routing**: URL-based navigation like web
- **Deep linking**: Works out of the box for iOS/Android
- **Type-safe**: Code-generated route parameters
- **Nested navigation**: Shell routes for bottom nav, tabs

### Forui

- **shadcn/ui for Flutter**: Consistent design language with web (shadcn/ui)
- **Customizable**: Themeable components with Tailwind-like token system
- **Accessible**: ARIA-equivalent semantics for mobile
- **Lightweight**: No heavy dependencies, just widgets

### Firebase Crashlytics

- **Real-time crash reporting**: Immediate visibility into production issues
- **Breadcrumbs**: User actions leading to crash
- **Stack deobfuscation**: Readable stack traces for Flutter
- **Free tier**: Generous limits for most apps

### Fastlane

- **Automated releases**: One command to build, sign, and deploy
- **Cross-platform**: iOS and Android with same workflow
- **CI integration**: Works seamlessly with GitHub Actions
- **Metadata management**: Screenshots, descriptions, changelogs

## Infrastructure

### Terraform

- **Infrastructure as Code**: Version-controlled, reviewable infra changes
- **Declarative**: Describe desired state, let Terraform handle the rest
- **State management**: Track what's deployed, plan before apply
- **Modules**: Reusable, shareable infrastructure components

### GCP (Cloud Run, Cloud SQL, Cloud Storage)

- **Generous free tier**: $300 credit for new accounts, always-free tier for many services
- **Serverless containers**: No server management, scales to zero
- **Pay-per-use**: Only charged when handling requests
- **Managed database**: Automated backups, HA, maintenance
- **Global CDN**: Cloud CDN for static assets and API caching

### GitHub Actions + Workload Identity Federation

- **Keyless deployment**: No service account keys to manage or rotate
- **Native GitHub integration**: Triggered on push, PR, scheduled
- **Matrix builds**: Parallel testing across versions/platforms
- **Marketplace**: Thousands of community actions

## Developer Experience

### Rust-based Toolchain

We prioritize **speed** across the entire development workflow by choosing Rust-based tools:

- **Biome**: Linter + formatter in one tool, 100x faster than ESLint + Prettier
- **uv**: Python package manager, 10-100x faster than pip/poetry
- **Ruff**: Python linter + formatter, 10-100x faster than flake8/black

### mise

- **Polyglot monorepo support**: Node, Python, Flutter, Terraform — different ecosystems, one tool
- **Project-local versions**: `.mise.toml` ensures consistent environments across OS during developer onboarding
- **Task runner**: Replace Makefile, npm scripts, shell scripts with unified `mise` commands
- **Written in Rust**: Instant tool switching, no startup overhead

### Polyglot Monorepo

- **Single repository**: API (Python), Mobile (Dart), Worker (Python), Infra (HCL) in one place
- **Bounded contexts**: Each language ecosystem is scoped to its directory, preventing cross-contamination
- **Atomic changes**: Frontend + backend changes in single PR
- **Unified tooling**: Same `mise` commands across all apps

## Trade-offs

| Choice | Trade-off | Why We Accept It |
|--------|-----------|------------------|
| FastAPI over Node.js | Python-only backend | Python AI/ML ecosystem (Gemini, LiveKit), async-first |
| Flutter over React Native | Larger app size, custom rendering | Korea eGovFrame v5, flexible versioning |
| Gemini over OpenAI | Google ecosystem dependency | Native multimodal live streaming, Vertex AI integration |
| LiveKit over Agora/Twilio | Self-hostable, less managed | Open-source WebRTC, fine-grained role control |

## Summary

This stack optimizes for:

1. **Developer velocity**: Hot reload, type safety, auto-generated clients
2. **Production readiness**: Managed services, serverless scaling, CI/CD
3. **Team scalability**: Clear boundaries, shared tooling, documentation
4. **Long-term maintainability**: Proven technologies, active communities
