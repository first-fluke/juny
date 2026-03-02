<!-- Generated: 2026-03-02T14:39:02+11:00 | Updated: 2026-03-02T14:39:02+11:00 -->

# juny (Project Root)

## Purpose

Top-level root directory of the Fullstack Monorepo built with FastAPI (Backend), Flutter (Mobile), and GCP (Infrastructure). Contains all applications, packages, common configuration files, and workflows.

## Key Files

| File | Description |
|------|-------------|
| `mise.toml` | Main configurations (Runtime versions, task runner, etc.) |
| `biome.json` | Biome configuration file for JavaScript/TypeScript (linting and formatting) |
| `commitlint.config.cjs` | commitlint configuration for checking commit message rules |
| `README.md` | Project overview and guide documentation |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `apps/` | Directory containing core application code such as backend, frontend, mobile, and infrastructure (see `apps/AGENTS.md`) |
| `packages/` | Directory for reusable shared modules like design tokens and i18n (see `packages/AGENTS.md`) |
| `.github/` | CI/CD pipeline (GitHub Actions) and Github configurations |
| `.agent/` | Configurations for AI agents' rules and workflows (skills, workflows) |

## For AI Agents

### Working In This Directory

Take caution when working in this directory as global configurations can significantly impact applications and packages across the entire project. Only access this to modify global project linting rules, commit rules, or global scripts.

### Dependencies

None.

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
