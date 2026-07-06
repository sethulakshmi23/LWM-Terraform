# Ephemeral Values & Write-Only Arguments

Two related, recent Terraform language features for handling secrets without ever writing them to state:

| Feature | Introduced | What it does |
|---|---|---|
| **Ephemeral values** | Terraform 1.10 | `ephemeral "TYPE" "NAME" {}` blocks, and `ephemeral = true` on variables/outputs, hold values that exist only for the current run and are never saved to the state file or the plan file. |
| **Write-only arguments** | Terraform 1.11 | A resource argument suffixed `_wo` (paired with a `_wo_version` counter) accepts an ephemeral value, sends it to the provider on apply, but never stores it in state. Changing `_wo_version` is what tells Terraform "re-send this value." |

## What's runnable in `main.tf` here

- `ephemeral "random_password" "demo"` — generates a 16-character password for this run only.
- `output "generated_password" { ephemeral = true }` — demonstrates the ephemeral-output syntax and Terraform's refusal to persist it.
- `aws_iam_user.demo` — an ordinary resource alongside it, for contrast.

Run the normal workflow (`init` → `plan` → `apply` → `destroy`) and then run `terraform show` / open `terraform.tfstate` — you will **not** find `generated_password` anywhere in it.

## Write-only arguments — reference only, not applied here

Write-only argument support is added **resource-by-resource** in each provider, so exact attribute names shift as providers catch up. The pattern HashiCorp uses in its own docs is `aws_db_instance` (RDS):

```hcl
# REFERENCE ONLY — do not apply in class; RDS costs money and takes several minutes to provision.
# Confirm the exact attribute names against the current AWS provider docs before presenting live.
resource "aws_db_instance" "example" {
  # ...other required RDS arguments...
  password_wo         = ephemeral.random_password.demo.result
  password_wo_version = 1
}
```

**Trainer note:** because this is one of the newest parts of the language, verify the exact resource/attribute support in the [AWS provider changelog](https://github.com/hashicorp/terraform-provider-aws/blob/main/CHANGELOG.md) and the [Terraform ephemeral values docs](https://developer.hashicorp.com/terraform/language/values/variables#ephemeral-values-in-variables-and-outputs) before a live demo — this folder's `main.tf` is deliberately scoped to the parts that are stable and cheap to run (an ephemeral resource + IAM user), while the write-only-argument snippet above is a syntax reference for exam purposes.

## Commands

```bash
terraform init
terraform plan
terraform apply
terraform show          # confirm generated_password is NOT present
terraform destroy
```
