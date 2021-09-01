module "eks" {
  source = "terraform-aws-modules/eks/aws"
  cluster_name = var.EKS_CLUSTER_NAME
  cluster_version = "1.20"
  subnets = module.vpc.private_subnets
  vpc_id = module.vpc.vpc_id
  write_kubeconfig = false
  enable_irsa = true
  create_eks = true

  node_groups = {
    "${var.EKS_CLUSTER_NAME}_ng_01" = {
      desired_capacity = local.eks_node_group_min
      min_capacity = local.eks_node_group_min
      max_capacity = local.eks_node_group_max
      instance_types = [local.vpc_node_group_instance_types["01_${local.vpc_node_group_instance_type}"].type]
      ami_type = local.vpc_node_group_instance_types["01_${local.vpc_node_group_instance_type}"].ami
      disk_size = local.vpc_node_group_instance_types["01_${local.vpc_node_group_instance_type}"].disk
      eni_delete = true

      additional_tags = {
        "k8s.io/cluster-autoscaler/${var.EKS_CLUSTER_NAME}" = "owned"
        "k8s.io/cluster-autoscaler/enabled" = "true"
      }
    }
  }

  fargate_profiles = {
    default = {
      name = "default"
      selectors = [
        {
          namespace = "fargate"
        }
      ]
    }
  }

  depends_on = [
    module.vpc.nat_ids
  ]
}
