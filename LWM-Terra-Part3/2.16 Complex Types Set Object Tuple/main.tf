# SET in action: for_each over a set(string) creates one IAM user per unique username
resource "aws_iam_user" "team" {
  for_each = var.iam_usernames
  name     = each.value
}

# OBJECT in action: dot-notation access into a structured variable
resource "aws_s3_bucket" "demo" {
  bucket = var.bucket_config.name

  tags = {
    Environment = var.bucket_config.environment
  }
}

resource "aws_s3_bucket_versioning" "demo" {
  bucket = aws_s3_bucket.demo.id
  versioning_configuration {
    status = var.bucket_config.versioning ? "Enabled" : "Disabled"
  }
}

# TUPLE in action: fixed-position index access — [0]=rule_id, [1]=enabled, [2]=expiration_days
output "lifecycle_rule_id" {
  value = var.bucket_lifecycle_rule[0]
}

output "lifecycle_rule_enabled" {
  value = var.bucket_lifecycle_rule[1]
}

output "lifecycle_rule_expiration_days" {
  value = var.bucket_lifecycle_rule[2]
}

output "iam_usernames_created" {
  value = [for u in aws_iam_user.team : u.name]
}
