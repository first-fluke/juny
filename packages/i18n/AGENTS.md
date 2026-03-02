<!-- Parent: ../../AGENTS.md -->
<!-- Generated: 2026-03-02T14:39:02+11:00 | Updated: 2026-03-02T14:39:02+11:00 -->

# i18n

## Purpose

Integrated Single Source of Truth multi-language (i18n) package used at a global scope. Unifying ARB format management here helps clients like mobile retain consistent translation usage.

## Key Files

| File | Description |
|------|-------------|
| `src/*.arb` | Original source files logging multi-language translations |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `src/` | Directory containing the original ARB files |

## For AI Agents

### Working In This Directory

When adding or changing translation values, only modify the ARB files in the `src/` folder at this specific location, not the app's codebase. Ensure automated rendering via Flutter's intl (`apps/mobile/lib/i18n/messages/*.arb`) following alterations utilizing `mise i18n:build`.

### Dependencies

Maintains dependency via global build script and generated files inside `apps/mobile`.

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
