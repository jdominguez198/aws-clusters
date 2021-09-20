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

  ecs_lb_target_port = 80
  ecs_lb_target_protocol = "TCP"
}
