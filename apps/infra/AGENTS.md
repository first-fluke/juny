<!-- Parent: ../../AGENTS.md -->
<!-- Generated: 2026-03-02T14:39:02+11:00 | Updated: 2026-03-02T14:39:02+11:00 -->

# infra

## Purpose

Terraform-based Infrastructure-as-Code (IaC) directory for deployment in GCP environments. Defines all infrastructure resources that form the backbone of the project, such as network, database, storage, and serverless deployment.

## Key Files

| File | Description |
|------|-------------|
| `variables.tf` | Definition of Terraform environment variables and project configuration values |
| `provider.tf` | Google Cloud Provider configuration and API integration items |
| `network.tf` / `database.tf` / `storage.tf` | Resource definition per environment (VPC, Cloud SQL, GCS, etc.) |
| `iam.tf` / `security.tf` / `wif.tf` | Security resources related to service account permissions, IAM rules, and WIF authentication |
| `cdn.tf` / `artifact.tf` / `cloudtasks.tf` | Caching, artifact registry, and Pub/Sub messaging infrastructure definition |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `free/` | Sub-infrastructure/Cloud Run deployment for public or limited testing, or isolated environment deployment (see `free/AGENTS.md`) |

## For AI Agents

### Working In This Directory

이 디렉터리의 수정 사항은 프로덕션 시스템의 가용성과 직결됩니다.
Terraform의 State 변화를 항상 염두에 두고 작업해야 하며, 리소스를 함부로 destroy하거나 권한을 부여하지 마세요. 필요한 변경사항이 있다면 영향도를 먼저 검토하고 `terraform plan` 결과를 미리 확인하는 것이 안전합니다.

### Dependencies

GCP (Google Cloud Platform) accounts and configurations, WIF authentication within GitHub Actions Workflow, container image status for `api` and `worker` deployment targets

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
