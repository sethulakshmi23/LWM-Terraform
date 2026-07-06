# Day 1 — Foundations & the Core Workflow

Lab material for **Day 1** of the Terraform Associate (004) course, in `LWM-Terra-Part1/`.
Maps to exam **Domain 1** (IaC), **Domain 2** (Terraform fundamentals), **Domain 3** (Core workflow).

> Focus: understand what Terraform is, why Infrastructure as Code matters, and run the workflow end-to-end against AWS.

---

## 1. What's in this folder

| File | Contents |
|---|---|
| [`main.tf`](main.tf) | 1 `terraform` block, 1 `provider` block, 5 resources |

### Example count in `main.tf`

| # | Block type | Label | What it teaches |
|---|---|---|---|
| 1 | `terraform` → `required_providers` | `aws` | Pinning the AWS provider source & version |
| 2 | `provider` | `aws` | Configuring a provider (region) |
| 3 | `resource "aws_vpc"` | `my-vpc` | First resource block; CIDR, tags |
| 4 | `resource "aws_subnet"` | `pubsub` | Cross-resource reference (`aws_vpc.my-vpc.id`) |
| 5 | `resource "aws_subnet"` | `prisub` | A second resource of the same type, showing naming/labels |
| 6 | `resource "aws_s3_bucket"` | `s3` | A different resource type in the same config |
| 7 | `resource "aws_s3_bucket"` | `s3-2` | Reinforces unique naming & tags pattern |

**Total: 1 provider config + 5 resources across 3 resource types** (`aws_vpc`, `aws_subnet`, `aws_s3_bucket`).

---

## 2. Syllabus topics covered here

| Day 1 topic | Covered in `main.tf`? | Notes for trainer |
|---|---|---|
| Infrastructure as Code: concepts, benefits, use cases | ❌ Conceptual | Deliver as a short talk/slide before opening the code — no `.tf` example needed |
| Installing and versioning Terraform and providers | ✅ | `required_providers` block pins `hashicorp/aws` @ `5.95.0` |
| HCL fundamentals: blocks, arguments, expressions | ✅ | Every block in the file is a live example — walk through `terraform{}`, `provider{}`, `resource{}`, argument = value pairs, and the `aws_vpc.my-vpc.id` expression |
| The core workflow: init → plan → apply → destroy | ✅ | Run live against this file (commands below) |
| Multi-cloud, hybrid-cloud, service-agnostic workflows | ❌ Conceptual | Explain verbally that swapping `provider "aws"` for `provider "azurerm"`/`"google"` is what makes Terraform service-agnostic; no second-cloud example in this file |
| How Terraform uses providers; the plugin model | ⚠️ Partial | `terraform init` output (below) shows the provider plugin being downloaded — narrate what's happening on screen |
| Configuring the AWS provider; a first resource | ✅ | `provider "aws" { region = "ap-southeast-1" }` + `aws_vpc.my-vpc` |
| Formatting and validating configurations (`fmt`, `validate`) | ✅ | Run `terraform fmt` / `terraform validate` as part of the workflow demo |

---

## 3. Prerequisites & Installation

### 3.1 Install Terraform

**Windows (PowerShell, via Chocolatey)**
```powershell
choco install terraform
```

**Windows (manual)**
1. Download the Windows amd64 zip from https://developer.hashicorp.com/terraform/install
2. Extract `terraform.exe` to a folder, e.g. `C:\terraform`
3. Add that folder to your `PATH` environment variable

**macOS (Homebrew)**
```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

**Linux (apt, Ubuntu/Debian)**
```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

**Verify install**
```bash
terraform -version
```

### 3.2 Install & configure the AWS CLI (for credentials)

```bash
# Verify AWS CLI is installed
aws --version

# Configure programmatic access (access key, secret key, default region, output format)
aws configure
```

Terraform's AWS provider reads credentials from the same chain the AWS CLI uses (`~/.aws/credentials`, environment variables, etc.) — no separate Terraform-specific credential setup is required for this lab.

### 3.3 Editor

- Visual Studio Code + the official **HashiCorp Terraform** extension (syntax highlighting, `fmt`-on-save, autocomplete)

---

## 4. Core workflow — commands to run

Run these **in order**, inside this folder, on a terminal with AWS credentials configured.

| Step | Command | What it does |
|---|---|---|
| 1 | `terraform init` | Downloads the `hashicorp/aws` provider plugin and initializes the working directory |
| 2 | `terraform fmt` | Rewrites `main.tf` into canonical HCL style (indentation, alignment) |
| 3 | `terraform validate` | Checks the configuration is syntactically valid and internally consistent |
| 4 | `terraform plan` | Shows the execution plan — should report **5 to add**, 0 to change, 0 to destroy |
| 5 | `terraform apply` | Prompts for confirmation, then creates the VPC, 2 subnets, and 2 S3 buckets |
| 6 | `terraform show` | Displays the resources currently tracked in state |
| 7 | `terraform destroy` | Tears down everything created, so the account isn't left running billable resources |

### Optional / discussion commands

| Command | Use |
|---|---|
| `terraform version` | Show installed Terraform + provider versions |
| `terraform plan -out=tfplan` | Save a plan to a file, then `terraform apply tfplan` to apply exactly that plan |
| `terraform apply -auto-approve` | Skip the interactive yes/no prompt (useful for demos, **not** recommended in production) |
| `terraform destroy -auto-approve` | Skip the confirmation prompt on teardown |

---

## 5. Suggested in-class flow

1. **Talk (10 min):** What is IaC? Why declarative > imperative? Show the HashiCorp provider registry to explain the plugin model.
2. **Walkthrough (10 min):** Open `main.tf`, read each block aloud — `terraform{}` → `provider{}` → `resource{}` — and point out the `aws_subnet` → `aws_vpc.my-vpc.id` reference as the first example of implicit dependency.
3. **Live demo (15 min):** Run `init` → `fmt` → `validate` → `plan` → `apply` → `show`, narrating what each command outputs.
4. **Verify in AWS Console (5 min):** Confirm the VPC, subnets, and buckets exist with the tags Terraform set.
5. **Clean up (5 min):** Run `destroy` and confirm resources are gone.
6. **Student exercise:** Ask students to add a third `aws_s3_bucket` resource themselves, then re-run `plan`/`apply` to see Terraform add only the new resource.

---

## 6. Cleanup checklist

- [ ] `terraform destroy` completed with no errors
- [ ] `terraform show` / AWS Console confirms no leftover VPC, subnets, or buckets
- [ ] Remind students that S3 bucket names are globally unique — if they change `bucket = "..."` values for the exercise, they must pick a unique name

---

## 7. Reference links

- [Terraform installation](https://developer.hashicorp.com/terraform/install)
- [AWS provider docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform core workflow](https://developer.hashicorp.com/terraform/intro/core-workflow)
- [HashiCorp Certified: Terraform Associate (004) exam objectives](https://developer.hashicorp.com/certifications/infrastructure-automation)
