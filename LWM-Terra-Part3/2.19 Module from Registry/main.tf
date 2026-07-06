# Terraform sources modules three ways — only the Registry form is applied below;
# the other two are shown as comments so all three syntaxes are visible side by side.

# 1) LOCAL PATH source — see "2.14 Modules" and "2.15 Our Own Module Example"
# source = "./modules/s3"

# 2) GIT source — pin to a tag/branch/commit with `?ref=`
# source = "git::https://github.com/example/terraform-modules.git//s3?ref=v1.2.0"

# 3) TERRAFORM REGISTRY source — <NAMESPACE>/<NAME>/<PROVIDER>, version-pinned like a provider
module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.0" # constrains which module versions `terraform init` may download

  bucket = "lwm-day4-registry-module-demo"

  tags = {
    Environment = "dev"
    ManagedBy   = "terraform-registry-module"
  }
}

output "bucket_arn" {
  value = module.s3_bucket.s3_bucket_arn
}
