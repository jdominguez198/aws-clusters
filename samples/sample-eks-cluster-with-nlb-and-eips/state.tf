terraform {
  backend "s3" {
    bucket = "state-eks-sample-nlb"
    key = "cluster/terraform.tfstate"
    region = "eu-west-1"
    encrypt = true
  }
}
