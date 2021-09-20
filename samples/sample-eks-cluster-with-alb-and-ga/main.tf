module "ga" {
  source = "../../modules/global-accelerator"

  name = local.eks_ga_name
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
    module.ga.ga_dns_name
  ]
}

module "alb-controller" {
  source = "../../modules/eks-alb-controller"

  cluster_name = local.eks_cluster_name
  name_prefix = local.eks_cluster_prefix
  accelerator_name = local.eks_ga_name
  region = local.eks_cluster_region
  eks_ingress_backend_name = local.eks_ingress_backend_name
  eks_ingress_backend_port = local.eks_ingress_backend_port
  acm_ssl_key_path = local.acm_ssl_key_path
  acm_ssl_body_path = local.acm_ssl_body_path
  acm_ssl_chain_path = local.acm_ssl_chain_path

  depends_on = [
    module.eks-cluster-sample.cluster_id,
    module.eks-cluster-sample.cluster_vpc_id
  ]
}
