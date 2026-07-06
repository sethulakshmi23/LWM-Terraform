# Detecting & Reconciling Drift

**Drift** is any difference between what's in Terraform state and what actually exists in the
cloud — caused by someone (or something) changing a resource outside of Terraform, e.g. via
the AWS Console or CLI.

## Step 1 — Create the baseline resource

```bash
terraform init
terraform apply -auto-approve
```

This creates an S3 bucket tagged `Environment = dev`.

## Step 2 — Manually cause drift

Change the tag directly through the AWS CLI, bypassing Terraform entirely:

```bash
aws s3api put-bucket-tagging \
  --bucket <your-bucket-name> \
  --tagging 'TagSet=[{Key=Environment,Value=prod}]'
```

Your real AWS resource now says `prod`; Terraform's state still says `dev`.

## Step 3 — Detect the drift

```bash
terraform plan
```

Terraform refreshes its view of the resource before computing the plan, notices the tag no
longer matches `main.tf`, and shows a diff — reverting `Environment` back to `dev`. This is
drift detection: **Terraform always treats the `.tf` configuration as the source of truth.**

## Step 4 — Reconcile: two directions

**(a) Config wins — push your configuration back onto the real resource**

```bash
terraform apply -auto-approve
```

**(b) Reality wins — adopt the drifted value into state without changing infrastructure**

```bash
terraform apply -refresh-only
```

`-refresh-only` updates *state* to match what's actually in AWS and shows you the diff for
approval, but does **not** touch the real resource. Use this when the manual change was
correct and you intend to edit `main.tf` to match it afterward — otherwise the next plain
`apply` will just overwrite it again.

## Step 5 — Inspect state directly

```bash
terraform state show aws_s3_bucket.drift_demo
```

## Step 6 — Clean up

```bash
terraform destroy -auto-approve
```

## Bonus: verbose logging while troubleshooting

If a `plan`/`apply` behaves unexpectedly, increase log verbosity:

```bash
TF_LOG=DEBUG terraform plan
TF_LOG=TRACE TF_LOG_PATH=./tf-trace.log terraform apply   # write TRACE-level logs to a file
```

Valid `TF_LOG` levels, from least to most verbose: `ERROR`, `WARN`, `INFO`, `DEBUG`, `TRACE`.
