# The `cloud` block switches Terraform from a local/S3 backend to HCP Terraform:
# runs execute remotely in HCP Terraform's own infrastructure, not on your machine.
terraform {
  cloud {
    organization = "your-org-name" # replace with your HCP Terraform organization

    workspaces {
      name = "lwm-day5-hcp-demo"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

# A cheap, safe resource so the remote run has something real to plan/apply.
resource "aws_s3_bucket" "hcp_demo" {
  bucket = "lwm-day5-hcp-demo-bucket-changeme" # must be globally unique

  tags = {
    ManagedBy = "HCP-Terraform"
  }
}
