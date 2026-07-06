resource "aws_s3_bucket" "demo" {
  bucket = var.bucket_name

  # resource-level custom condition — checked at plan time, can reference the resource's
  # own arguments (a variable-level `validation` block cannot see other variables or resources)
  lifecycle {
    precondition {
      condition     = !startswith(var.bucket_name, "xn--")
      error_message = "Bucket names cannot start with the reserved prefix 'xn--' (AWS reserves it for Punycode domains)."
    }
  }
}

resource "aws_iam_user" "demo" {
  name = var.iam_username
}
