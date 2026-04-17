# Changelog

## [1.1.0](https://github.com/first-fluke/juny/compare/v1.0.0...v1.1.0) (2026-04-17)


### Features

* **api:** activate rate limiting middleware with per-endpoint controls ([3f5fde8](https://github.com/first-fluke/juny/commit/3f5fde81ba8117e99b2cfaec7e09eb5394e98832))
* **api:** add account self-deletion and gdpr data export ([0beae66](https://github.com/first-fluke/juny/commit/0beae664336cfdca601ed78b26def848337e457a))
* **api:** add active_only parameter to notification service ([b3fd47d](https://github.com/first-fluke/juny/commit/b3fd47d63b1a2996affb4158ca5fc5d2cce6bec3))
* **api:** add admin module with internal auth for service-to-service calls ([7a89624](https://github.com/first-fluke/juny/commit/7a89624534d86fed95cb6ede77e25025c38700a7))
* **api:** add admin token deactivation, audit logging, and data export ([a7af3e1](https://github.com/first-fluke/juny/commit/a7af3e12642d5aedcff8e17ac7e0f4298fab267c))
* **api:** add navigation module with map provider and ai tools ([8b3aae8](https://github.com/first-fluke/juny/commit/8b3aae84871b4acdd10aeb85bbebb4cd13b2da86))
* **api:** add notification logs module with preferences and migrations ([ea4afee](https://github.com/first-fluke/juny/commit/ea4afeef9423a36d1b27791028932da429e7cef8))
* **api:** add notifications domain module with device token management ([8b3e9d5](https://github.com/first-fluke/juny/commit/8b3e9d51124ad0b8e833ae31bb2b60d124064887))
* **api:** add pagination to relations list endpoint ([39114ac](https://github.com/first-fluke/juny/commit/39114acfc9e5986111c7e043be1853f549e9a8e9))
* **api:** add resilience utilities and cache module ([ea9fb8e](https://github.com/first-fluke/juny/commit/ea9fb8e6ceb13e14e664b35d419c81ad3f65b502))
* **api:** add task dispatch client and integrate with log_wellness ([f5031e0](https://github.com/first-fluke/juny/commit/f5031e00c271ccbd1bf903c9c6d6150c15710d84))
* **api:** add users module, storage providers, and files router ([f262f7a](https://github.com/first-fluke/juny/commit/f262f7aa308db25520bc831688d730e6dd377b51))
* **api:** add websocket stability and livekit room management ([da33fd5](https://github.com/first-fluke/juny/commit/da33fd5420ab348f9a64f346bbd4e77e771e4ec1))
* **api:** add wellness trends, medication adherence, and confirm tool ([2663acf](https://github.com/first-fluke/juny/commit/2663acf37b1aa0f0404bff6175cfb6023d9a3222))
* **api:** expand gdpr export with navigation data and harden providers ([cc15851](https://github.com/first-fluke/juny/commit/cc158516e01bad32d26afeb3d518f6418f6bf924))
* **api:** refactor notification providers with fcm implementation ([ecd70dc](https://github.com/first-fluke/juny/commit/ecd70dc250608286395fedb494145aa8887783d3))
* implement file management feature with repository and provider, and add notification log status update to notifications repository ([a793bac](https://github.com/first-fluke/juny/commit/a793bacfbf1d0609634dc835b58d70c85fa6bc79))
* **mobile:** add create screens for medications, wellness, and relations ([1efea3e](https://github.com/first-fluke/juny/commit/1efea3eaf87e5f63caa46ca81f03cd654219b3f7))
* **mobile:** add fcm push, design tokens, and notifications screen ([563b919](https://github.com/first-fluke/juny/commit/563b9192b778efe94a16dea8fc293cd4c66ffb84))
* **mobile:** add maps rendering, concierge dashboard, live reconnect and wire pending endpoints ([50b79b2](https://github.com/first-fluke/juny/commit/50b79b27354a226348a731a7e0e6baa20fb4198a))
* **mobile:** add token persistence and 401 auto-refresh ([9764990](https://github.com/first-fluke/juny/commit/97649904f53541e1739030b464ba159a29f121e4))
* **mobile:** display fcm foreground messages via local notifications ([fdaed50](https://github.com/first-fluke/juny/commit/fdaed50869eb7716519433a5931850940d7ccd05))
* **mobile:** integrate missing api features ([2719391](https://github.com/first-fluke/juny/commit/2719391c5683f28aac7dd5c751069c09f9064a6e))
* **mobile:** scaffold Flutter 3.41.2 project with Android and iOS configurations ([963962e](https://github.com/first-fluke/juny/commit/963962e69f4b09419bf8a59c3e3997b23f4ce176))
* **root:** merge backend backlog phase 1-3 ([08ad180](https://github.com/first-fluke/juny/commit/08ad1808cdb74fddd3bf1e5855870b5e55c3c5d0))
* **root:** merge phase-b — admin endpoints, rate limiting, redis integration ([4e488a6](https://github.com/first-fluke/juny/commit/4e488a6faf1bef0a3dd7f25638842e178c6a6cd0))
* **root:** merge relations pagination and worker retry ([d8333cc](https://github.com/first-fluke/juny/commit/d8333ccebba11d1ed0d1662c52f63ac571b6733a))
* update database connection details, enhance mise.toml tasks for better orchestration ([508d163](https://github.com/first-fluke/juny/commit/508d163b573275919ce930404670e4602645cb83))
* **worker:** add internal api key auth and fix admin endpoint paths ([0d386ce](https://github.com/first-fluke/juny/commit/0d386ceb5512fcbc82e67af8e062b35fd304fe2a))
* **worker:** add job framework with 6 concrete jobs ([dce139c](https://github.com/first-fluke/juny/commit/dce139cc83c9c4e867399fe22e2f2523bfeec0d0))
* **worker:** add per-token failure tracking to notification send job ([f02c979](https://github.com/first-fluke/juny/commit/f02c979c49e7463f1411a397d7c2b7ed048a844c))
* **worker:** add pub/sub, telemetry, idempotency, and token deactivation ([ca28e55](https://github.com/first-fluke/juny/commit/ca28e55e86fd9422aebb82f0e293dc0303baf6e2))
* **worker:** apply with_retry to job http calls ([b489df1](https://github.com/first-fluke/juny/commit/b489df1b3539f1cd51e6a176cc16abf2b363689b))


### Bug Fixes

* **api:** add close_rate_limiters and remove suppressed warnings ([68d9182](https://github.com/first-fluke/juny/commit/68d91821ddb0433d65aef40ae26c3b6711a0bbc7))
* **api:** add row lock to navigation reroute ([26871c6](https://github.com/first-fluke/juny/commit/26871c61c327befe2fd04742d410c15075b64409))
* **api:** add wellness trend warning and utc date aggregation ([69ca1e8](https://github.com/first-fluke/juny/commit/69ca1e8c2d317b9bef9eb02365cc96e6f05549d0))
* **api:** admin waypoint retention + medications like escape ([37e1238](https://github.com/first-fluke/juny/commit/37e12380c3b04b0c53ffa1dac11c1bd3b6d7ce97))
* **api:** batch fetch caregiver tokens in wellness alert ([848966d](https://github.com/first-fluke/juny/commit/848966db9d4978b42323d2e8121e185bda7ec7f6))
* **api:** broaden exception handling in ducking bot callback ([d1c2126](https://github.com/first-fluke/juny/commit/d1c2126f5a332d01860b68032ca4afea285d4eaf))
* **api:** bulk token deactivation and preserve medication taken_at ([57358ee](https://github.com/first-fluke/juny/commit/57358ee8f5758746f1a3984a40acc1df42ddb046))
* **api:** cap export pagination to prevent memory exhaustion ([4618130](https://github.com/first-fluke/juny/commit/4618130d585517ccafc76e6cc99132f2121732b3))
* **api:** catch value error in navigation router ([0646147](https://github.com/first-fluke/juny/commit/0646147676e50f0e38cab7155c735f054f486c24))
* **api:** close redis client on health check failure and retry only 5xx ([8d5ec2c](https://github.com/first-fluke/juny/commit/8d5ec2cec8cdddfee0a3b8f7cacb553b65bef63a))
* **api:** fix e2e notification test using shared client instance ([0410095](https://github.com/first-fluke/juny/commit/04100954f5a135fe95886152ebc6ecbaa2ba5f30))
* **api:** handle validation error in check_off_route ([641f0e9](https://github.com/first-fluke/juny/commit/641f0e96943d1c031d249fdb6a09f84b77ca3334))
* **api:** harden websocket off-route and health check redis ([4b00672](https://github.com/first-fluke/juny/commit/4b00672cc57083bde24860defdfc5f0382ae6fdd))
* **api:** improve websocket session management and concurrency ([5bb2ec9](https://github.com/first-fluke/juny/commit/5bb2ec9d066858895d81c828a02e1ce1808010e0))
* **api:** redis cache singleton and rate limiter improvements ([6804d40](https://github.com/first-fluke/juny/commit/6804d401ada9adf8cc7eede05e78704b80c3d383))
* **api:** replace defaultdict with plain dict in rate limiter ([c6100b7](https://github.com/first-fluke/juny/commit/c6100b7952fa144d5bd4a310424da9124998352d))
* **api:** resolve navigation toctou and replace assert with explicit error ([b021b24](https://github.com/first-fluke/juny/commit/b021b24f88aabb83edcaf145ea273645c23f67c9))
* **api:** rotate refresh token and harden internal auth ([72868af](https://github.com/first-fluke/juny/commit/72868afb83855a26003512273d263947de7d0e44))
* **api:** sanitize storage error in file upload ([8bfccc7](https://github.com/first-fluke/juny/commit/8bfccc76d0bde3fd07d19b7b55dd8d6f53eab38f))
* **api:** use select-for-update in device token registration ([44dad4a](https://github.com/first-fluke/juny/commit/44dad4aeb9e39ed17e9351e27b58de4f6502ae61))
* **api:** use short-lived db sessions for websocket tool calls ([e15026e](https://github.com/first-fluke/juny/commit/e15026e22f7609ca6ff99c9f1ba0989e6e0ad694))
* **api:** validate all host_ids in batch waypoint endpoint ([02a5e7d](https://github.com/first-fluke/juny/commit/02a5e7d38ade202d3e6de8c8f165321025949463))
* **api:** validate file upload extensions ([fd81123](https://github.com/first-fluke/juny/commit/fd81123bcf18bbacc69f279edebc13a81299f597))
* **api:** wrap fcm and cloud tasks with asyncio.to_thread ([b5a8066](https://github.com/first-fluke/juny/commit/b5a806645b51280b21c7e9870d444db297de659a))
* **api:** wrap storage providers with asyncio.to_thread ([f653c6a](https://github.com/first-fluke/juny/commit/f653c6a66692d97a6e9781f05bc6e76964c9ef15))
* **mobile:** add semantic labels and remove hardcoded colors for a11y and design consistency ([8d99bad](https://github.com/first-fluke/juny/commit/8d99bad2a71b55d61cbbcde4517058cc3332b2ba))
* **mobile:** correct default api port from 8000 to 8200 ([92f03b9](https://github.com/first-fluke/juny/commit/92f03b912f965d9f56624b035c0675c16ad2422b))
* **worker:** broaden retryable network exceptions ([c78b995](https://github.com/first-fluke/juny/commit/c78b995a473d483aa6489c8a8670644f86c45992))
* **worker:** cap idempotency store size ([1ccfd4d](https://github.com/first-fluke/juny/commit/1ccfd4d42ca91f03bf08bba0c6700e36aa81fddc))
* **worker:** fcm async + retry 5xx only + sanitize error detail ([b9e94b8](https://github.com/first-fluke/juny/commit/b9e94b8664a9c7f0615a1c517ac93abb91275d49))
* **worker:** initialize firebase app before fcm send ([ffa14de](https://github.com/first-fluke/juny/commit/ffa14de3b5ca4ff42c1201f96c3d7bd83792d527))
* **worker:** make idempotency check-and-mark atomic ([08df00f](https://github.com/first-fluke/juny/commit/08df00fab503940ba1ea748c5aa11882ab5f370d))
* **worker:** raise on validation failure in wellness aggregate ([d10e9af](https://github.com/first-fluke/juny/commit/d10e9af2eb00cf7d2e003e4fde33f389ee41f977))
* **worker:** release idempotency claim on job execution failure ([88a13a6](https://github.com/first-fluke/juny/commit/88a13a6616db8e2df33d6fe83cb453e48010f963))
* **worker:** replace http self-dispatch with direct job call ([79af8cb](https://github.com/first-fluke/juny/commit/79af8cbb4bc05bd3913b2df104bd8c793680cf51))

## 1.0.0 (2026-02-24)


### Features

* **api:** add domain modules and enhance core features ([97fbdf9](https://github.com/first-fluke/juny/commit/97fbdf9e16ef95309f37600c0d7946524fa1ef1a))
* **api:** add domain modules, AI orchestrator, LiveKit, and authorization ([93eff36](https://github.com/first-fluke/juny/commit/93eff36830c15d3687d528b5d47f0c40538ab38f))
* **api:** add initial alembic migration and seed script ([2179424](https://github.com/first-fluke/juny/commit/21794245f643874197dc1155674021cb85ddaa98))


### Bug Fixes

* license edit. not mit ([6a4b137](https://github.com/first-fluke/juny/commit/6a4b137c61797f838523ec3a9399f11e3c829f54))
* **mobile:** resolve lint errors in apps/mobile ([ea58769](https://github.com/first-fluke/juny/commit/ea58769200f599e8a2c6829a80db96ed1030eacb))

## [2.11.0](https://github.com/first-fluke/juny/compare/v2.10.0...v2.11.0) (2026-02-21)


### Features

* introduce new skills and resources for developer workflow ([1265067](https://github.com/first-fluke/juny/commit/12650670256e9f9b1501247b831afc2074e3bf1f))

## [2.10.0](https://github.com/first-fluke/juny/compare/v2.9.0...v2.10.0) (2026-02-13)


### Features

* enhance agent orchestration with clarification ([eda86ac](https://github.com/first-fluke/juny/commit/eda86ac71bd04d4ec1069ddd454de501844dc45a))

## [2.9.0](https://github.com/first-fluke/juny/compare/v2.8.0...v2.9.0) (2026-02-12)


### Features

* **web:** add kebab-case naming convention to orval config ([0ad5e9c](https://github.com/first-fluke/juny/commit/0ad5e9c3b65e9e55f41ae8ec69f9b3f7c070832a))

## [2.8.0](https://github.com/first-fluke/juny/compare/v2.7.1...v2.8.0) (2026-02-07)


### Features

* remove dashboard web server and related scripts ([cb7d818](https://github.com/first-fluke/juny/commit/cb7d8181e4923bd010d79dad4ff4ad2ba2801391))

## [2.7.1](https://github.com/first-fluke/juny/compare/v2.7.0...v2.7.1) (2026-01-29)


### Bug Fixes

* prevent path traversal vulnerability in dashboard server ([22fed9d](https://github.com/first-fluke/juny/commit/22fed9d80012ed18a64c262a2597284146177511))

## [2.7.0](https://github.com/first-fluke/juny/compare/v2.6.0...v2.7.0) (2026-01-29)


### Features

* add multi-agent orchestration skills from subagent-orchestrator ([cdfa245](https://github.com/first-fluke/juny/commit/cdfa245bc74db313ebe17d79212f1135c55b084b))

## [2.6.0](https://github.com/first-fluke/juny/compare/v2.5.0...v2.6.0) (2026-01-27)


### Features

* add new agent skills and their associated reference documentation ([afc2363](https://github.com/first-fluke/juny/commit/afc2363722e02699f6c8e19aa58872fae85d1f90))

## [2.5.0](https://github.com/first-fluke/juny/compare/v2.4.0...v2.5.0) (2026-01-23)


### Features

* **root:** add postgres best practices skill ([99c6f25](https://github.com/first-fluke/juny/commit/99c6f2567a2a53abd7692a3f51ec39eb495ae450))

## [2.4.0](https://github.com/first-fluke/juny/compare/v2.3.0...v2.4.0) (2026-01-19)


### Features

* Add comprehensive AI agent skills library ([615ed8f](https://github.com/first-fluke/juny/commit/615ed8f0256c4b890568321abfa31064ed2d08fe))
* Add comprehensive AI agent skills library ([4d6d56d](https://github.com/first-fluke/juny/commit/4d6d56d14d048b37ec5c9196144cacded528bdf6))

## [2.3.0](https://github.com/first-fluke/juny/compare/v2.2.2...v2.3.0) (2026-01-19)


### Features

* **infra:** add Firestore and Vertex AI resources ([95fe4aa](https://github.com/first-fluke/juny/commit/95fe4aa620ad2e27dc4ce255e96c4047f759a74b))
* **infra:** add Firestore and Vertex AI resources ([d9e3b70](https://github.com/first-fluke/juny/commit/d9e3b705f2c4e207cde89b54da633e735bb7d3ea))

## [2.2.2](https://github.com/first-fluke/juny/compare/v2.2.1...v2.2.2) (2026-01-18)


### Bug Fixes

* **web:** resolve typescript errors in auth-client and custom instance ([4350494](https://github.com/first-fluke/juny/commit/4350494f79e36de675354ba2495701759492874d))

## [2.2.1](https://github.com/first-fluke/juny/compare/v2.2.0...v2.2.1) (2026-01-17)


### Bug Fixes

* **mobile:** update swagger_parser config to latest format ([a517317](https://github.com/first-fluke/juny/commit/a5173179062cd55cbf706f094f22a4f8e084a0a8))

## [2.2.0](https://github.com/first-fluke/juny/compare/v2.1.0...v2.2.0) (2026-01-17)


### Features

* add gcp-migration skill and fix reviewdog ci errors ([a27edfa](https://github.com/first-fluke/juny/commit/a27edfacb1383c9b112edf82d985e9ddb33d93c2))
* add gcp-migration skill and fix reviewdog ci errors ([8918f17](https://github.com/first-fluke/juny/commit/8918f17896be9c3255afa16869e6bbae0432e42b))
* GCP 마이그레이션 스킬 및 가이드 문서 추가 ([f0731c9](https://github.com/first-fluke/juny/commit/f0731c9774d1264295cd443b3f5f2a7d90c4ac00))


### Bug Fixes

* **ci:** reviewdog biome/ruff 포맷 지원 문제 수정 ([0a1ff7b](https://github.com/first-fluke/juny/commit/0a1ff7b0e74aca4950b00aa55419789ed86ef9fa))

## [2.1.0](https://github.com/first-fluke/juny/compare/v2.0.0...v2.1.0) (2026-01-16)


### Features

* add db:migrate task and sort tasks alphabetically ([e66a494](https://github.com/first-fluke/juny/commit/e66a494fbcca1a5e09cd1f523ea86e1c7cee679d))

## [2.0.0](https://github.com/first-fluke/juny/compare/v1.3.0...v2.0.0) (2026-01-16)


### ⚠ BREAKING CHANGES

* **api:** existing tokens are incompatible, users need to re-login

### Features

* add react best practices skill and update biome config ([c5de500](https://github.com/first-fluke/juny/commit/c5de50092ff7eb1d12f58aa3ad192daa416607a2))
* recommend `@reactuses/core` for advanced event handlers, global event listeners, and client-side storage patterns ([710350f](https://github.com/first-fluke/juny/commit/710350f9a9dbfe1d792dd9ce09ca95fd21bb0848))


### Bug Fixes

* **api:** resolve ruff lint errors ([c49492a](https://github.com/first-fluke/juny/commit/c49492a58e533b92cfce2de05bf07f753ccc001d))


### Code Refactoring

* **api:** migrate from python-jose to jwcrypto for JWE ([5d42928](https://github.com/first-fluke/juny/commit/5d4292877ef065fa277a84a175f5cd863f5d3cd4))

## [1.3.0](https://github.com/first-fluke/juny/compare/v1.2.0...v1.3.0) (2026-01-15)


### Features

* implement stateless JWE authentication and add documentation ([edf6c40](https://github.com/first-fluke/juny/commit/edf6c40439b5f7b7baf808aec32a2b2c138eb7ca))

## [1.2.0](https://github.com/first-fluke/juny/compare/v1.1.0...v1.2.0) (2026-01-14)


### Features

* **web:** add T3 Env schema ([78adbfe](https://github.com/first-fluke/juny/commit/78adbfef969cb2daae5af1f74de804645b9ef0bf))


### Bug Fixes

* **web:** handle optional params in not-found page ([4839c21](https://github.com/first-fluke/juny/commit/4839c21e2d916c210741b402d54ec5491dee97df))
* **web:** migrate client env variables to T3 Env ([b740527](https://github.com/first-fluke/juny/commit/b7405270a0fefe95b94acaf5555758eab96b7bd6))
* **web:** migrate server env variables to T3 Env ([43960cb](https://github.com/first-fluke/juny/commit/43960cb284777f7e5ca69f941c2778896c17fb52))

## [1.1.0](https://github.com/first-fluke/juny/compare/v1.0.1...v1.1.0) (2026-01-13)


### Features

* **web:** add @reactuses/core and reorganize atoms ([cf5e4cb](https://github.com/first-fluke/juny/commit/cf5e4cb8726213259b3ed2244f622d532819801f))

## [1.0.1](https://github.com/first-fluke/juny/compare/v1.0.0...v1.0.1) (2026-01-12)


### Bug Fixes

* **api:** resolve ruff lint errors ([f28a4c8](https://github.com/first-fluke/juny/commit/f28a4c81a18423c84ad65b98122fdf6f3c15c284))
* **ci:** replace pyright with mypy in pipelines ([6ee1db3](https://github.com/first-fluke/juny/commit/6ee1db338bc40ad125273ef8af8cfec2d94f13c6))
* **mobile:** resolve lint errors and comply with very_good_analysis ([0b3c8c4](https://github.com/first-fluke/juny/commit/0b3c8c48cf13c28fa93d279409da68d47ff116d4))
* standardize Python version to 3.12 across all configurations ([3893d15](https://github.com/first-fluke/juny/commit/3893d151d23afe7a7b6b2b9f2cf9b8ba3ba6eb58))
* **worker:** allow empty test suite to pass in pre-push hook ([11ef628](https://github.com/first-fluke/juny/commit/11ef628c9d94e9938cbfb654c273feeb3d016faa))

## 1.0.0 (2026-01-12)


### Features

* add CodeQL SAST, rate limiting, pagination, and architecture diagram ([7b37139](https://github.com/first-fluke/juny/commit/7b371391f14cce3406886913a3764dea6a6c17ab))
* add production hardening with Fastlane, Firebase Crashlytics, OpenTelemetry ([420cea6](https://github.com/first-fluke/juny/commit/420cea6ed80ac3b8ec73d8d6844645425b91f00e))
* add release-please for template versioning ([b8c815b](https://github.com/first-fluke/juny/commit/b8c815be4617323184743cd73ff5e511cf6bae49))
* add root-level infra:up/down tasks and GitHub stars badge ([8dd9af9](https://github.com/first-fluke/juny/commit/8dd9af9e8caf4eab986f8afdeade0c788850d6a7))
* **i18n:** add shared i18n package as single source of truth ([9b93d27](https://github.com/first-fluke/juny/commit/9b93d2707f170303d99e18cddedb877e2c753a14))
* initial fullstack starter template ([46f9f26](https://github.com/first-fluke/juny/commit/46f9f260017515f141e9efb81580b811b49578ba))
* **mise:** add git:pre-push task for branch validation and conditional tests ([3279fd8](https://github.com/first-fluke/juny/commit/3279fd896e42c3ed3faf980fec6629b448e93fa9))
* **mobile:** add forui UI library and upgrade Flutter to 3.38 ([00d5755](https://github.com/first-fluke/juny/commit/00d57556fee085dc81cfea69a0200e7564e2d191))
* **web:** add production-ready Next.js config and UI registries ([fa109de](https://github.com/first-fluke/juny/commit/fa109deeeafd48260a37756463ad1f34cf4c0b6b))
* **web:** add PWA support with Serwist and essential app files ([59f97f1](https://github.com/first-fluke/juny/commit/59f97f1cf7fbdf0cd9b4891494f127f9881637d8))
* **web:** add security headers to Next.js config ([1c30de7](https://github.com/first-fluke/juny/commit/1c30de78d1584d542773e05d89108575f867c17d))
* **web:** add TanStack devtools and form context setup ([b6ba47f](https://github.com/first-fluke/juny/commit/b6ba47ff9656bacd296297f82bf91f897815b7ee))
* **web:** add useIsClient hook for SSR-safe client detection ([e1455d1](https://github.com/first-fluke/juny/commit/e1455d1ba72a34ab4a32d37bd78a0757ceca863c))
* **web:** disable X-Powered-By header ([8d43c65](https://github.com/first-fluke/juny/commit/8d43c65af7e37e9599797518b26cd9d1d879eb20))


### Bug Fixes

* **i18n:** move mobile arb files to lib/i18n/messages ([1ae76dd](https://github.com/first-fluke/juny/commit/1ae76dd46771df222487f1e9744d11fe2bc749bd))
* **i18n:** move web messages to src/config/messages ([d7ee63a](https://github.com/first-fluke/juny/commit/d7ee63af9bfb122aa242ba5b664afdb0c0d81e75))
* simplify gh api star command ([9433e28](https://github.com/first-fluke/juny/commit/9433e280881c3a00b7467e2eff54130eb975bc99))
* use correct gh api command for starring repository ([0e40335](https://github.com/first-fluke/juny/commit/0e403352742557cfe6224fa563ed595020e7f1ff))
* use gh-star extension for starring repository ([a9e2501](https://github.com/first-fluke/juny/commit/a9e2501de036222f1106da271aada4e15e3c23ef))
