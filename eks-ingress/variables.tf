variable "GA_NAME" {
  default = "k8s-aws-ga-ip"
}

variable "ZONE" {
  default = "eu-west-1"
}

variable "EKS_CLUSTER_NAME" {
  default = "k8s_aws"
}

variable "INGRESS_BACKEND_SERVICE_NAME" {
  default = ""
}

variable "INGRESS_BACKEND_SERVICE_PORT" {
  default = "80"
}
