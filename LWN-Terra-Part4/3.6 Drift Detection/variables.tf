variable "bucket_name" {
  description = "Globally-unique S3 bucket name for the drift-detection demo"
  type        = string
  default     = "lwm-drift-demo-changeme" # must be globally unique — change before use
}
