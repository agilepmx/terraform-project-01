# project-01 — AWS Network Infrastructure

Infrastructure as Code project to deploy a multi-AZ VPC network on AWS using **Terraform** and **Terragrunt**.

---

## Overview

The project provisions a fully configured VPC with dual-stack (IPv4 + IPv6) support across 3 Availability Zones, organized in 4 subnet tiers per AZ. It uses a multi-account/multi-environment structure managed by Terragrunt.

---

## Project Structure

```
project-01/
├── environments/
│   ├── terragrunt.hcl              # Root config — S3 backend + AWS provider (shared across all envs)
│   ├── dev/
│   │   ├── account.hcl             # Dev account ID and name
│   │   └── us-east-1/
│   │       ├── region.hcl          # Region config
│   │       └── VPC/
│   │           ├── terragrunt.hcl  # VPC inputs (cidr, subnets, etc.)
│   │           └── output.tf       # Exposes VPC outputs
│   ├── Stage/                      # (planned)
│   └── Prod/                       # (planned)
└── modules/
    └── vpc_network/
        ├── main.tf                 # VPC, IGW, Subnets, Route Tables, Associations
        ├── variables.tf            # Input variable definitions
        ├── output.tf               # Module outputs
        └── versions.tf             # Terraform and provider version constraints
```

---

## Architecture

### VPC Design
- **CIDR:** `10.16.0.0/16`
- **IPv6:** Auto-assigned by AWS, with per-subnet `/64` blocks
- **Availability Zones:** `us-east-1a`, `us-east-1b`, `us-east-1c`

### Subnet Tiers (per AZ)

| Tier     | Access  | Size  | Example CIDR (AZ-A) |
|----------|---------|-------|---------------------|
| reserved | Private | `/20` | `10.16.0.0/20`      |
| db       | Private | `/20` | `10.16.16.0/20`     |
| app      | Private | `/20` | `10.16.32.0/20`     |
| web      | Public  | `/20` | `10.16.48.0/20`     |

Total: **12 subnets** (4 tiers × 3 AZs)

### Routing
- Public subnets → Internet Gateway (IPv4 `0.0.0.0/0` + IPv6 `::/0`)
- Private subnets → no route to internet (no NAT Gateway yet)

---

## How Terragrunt Config Flows

```
environments/terragrunt.hcl        ← defines backend + provider
└── dev/account.hcl                ← account_id, account_name
    └── us-east-1/region.hcl       ← aws_region
        └── VPC/terragrunt.hcl     ← inputs + module source
```

Each resource folder inherits config from parent folders via `find_in_parent_folders()`.

---

## State Management

Remote state is stored in S3 per environment and is **automatically provisioned by Terragrunt** on first run:

```
s3://agile-terraform-state-{account_name}-{account_id}/
└── {region}/{relative_path}/terraform.tfstate
```

- Encryption: enabled
- Locking: enabled via `use_lockfile`

---

## IAM — Deployment Role

Terragrunt assumes the following role before deploying:

```
arn:aws:iam::{account_id}:role/OrganizationAccountAccessRole
```

This role must exist in each target AWS account before running any deployments.

---

## Prerequisites

| Tool       | Minimum Version |
|------------|-----------------|
| Terraform  | `>= 1.5`        |
| Terragrunt | `>= 0.50`       |
| AWS CLI    | `>= 2.0`        |

---

## Setup

### 1. Configure AWS credentials

```bash
export AWS_ACCESS_KEY_ID="<your-access-key>"
export AWS_SECRET_ACCESS_KEY="<your-secret-key>"
```

Or use AWS CLI profiles:

```bash
aws configure --profile dev
export AWS_PROFILE=dev
```

### 2. Create the deployment IAM role

Ensure `OrganizationAccountAccessRole` exists in the target account with sufficient permissions to create VPC resources.

---

## Running

### Deploy the VPC (dev)

```bash
cd environments/dev/us-east-1/VPC
terragrunt init
terragrunt plan
terragrunt apply
```

### Deploy all resources in a region

```bash
cd environments/dev/us-east-1
terragrunt run-all apply
```

### Destroy

```bash
cd environments/dev/us-east-1/VPC
terragrunt destroy
```

---

## Module: `vpc_network`

### Inputs

| Variable       | Type          | Description                                          |
|----------------|---------------|------------------------------------------------------|
| `project_name` | `string`      | Project name used in resource naming                 |
| `environment`  | `string`      | Environment name (dev/stage/prod)                    |
| `vpc_name`     | `string`      | VPC identifier                                       |
| `vpc_cidr`     | `string`      | IPv4 CIDR block for the VPC                          |
| `subnets_data` | `map(object)` | Subnet definitions (cidr, az, public, ipv6_offset)   |

### Outputs

| Output                  | Description                     |
|-------------------------|---------------------------------|
| `vpc_id`                | VPC ID                          |
| `vpc_cidr`              | VPC IPv4 CIDR                   |
| `vpc_ipv6_cidr`         | VPC IPv6 CIDR                   |
| `igw_id`                | Internet Gateway ID             |
| `subnet_ids`            | Map of all subnet name → ID     |
| `public_subnet_ids`     | Map of public subnet name → ID  |
| `private_subnet_ids`    | Map of private subnet name → ID |
| `public_route_table_id` | Public route table ID           |

---

## Adding a New Environment

1. Create the folder structure:
```bash
mkdir -p environments/Stage/us-east-1/VPC
```

2. Add `account.hcl`:
```hcl
locals {
    account_name = "stage"
    account_id   = "<stage-account-id>"
}
```

3. Add `region.hcl` and copy `VPC/terragrunt.hcl` with updated CIDRs.

---

## Default Tags

All resources are automatically tagged via the provider:

| Tag           | Value                  |
|---------------|------------------------|
| `Project`     | `agile`                |
| `Environment` | account name (dev/...) |
| `Region`      | AWS region             |
| `ManagedBy`   | `Terraform`            |
