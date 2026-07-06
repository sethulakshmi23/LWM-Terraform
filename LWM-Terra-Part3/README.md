# Day 2 & Day 4 — Terraform Configuration + Modules

Lab material for **Day 2** (variables, outputs, data sources, complex types, validation) and
**Day 4** (modules) of the Terraform Associate (004) course, in `LWM-Terra-Part3/`.
Maps to exam **Domain 4** (Terraform configuration) and **Domain 5** (Terraform modules).

> This folder's numbering mixes both days under one `2.x` sequence, matching how it was
> originally taught — `2.1`–`2.13` are Day 2 (variables/outputs/locals/data), `2.14`–`2.19`
> are Day 4 (modules) plus the Day 2 gap-fill items added below.

For install steps and core-workflow commands, see [Part1's README](../LWM-Terra-Part1/README.md).

---

## 1. What's in this folder

### Day 2 — Variables, Outputs, Locals, Data Sources

| Folder | Files | Feature taught |
|---|---|---|
| [`2.1 Variables Basic`](2.1%20Variables%20Basic) | `main.tf`, `variables.tf`, `provider.tf` | Declaring variables with `description`/`type`/`default`; EC2 instance parameterized by 3 variables |
| [`2.2 Variables when prompted`](2.2%20Variables%20when%20prompted) | same 3 files | A variable **without** a default (`ec2_instance_type`) — Terraform prompts for it interactively |
| [`2.3 Variables override with CLI`](2.3%20Variables%20override%20with%20CLI) | same 3 files | Overriding a defaulted variable with `terraform apply -var="ec2_instance_type=..."` |
| [`2.4 Variables override with ENV`](2.4%20Variables%20override%20with%20ENV) | same 3 files | Overriding via `TF_VAR_ec2_instance_type` environment variable |
| [`2.5 Variables with terraform tfvars`](2.5%20Variables%20with%20terraform%20tfvars) | + `terraform.tfvars` | The auto-loaded `terraform.tfvars` file |
| [`2.6 Variables with multiple tfvars`](2.6%20Variables%20with%20multiple%20tfvars) | + `dev.tfvars`, `prod.tfvars` | Named var-files: `terraform plan -var-file="dev.tfvars"` |
| [`2.7 Variables with auto tfvars`](2.7%20Variables%20with%20auto%20tfvars) | + `web.auto.tfvars` | `*.auto.tfvars` files load automatically, no `-var-file` flag needed |
| [`2.8 Variables with List`](2.8%20Variables%20with%20List) | same 3 files | `type = list(string)`, indexed access `var.x[2]` |
| [`2.9 Variables with Map`](2.9%20Variables%20with%20Map) | same 3 files | `type = map(string)`, key lookups `var.x["big-apps"]` |
| [`2.10 Variables with Secrets`](2.10%20Variables%20with%20Secrets) | `main.tf`, `provider.tf`, `terraform.tfvars`, `variables.tf` | `sensitive = true` on an RDS password variable |
| [`2.11 Outputs`](2.11%20Outputs) | `main.tf`, `output.tf`, `provider.tf`, `variable.tf` | `output` blocks reading resource attributes (`public_ip`, `private_ip`) |
| [`2.12 Locals`](2.12%20Locals) | `main.tf`, `provider.tf`, `variable.tf` | `locals {}` + string interpolation (`${local.Project}`) across 3 different resource types |
| [`2.13 Data Sources`](2.13%20Data%20Sources) | `main.tf`, `provider.tf` | `data "aws_vpc"` reading an existing VPC, then creating a subnet inside it |
| [`2.16 Complex Types Set Object Tuple`](2.16%20Complex%20Types%20Set%20Object%20Tuple) *(new)* | `main.tf`, `variables.tf`, `provider.tf` | `set(string)`, `object({...})`, `tuple([...])` — the 3 complex types not otherwise covered |
| [`2.17 Custom Validation`](2.17%20Custom%20Validation) *(new)* | `main.tf`, `variables.tf`, `provider.tf` | Variable `validation {}` blocks + a resource `lifecycle.precondition` |
| [`2.18 Ephemeral Values and Write-Only Arguments`](2.18%20Ephemeral%20Values%20and%20Write-Only%20Arguments) *(new)* | `main.tf`, `provider.tf`, `README.md` | Terraform 1.10/1.11 `ephemeral` resources/outputs; write-only arguments (reference) |

### Day 4 — Modules

| Folder | Files | Feature taught |
|---|---|---|
| [`2.14 Modules`](2.14%20Modules) | `main.tf`, `output.tf`, `provider.tf`, `variables.tf`, `modules/s3/*` | Calling a **local-path** child module (`./modules/s3`) and reading its outputs |
| [`2.15 Our Own Module Example`](2.15%20Our%20Own%20Module%20Example) | `main.tf`, `provider.tf`, `modules/vpc/*` | Authoring your own reusable VPC module from scratch (root calls `./modules/vpc`) |
| [`2.19 Module from Registry`](2.19%20Module%20from%20Registry) *(new)* | `main.tf`, `provider.tf` | Sourcing a module from the **public Terraform Registry** with a pinned `version`, alongside commented-out local/Git source syntax for comparison |

**Total: 19 labs.** Everything new added in `2.16`–`2.19` uses only `aws_s3_bucket` and
`aws_iam_user` — cheap, free-tier-safe resource types, consistent with the rest of the course.

---

## 2. Known issues in the pre-existing labs (read before teaching)

These were found while auditing the folder against the syllabus. Two were live bugs that would
block students entirely; both are now fixed. The rest are trainer notes, not fixed, since they're
either intentional teaching points or genuinely unused scaffolding.

| Folder | Issue | Status |
|---|---|---|
| `2.5 Variables with terraform tfvars` | `provider.tf` referenced `var.aws_region`, but `variables.tf`/`terraform.tfvars` both declare `aws_region_123` — Terraform would fail with "reference to undeclared variable." | **Fixed** — `provider.tf` now reads `var.aws_region_123`. |
| `2.15 Our Own Module Example` | `main.tf` had `module aws_vpc { ... }` (missing quotes around the label — invalid HCL, fails to parse) and pointed `source` at `/opt/modules/vpc/`, an absolute path that doesn't exist on a student's machine. | **Fixed** — now `module "aws_vpc" { source = "./modules/vpc" ... }`, which resolves to the real, working VPC module already sitting in this same folder. |
| `2.14 Modules` | `main.tf`'s second module call points `source = "/root/myfolder/vpc"` — an absolute path specific to the original instructor's machine, not present in this repo. The in-repo `modules/vpc/` folder here is unrelated leftover scaffolding (its `main.tf`/`outputs.tf`/`variables.tf` contents don't match a working module). | **Not fixed** — comment out the `my-vpc` module block before running `terraform init`, or point it at a real path. Only the `website_s3_bucket` module call is runnable as-is. |
| `2.15 Our Own Module Example` | `modules/ec2/` and `modules/s3/` subfolders each contain three 0-byte files. `main.tf` doesn't call either. | **Not fixed** — unused placeholders; safe to ignore or delete. |

---

## 3. Commands to run

Standard workflow, run inside each subfolder:

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform destroy
```

### Lab-specific command variations

| Folder | Extra command |
|---|---|
| `2.2 Variables when prompted` | Just run `terraform plan` with no flags — Terraform will prompt for `ec2_instance_type` interactively |
| `2.3 Variables override with CLI` | `terraform apply -var="ec2_instance_type=t3.micro"` |
| `2.4 Variables override with ENV` | `export TF_VAR_ec2_instance_type=t3.medium` (bash) or `$env:TF_VAR_ec2_instance_type="t3.medium"` (PowerShell), then plain `terraform apply` |
| `2.6 Variables with multiple tfvars` | `terraform plan -var-file="dev.tfvars"` and `terraform plan -var-file="prod.tfvars"` |
| `2.11 Outputs` | `terraform output` and `terraform output ec2_instance_publicip` after apply |
| `2.13 Data Sources` | `terraform apply -var="vpc_id=vpc-xxxxxxxx"` — supply a real VPC ID from your account (e.g. the default VPC, or one created in an earlier lab) |
| `2.17 Custom Validation` | Try `terraform apply -var="bucket_name=AB"` (too short/uppercase) to see the `validation` error fire before any AWS call is made |
| `2.18 Ephemeral Values...` | After `apply`, run `terraform show` and confirm `generated_password` is **not** present anywhere in state |
| `2.19 Module from Registry` | `terraform init` here downloads the module itself, not just the provider — watch the extra "Downloading..." line in the output |

---

## 4. Syllabus topics covered here

| Day 2 topic | Covered? | Where |
|---|---|---|
| `resource` vs `data` blocks | ✅ | `2.13 Data Sources` |
| Input variables & outputs | ✅ | `2.1`–`2.9`, `2.11` |
| Cross-resource references | ✅ | Implicit throughout (`aws_vpc.my-vpc.id`, `aws_instance...public_ip`) |
| Complex types: list, map | ✅ | `2.8`, `2.9` |
| Complex types: **set, object, tuple** | ✅ *(new)* | `2.16` |
| Dynamic configuration with expressions & functions | ✅ | `Part4/3.4 functions`; string interpolation throughout |
| `depends_on` & `create_before_destroy` | ✅ | `Part2/1.10`, `Part2/1.7` |
| Custom validation (`validation`, `precondition`) | ✅ *(new)* | `2.17` |
| Sensitive data: `sensitive = true` | ✅ | `2.10 Variables with Secrets` |
| Sensitive data: ephemeral values & write-only arguments | ✅ *(new, with caveats — see `2.18`'s own README)* | `2.18` |

| Day 4 topic | Covered? | Where |
|---|---|---|
| Why modules / composition / reuse | ✅ | `2.14`, `2.15` |
| Root & child modules, structure | ✅ | `2.15/modules/vpc` |
| Module sourcing: local | ✅ | `2.14`, `2.15` |
| Module sourcing: **Git / Registry** | ✅ *(new)* | `2.19` (Registry applied; Git shown as commented reference) |
| Variable scope within modules | ✅ | Every child module's own `variable.tf` |
| Managing/constraining module versions | ✅ *(new)* | `2.19`'s `version = "~> 4.0"` |
| Dependency lock file (`.terraform.lock.hcl`) | ⚠️ Conceptual | Generated automatically by `terraform init` in any of these folders — show the file, explain it's provider-version locking (module version locking is separate, handled by the `version` constraint itself) |

---

## 5. Suggested in-class flow

**Day 2 session:**
1. `2.1`–`2.2` — declaring variables, defaults vs. prompted (10 min)
2. `2.3`–`2.7` — the 5 ways to supply a variable value, in precedence order: CLI `-var` > `*.tfvars` (named) > `*.auto.tfvars` > `TF_VAR_*` env > default (15 min)
3. `2.8`–`2.9`, `2.16` — list, map, set, object, tuple (15 min)
4. `2.11`–`2.12` — outputs and locals (10 min)
5. `2.13` — data sources (10 min)
6. `2.10`, `2.17`, `2.18` — sensitive data, validation, and the newest ephemeral/write-only features (15 min)

**Day 4 session:**
1. `2.14` — calling a pre-built child module, reading its outputs (10 min) — mention the known `/root/myfolder/vpc` issue and skip/comment that block
2. `2.15` — build your own module from scratch, walk through `modules/vpc/{main,variable,output}.tf` (20 min)
3. `2.19` — Registry sourcing + version pinning, contrasted with local/Git (10 min)
4. Wrap with `.terraform.lock.hcl`: open the file after any `terraform init`, explain it's what makes `terraform init` reproducible across machines

---

## 6. Cleanup checklist

- [ ] `terraform destroy` in every subfolder that was applied (each has independent state)
- [ ] `2.13 Data Sources` only *creates* a subnet — destroying it won't touch the VPC you read via `data`
- [ ] `2.10 Variables with Secrets` provisions an RDS instance — confirm it's actually destroyed (RDS is the one non-trivial-cost resource in this folder)
- [ ] Double check no stray S3 buckets/IAM users remain from `2.16`, `2.17`, `2.18`, `2.19`

---

## 7. Reference links

- [Variables and precedence](https://developer.hashicorp.com/terraform/language/values/variables)
- [Complex types](https://developer.hashicorp.com/terraform/language/expressions/type-constraints)
- [Custom validation rules](https://developer.hashicorp.com/terraform/language/values/variables#custom-validation-rules)
- [Ephemeral values](https://developer.hashicorp.com/terraform/language/values/variables#ephemeral-values-in-variables-and-outputs)
- [Modules overview](https://developer.hashicorp.com/terraform/language/modules)
- [Module sources](https://developer.hashicorp.com/terraform/language/modules/sources)
