module "eks" {
  source = "terraform-aws-modules/eks/aws"
  cluster_name = var.EKS_CLUSTER_NAME
  cluster_version = "1.20"
  subnets = module.vpc.private_subnets
  vpc_id = module.vpc.vpc_id
  write_kubeconfig = false
  enable_irsa = true
  create_eks = true

  node_groups_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = 20
  }

  node_groups = {
    "${var.EKS_CLUSTER_NAME}_node_group_01" = {
      desired_capacity = 1
      min_capacity = 1
      max_capacity = 10
      instance_types = [local.vpc_node_group_instance_type.01]
      eni_delete = true

//      k8s_labels = {
//        "kubernetes.io/cluster/${var.EKS_CLUSTER_NAME}"     = "owned"
//        "k8s.io/cluster-autoscaler/${var.EKS_CLUSTER_NAME}" = "owned"
//        "k8s.io/cluster-autoscaler/enabled"                 = "true"
//      }

      additional_tags = {
        "k8s.io/cluster-autoscaler/${var.EKS_CLUSTER_NAME}" = "owned"
        "k8s.io/cluster-autoscaler/enabled" = "true"
      }
    }
  }

  depends_on = [
    module.vpc.nat_ids
  ]
}
