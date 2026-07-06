# SET — an unordered collection of unique strings (no duplicates, no index access)
variable "iam_usernames" {
  description = "IAM usernames to create. A set silently de-duplicates and has no guaranteed order."
  type        = set(string)
  default     = ["dev-alice", "dev-bob", "dev-carol"]
}

# OBJECT — a structured record with named attributes, each with its own type
variable "bucket_config" {
  description = "Structured configuration for the demo S3 bucket"
  type = object({
    name        = string
    versioning  = bool
    environment = string
  })
  default = {
    name        = "lwm-day2-complex-types-demo"
    versioning  = true
    environment = "dev"
  }
}

# TUPLE — a fixed-length sequence where each position can have a different type
variable "bucket_lifecycle_rule" {
  description = "tuple(rule_id, enabled, expiration_days) — order and length are fixed"
  type        = tuple([string, bool, number])
  default     = ["expire-old-versions", true, 30]
}
