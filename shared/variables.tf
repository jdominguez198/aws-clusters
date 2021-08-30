variable "PREFIX" {
  default = "prefix"
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

variable "INGRESS_NAMESPACE" {
  default = "ingress-nginx"
}

variable "INGRESS_BACKEND_SERVICE_NAME" {
  default = "nginx-example"
}

variable "INGRESS_BACKEND_SERVICE_PORT" {
  default = "80"
}

variable "ELASTIC_IP_NAME" {
  default = "k8s_aws_eip"
}

variable "GA_NAME" {
  default = "k8s-aws-gaip"
}

variable "STATE_BUCKET_PREFIX" {
  default = "prefix"
}
