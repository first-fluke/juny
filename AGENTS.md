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

<!-- OMA:START — managed by oh-my-agent. Do not edit this block manually. -->

# oh-my-agent

## Architecture

- **SSOT**: `.agents/` directory (do not modify directly)
- **Response language**: Follows `language` in `.agents/oma-config.yaml`
- **Skills**: `.agents/skills/` (domain specialists)
- **Workflows**: `.agents/workflows/` (multi-step orchestration)
- **Subagents**: Same-vendor native dispatch via Codex custom agents in `.codex/agents/{name}.toml`; cross-vendor fallback via `oma agent:spawn`

## Per-Agent Dispatch

1. Resolve `target_vendor_for_agent` from `.agents/oma-config.yaml`.
2. If `target_vendor_for_agent === current_runtime_vendor`, use the runtime's native subagent path.
3. If vendors differ, or native subagents are unavailable, use `oma agent:spawn` for that agent only.

## Workflows

Execute by naming the workflow in your prompt. Keywords are auto-detected via hooks.

| Workflow | File | Description |
|----------|------|-------------|
| orchestrate | `orchestrate.md` | Parallel subagents + Review Loop |
| work | `work.md` | Step-by-step with remediation loop |
| ultrawork | `ultrawork.md` | 5-Phase Gate Loop (11 reviews) |
| plan | `plan.md` | PM task breakdown |
| brainstorm | `brainstorm.md` | Design-first ideation |
| review | `review.md` | QA audit |
| debug | `debug.md` | Root cause + minimal fix |
| scm | `scm.md` | SCM + Git operations + Conventional Commits |

To execute: read and follow `.agents/workflows/{name}.md` step by step.

## Auto-Detection

Hooks: `UserPromptSubmit` (keyword detection), `PreToolUse`, `Stop` (persistent mode)
Keywords defined in `.agents/hooks/core/triggers.json` (multi-language).
Persistent workflows (orchestrate, ultrawork, work) block termination until complete.
Deactivate: say "workflow done".

## Rules

1. **Do not modify `.agents/` files** — SSOT protection
2. Workflows execute via keyword detection or explicit naming — never self-initiated
3. Response language follows `.agents/oma-config.yaml`

## Project Rules

Read the relevant file from `.agents/rules/` when working on matching code.

| Rule | File | Scope |
|------|------|-------|
| GEMINI | `.agents/rules/GEMINI.md` | on request |
| backend | `.agents/rules/backend.md` | on request |
| branching-strategy | `.agents/rules/branching-strategy.md` | on request |
| build-guide | `.agents/rules/build-guide.md` | on request |
| commit | `.agents/rules/commit.md` | on request |
| database | `.agents/rules/database.md` | **/*.{sql,prisma} |
| debug | `.agents/rules/debug.md` | on request |
| design-tokens-guide | `.agents/rules/design-tokens-guide.md` | on request |
| design | `.agents/rules/design.md` | on request |
| dev-workflow | `.agents/rules/dev-workflow.md` | on request |
| frontend | `.agents/rules/frontend.md` | **/*.{tsx,jsx,css,scss} |
| i18n-guide | `.agents/rules/i18n-guide.md` | always |
| infrastructure | `.agents/rules/infrastructure.md` | **/*.{tf,tfvars,hcl} |
| lint-format-guide | `.agents/rules/lint-format-guide.md` | on request |
| mobile | `.agents/rules/mobile.md` | **/*.{dart,swift,kt} |
| preferred-editing-tools | `.agents/rules/preferred-editing-tools.md` | on request |
| quality | `.agents/rules/quality.md` | on request |
| test-guide | `.agents/rules/test-guide.md` | on request |

<!-- OMA:END -->
