provider "aws" {
  region = var.ZONE
}

data "aws_caller_identity" "current" {}
