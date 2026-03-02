<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-03-02T14:39:02+11:00 | Updated: 2026-03-02T14:39:02+11:00 -->

# free

## Purpose

A sub-infrastructure module separated from the main infrastructure module, acting as a separate IaC environment linked to specific free plan resources or Cloud Run deployment for small services.

## Key Files

| File | Description |
|------|-------------|
| `cloudrun.tf` | Cloud Run service deployment configuration for free tiers or isolated environments |
| `provider.tf` | Google Cloud Provider configuration area |
| `variables.tf` | List of variables required for the submodule environment |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| - | - |

## For AI Agents

### Working In This Directory

Configurations separated from the main infrastructure. Refer to and modify this only when configuring environments for cost reduction or additional modules.

### Dependencies

Common networks and permissions at the parent `infra` level

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
