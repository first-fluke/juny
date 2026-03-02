<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-03-02T14:39:02+11:00 | Updated: 2026-03-02T14:39:02+11:00 -->

# packages

## Purpose

Package management directory containing design system tokens or multi-language support resources (i18n) to be shared between apps. Operates as a Single Source of Truth for mobile and frontend to reference statuses in common.

## Key Files

| File | Description |
|------|-------------|
| - | - |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `design-tokens/` | Design token repository with color structures configured in the OKLCH color system, and Flutter/Web builder shared modules (see `design-tokens/AGENTS.md`) |
| `i18n/` | Multi-language ARB format repository used commonly across apps (see `i18n/AGENTS.md`) |

## For AI Agents

### Working In This Directory

Modifying packages here has a direct impact on the `apps/mobile` or `apps/web` systems that reference them as package forms. Please pay attention to modifications so as not to destroy the Single Source of Truth role.

### Dependencies

None.

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
