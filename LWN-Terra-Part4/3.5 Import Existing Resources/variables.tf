variable "existing_bucket_name" {
  description = "Name of the S3 bucket created OUTSIDE Terraform that we're about to import"
  type        = string
  default     = "lwm-import-demo-changeme" # must be globally unique — change before use
}
