<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-03-02T14:39:02+11:00 | Updated: 2026-03-02T14:39:02+11:00 -->

# apps

## Purpose

Directory containing the main applications that make up the project. It is separated by roles such as backend platform, Background Worker, mobile app client, and IaC (infrastructure) code for deployment.

## Key Files

| File | Description |
|------|-------------|
| - | No separate main configuration files; used to maintain the structure of subdirectories. |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `api/` | FastAPI-based backend service (see `api/AGENTS.md`) |
| `worker/` | FastAPI-based asynchronous background worker (see `worker/AGENTS.md`) |
| `mobile/` | Flutter-based cross-platform mobile client (see `mobile/AGENTS.md`) |
| `infra/` | Terraform-based GCP environment infrastructure (see `infra/AGENTS.md`) |
| `web/` | Web frontend environment application (see `web/AGENTS.md`) |

## For AI Agents

### Working In This Directory

Wrapper folder for simply managing submodule apps. Maintain an appropriate name and structure when adding or modifying new sub-apps inside the apps directory.

### Dependencies

Depends on global configurations like `mise.toml` in the root space.

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
