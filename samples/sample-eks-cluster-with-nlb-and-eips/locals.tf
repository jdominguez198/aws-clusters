locals {
  eks_cluster_name = "eks_nlb_sample"
  eks_cluster_prefix = "on"
  eks_elastic_ip_name = "eks_nlb_sample_ips"
  eks_cluster_region = "eu-west-1"
  eks_cluster_region_zone_01 = "eu-west-1a"
  eks_cluster_region_zone_02 = "eu-west-1b"
  eks_cluster_region_zone_03 = "eu-west-1c"
  eks_ingress_namespace = "ingress-nginx"
  eks_ingress_backend_name = "nginx-example"
  eks_ingress_backend_port = 80
  acm_ssl_key_path = "./certificates/ssl_key"
  acm_ssl_body_path = "./certificates/ssl_body"
  acm_ssl_chain_path = "./certificates/ssl_chain"
}
