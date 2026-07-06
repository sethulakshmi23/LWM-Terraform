# HCP Terraform — First Managed Workspace

Everything through Day 4 ran Terraform **locally or against a self-managed S3 backend**
([Part4 3.1 State](../../LWN-Terra-Part4/3.1%20State)). This lab switches to **HCP Terraform**
(HashiCorp's hosted control plane, formerly "Terraform Cloud") — a free tier is enough for
this exercise.

## What HCP Terraform adds over the S3 backend

| | S3 + DynamoDB backend (Day 3) | HCP Terraform (Day 5) |
|---|---|---|
| State storage | You manage the bucket/table | Managed for you |
| State locking | DynamoDB | Built in |
| Where `plan`/`apply` execute | Your machine / your CI runner | HCP Terraform's own runners (remote execution) |
| Team access, run history, audit log | Not built in | Built in |
| Policy as code, cost estimation | Not available | Available on higher tiers — see [5.3](../5.3%20Governance%20Policy%20and%20Cost) |
| VCS-driven runs | Not built in | Built in — see [5.4](../5.4%20VCS%20Integration) |

## Step 1 — Create a free HCP Terraform account & organization

1. Sign up at https://app.terraform.io (free tier, no credit card required).
2. Create an **Organization** (this is the top-level container for workspaces/projects).

## Step 2 — Authenticate the CLI

```bash
terraform login
```

This opens a browser, generates an API token, and stores it in your local CLI credentials file
so `terraform init`/`plan`/`apply` can talk to HCP Terraform.

## Step 3 — Update `main.tf`

Replace `organization = "your-org-name"` with the organization you created in Step 1.

## Step 4 — Give the workspace AWS credentials

Runs now execute on HCP Terraform's own infrastructure, not your laptop — so it needs its own
copy of your AWS credentials. In the workspace's **Variables** tab, add two **Environment
variables** (not Terraform variables):

| Key | Value | Sensitive? |
|---|---|---|
| `AWS_ACCESS_KEY_ID` | your access key | No |
| `AWS_SECRET_ACCESS_KEY` | your secret key | Yes — tick "sensitive" |

## Step 5 — Run the workflow

```bash
terraform init     # first run auto-creates the "lwm-day5-hcp-demo" workspace
terraform plan      # queues a remote plan — watch it stream to your terminal
terraform apply     # requires approval in the HCP Terraform UI (or CLI, if prompted)
```

Open the workspace in the HCP Terraform UI to see the run, its logs, and the state file —
notice there's no `terraform.tfstate` in this folder locally; it never leaves HCP Terraform.

## Step 6 — Clean up

```bash
terraform destroy
```

## Reference

- [HCP Terraform docs](https://developer.hashicorp.com/terraform/cloud-docs)
- [The `cloud` block](https://developer.hashicorp.com/terraform/cli/cloud/settings)
