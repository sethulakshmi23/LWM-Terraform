# Importing Existing Infrastructure into State

Terraform doesn't know about resources it didn't create. This lab creates an S3 bucket
**by hand** (simulating infrastructure that existed before Terraform showed up), then brings
it under Terraform management two ways: the classic `terraform import` command, and the
modern (1.5+) declarative `import` block.

## Step 1 — Create a bucket outside Terraform

```bash
aws s3api create-bucket \
  --bucket lwm-import-demo-<yourname> \
  --region ap-south-1 \
  --create-bucket-configuration LocationConstraint=ap-south-1
```

Pick a globally-unique `<yourname>` suffix. This bucket now exists in AWS with **zero** Terraform involvement.

## Step 2 — Update `variables.tf`

Set `existing_bucket_name` to the exact bucket name you just created.

## Step 3 — Classic import: `terraform import`

```bash
terraform init
terraform import aws_s3_bucket.imported lwm-import-demo-<yourname>
terraform plan
```

`terraform plan` should now show **no changes** (or only minor drift for attributes not yet
in `main.tf`) — the resource block in `main.tf` already matches, because `bucket` is the only
argument set. This is the command still tested as the primary import mechanism on the
Terraform Associate (004) exam.

## Step 4 — Modern import: the `import` block (Terraform 1.5+)

Instead of a separate CLI command, declare the import in code so it's reviewable in a PR:

```hcl
import {
  to = aws_s3_bucket.imported
  id = "lwm-import-demo-<yourname>"
}
```

Uncomment the block in `main.tf`, then run:

```bash
terraform plan -generate-config-out=generated.tf
terraform apply
```

`-generate-config-out` writes a best-effort resource block for you into `generated.tf` — handy
when you don't want to hand-author the resource block first. Review the generated file, fold
anything you need into `main.tf`, then delete `generated.tf`. The `import` block itself is safe
to leave in place; it becomes a no-op once the resource is already in state.

## Step 5 — Verify and clean up

```bash
terraform state list          # confirm aws_s3_bucket.imported is tracked
terraform state show aws_s3_bucket.imported
terraform destroy             # this WILL delete the bucket — import means Terraform now owns it
```

**Trainer note:** make sure students understand that importing a resource makes Terraform
fully authoritative over it — a subsequent `terraform destroy` really does delete it, even
though Terraform didn't create it.
