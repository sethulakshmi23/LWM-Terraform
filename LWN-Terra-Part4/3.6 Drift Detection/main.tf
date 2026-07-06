resource "aws_s3_bucket" "drift_demo" {
  bucket = var.bucket_name

  tags = {
    Environment = "dev" # we will change this by hand outside Terraform in the README walkthrough
  }
}
