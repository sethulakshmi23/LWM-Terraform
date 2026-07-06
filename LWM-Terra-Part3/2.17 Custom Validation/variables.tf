# variable-level validation — checked before any plan/apply, independent of any resource
variable "bucket_name" {
  description = "Globally-unique S3 bucket name"
  type        = string
  default     = "lwm-day2-validation-demo"

  validation {
    condition     = can(regex("^[a-z0-9.-]{3,63}$", var.bucket_name))
    error_message = "bucket_name must be 3-63 characters long and contain only lowercase letters, numbers, dots, and hyphens (AWS S3 bucket naming rules)."
  }
}

variable "iam_username" {
  description = "IAM username to create"
  type        = string
  default     = "svc-terraform-demo"

  validation {
    condition     = length(var.iam_username) > 0 && length(var.iam_username) <= 64
    error_message = "iam_username must be between 1 and 64 characters (AWS IAM username limit)."
  }
}
