terraform {
  backend "s3" {
    bucket = "state-ecs-sample-nginx"
    key = "cluster/terraform.tfstate"
    region = "eu-west-1"
    encrypt = true
  }
}
