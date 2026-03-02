<!-- Parent: ../../AGENTS.md -->
<!-- Generated: 2026-03-02T14:39:02+11:00 | Updated: 2026-03-02T14:39:02+11:00 -->

# design-tokens

## Purpose

A Single Source of Truth design token package heavily embedded across the project using the OKLCH color space. Flutter's (mobile) Material3 theme files and others are automatically generated from the tokens defined here.

## Key Files

| File | Description |
|------|-------------|
| `src/tokens.ts` | Top-level design token configuration file for OKLCH base colors and spacing (for editing) |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `src/` | Directory where design token script sources are located |

## For AI Agents

### Working In This Directory

If design alterations are required, **modify only `src/tokens.ts`**. Following modifications, you must execute the `mise //packages/design-tokens:build` command to rebuild derived files for target applications such as mobile.

### Dependencies

- Node packages such as `@types/node`
- Compilation outputs are deployed to paths like `apps/mobile/lib/core/theme/`.

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
