provider "aws" {
  profile = "default"
  region = var.ZONE
}

data "aws_caller_identity" "current" {}
