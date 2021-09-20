module "ecs-eip" {
  source = "../../modules/elastic-ip"

  name = local.eks_elastic_ip_name
}

module "eks-cluster-sample" {
  source = "../../modules/eks-cluster"

  cluster_name = local.eks_cluster_name
  name_prefix = local.eks_cluster_prefix
  region = local.eks_cluster_region
  region_zone_01 = local.eks_cluster_region_zone_01
  region_zone_02 = local.eks_cluster_region_zone_02
  region_zone_03 = local.eks_cluster_region_zone_03

  depends_on = [
    module.ecs-eip.eip_01_id,
    module.ecs-eip.eip_02_id
  ]
}

module "eks-nginx-controller" {
  source = "../../modules/eks-nginx-controller"

  eip_name = local.eks_elastic_ip_name
  eks_ingress_namespace = local.eks_ingress_namespace
  eks_ingress_backend_name = local.eks_ingress_backend_name
  eks_ingress_backend_port = local.eks_ingress_backend_port
  acm_ssl_key_path = local.acm_ssl_key_path
  acm_ssl_body_path = local.acm_ssl_body_path
  acm_ssl_chain_path = local.acm_ssl_chain_path

  depends_on = [
    module.eks-cluster-sample.cluster_endpoint
  ]
}
