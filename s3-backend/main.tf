provider "aws" {
  profile = "default"
  region = var.ZONE
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.STATE_BUCKET_PREFIX}-k8s-aws-terraform-state"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
