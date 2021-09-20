variable "cluster_name" {
  description = "Name used for the Cluster"
  type = string
}

variable "name_prefix" {
  description = "Prefix used for several resource names"
  type = string
}

variable "accelerator_name" {
  description = "Name used for the Global Accelerator instance"
  type = string
}

variable "region" {
  description = "Region where the Cluster will be created"
  default = "eu-west-1"
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
