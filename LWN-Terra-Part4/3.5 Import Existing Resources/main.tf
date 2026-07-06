# Resource block matching a bucket that already exists in AWS but was NOT created by Terraform.
# Bring it under management with either the classic `terraform import` command (Step 3 in the
# README) or the modern `import` block below (Step 4) — see README.md for the full walkthrough.
resource "aws_s3_bucket" "imported" {
  bucket = var.existing_bucket_name
}

# Modern (Terraform 1.5+) import block — declarative alternative to `terraform import`.
# Leave commented until you've created the bucket out-of-band (README Step 1).
# import {
#   to = aws_s3_bucket.imported
#   id = var.existing_bucket_name
# }
