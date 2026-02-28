# AWS Terraform Demo — CI/CD Pipeline

A demonstration project that provisions and deploys a Flask web application to AWS using Terraform, automated through a GitHub Actions CI/CD pipeline with integrated security scanning.

## What It Does

On every push to `master` (or manual trigger), the pipeline:

1. **Scans for security issues** before any infrastructure is touched
2. **Provisions AWS infrastructure** via Terraform if all scans pass
3. **Deploys a Flask application** to the provisioned EC2 instance

A separate teardown workflow destroys all infrastructure on demand.

## Pipeline Overview

### Security Scan Job
- **Checkov** — static analysis of Terraform configuration against AWS security best practices
- **Trivy** — vulnerability scanning of the Docker image for CRITICAL CVEs
- **OPA/Conftest** — custom policy enforcement (blocks open ingress rules)

The deploy job will not run if any security scan fails.

### Deploy Job
- Configures AWS credentials via GitHub Secrets
- Runs `terraform init` and `terraform apply` to provision infrastructure
- Terraform state is stored remotely in S3 for persistence across runs

### Teardown
- Triggered manually via `workflow_dispatch`
- Runs `terraform destroy` to cleanly remove all AWS resources

## Infrastructure (Terraform)

All infrastructure is defined in `infra/terraform/main.tf`:

- **VPC** with a public subnet, internet gateway, and route table
- **Security group** restricting SSH and HTTP access to a single IP, with outbound HTTP/HTTPS only
- **IAM role** with SSM access attached to the EC2 instance
- **EC2 instance** (Ubuntu 22.04, t3.micro) with encrypted root volume, IMDSv2 enforced, and detailed monitoring enabled
- **AMI** resolved dynamically at apply time from Canonical's official Ubuntu 22.04 images

## Application

A minimal Flask app (`app/app.py`) served on port 8080. The EC2 instance clones this repository on boot, builds the Docker image, and runs the container.

## Security Posture

- No hardcoded credentials anywhere — all sensitive values are GitHub Secrets passed as environment variables
- Ingress restricted to a single known IP via `local_source_ip` variable
- IMDSv2 enforced on the EC2 instance (blocks SSRF attacks against instance metadata)
- Root volume encrypted at rest
- Docker image scanned for vulnerabilities before deployment
- OPA policy enforced to prevent accidental open ingress rules
- Default VPC security group explicitly locked down

## Project Structure

```
├── .github/
│   └── workflows/
│       ├── pipeline.yml       # Main CI/CD pipeline
│       └── teardown.yml       # Infrastructure teardown
├── app/
│   ├── app.py                 # Flask application
│   ├── Dockerfile
│   └── requirements.txt
├── infra/
│   └── terraform/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── .terraform.lock.hcl
└── security/
    └── policies/
        └── deny-open-sg.rego  # OPA policy
```

## Required GitHub Secrets

| Secret | Description |
|--------|-------------|
| `AWS_ACCESS_KEY_ID` | IAM user access key |
| `AWS_SECRET_ACCESS_KEY` | IAM user secret key |
| `LOCAL_SOURCE_IP` | Your IP in CIDR notation (e.g. `1.2.3.4/32`) |

## Prerequisites

- AWS account with an IAM user that has EC2, IAM, and S3 permissions
- S3 bucket for Terraform state (configured in `main.tf` backend block)
- GitHub repository with the above secrets configured
