locals {
  subnets = {
    01 = {
      private_cidr_block = "172.16.0.0/20"
      public_cidr_block = "172.16.96.0/20"
    }
    02 = {
      private_cidr_block = "172.16.16.0/20"
      public_cidr_block = "172.16.112.0/20"
    }
    03 = {
      private_cidr_block = "172.16.32.0/20"
      public_cidr_block = "172.16.132.0/20"
    }
  }

  subnet_gateway_cidr_block = "172.16.0.0/16"

  vpc_node_group_instance_type = {
    01 = "t3.small"
  }

  eks_node_group_min = 1
  eks_node_group_max = 10

  openid_connect_role_name = "OpenIDConnectRole"
  load_balancer_role_name = "LBControllerIAMPolicy"
  cluster_autoscaler_role_name = "KubernetesClusterAutoscaler"
}
