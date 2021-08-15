variable "ZONE" {
  default = "eu-west-1"
}

variable "EKS_CLUSTER_NAME" {
  default = "k8s_aws"
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

variable "STATIC_IP_NAME" {
  default = "k8s_aws_eip"
}
