variable "AWS_ACCOUNT_ID" {
  default = ""
}

variable "EKS_CLUSTER_NAME" {
  default = "k8s_aws"
}

variable "ZONE" {
  default = "eu-west-1"
}

variable "ZONE_SUBNET_01" {
  default = "eu-west-1a"
}

variable "ZONE_SUBNET_02" {
  default = "eu-west-1b"
}

variable "ZONE_SUBNET_03" {
  default = "eu-west-1c"
}
