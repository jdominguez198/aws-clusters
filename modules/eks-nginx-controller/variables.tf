variable "eip_name" {
  description = "Name of the Elastic IPs for the Load Balancer"
  type = string
}

variable "eks_ingress_namespace" {
  description = "Name of the Ingress namespace"
  default = "ingress-nginx"
  type = string
}

variable "eks_ingress_backend_name" {
  description = "Name of the default backend Ingress"
  type = string
}

variable "eks_ingress_backend_port" {
  description = "Port of the default backend Ingress"
  type = number
}

variable "acm_ssl_key_path" {
  description = "Path of the SSL's Private Key file"
  type = string
}

variable "acm_ssl_body_path" {
  description = "Path of the SSL's Body file"
  type = string
}

variable "acm_ssl_chain_path" {
  description = "Path of the SSL's Chain file"
  type = string
}
