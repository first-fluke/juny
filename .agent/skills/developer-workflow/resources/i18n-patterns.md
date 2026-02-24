# i18n Build Patterns

Internationalization workflows for monorepos.

## Shared i18n Package

```toml
# packages/i18n/mise.toml
[tasks.build]
description = "Build i18n files for mobile"
depends = ["build:mobile"]

[tasks.build:mobile]
description = "Build for mobile (Flutter ARB)"
run = "bun scripts/build.ts"
```

## Usage in Apps

```bash
# Build i18n for mobile
mise run //packages/i18n:build
```

## Mobile Integration

```toml
# apps/mobile/mise.toml
[tasks.gen:l10n]
description = "Generate Flutter localizations"
run = "flutter gen-l10n"

[tasks.dev]
description = "Run Flutter on device"
depends = ["gen:l10n"]
run = "flutter run"
```
