locals {
  // vpc common
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

  // eks-cluster related
  vpc_node_group_instance_types = {
    "01_x86" = {
      type = "t3.small"
      ami = "AL2_x86_64"
      disk = 20
    }
    "01_ARM" = {
      type = "t4g.small"
      ami = "AL2_ARM_64"
      disk = 20
    }
  }
  vpc_node_group_instance_type = "x86"

  eks_node_group_min = 1
  eks_node_group_max = 10

  openid_connect_role_name = "OpenIDConnectRole"
  load_balancer_role_name = "LBControllerIAMPolicy"
  cluster_autoscaler_role_name = "KubernetesClusterAutoscaler"

  // nginx-controller related
  base_name = "ingress-nginx"
  service_account_name = "ingress-nginx"

  common_labels = {
    "app.kubernetes.io/name" = "ingress-nginx"
    "app.kubernetes.io/instance" = "ingress-nginx"
  }

  component_controller_labels = {
    "app.kubernetes.io/component" = "controller"
  }

  component_admission_webhook_labels = {
    "app.kubernetes.io/component" = "admission-webhook"
  }

  // ecs-cluster related
  ecs_proxy_name = "proxy-example"
  ecs_lb_target_port = 80
  ecs_lb_target_protocol = "TCP"
  ecs_service_image = "nginx:latest"
  ecs_service_port = 80
  ecs_proxy_task_cpu = "256"
  ecs_proxy_task_memory = "512"
  ecs_proxy_autoscaler_min_tasks = 1
  ecs_proxy_autoscaler_max_tasks = 3
  ecs_proxy_autoscaler_cpu_average = 20
  ecs_proxy_autoscaler_memory_average = 20

}
