locals {
  subnets = {
    01 = {
      private_cidr_block = "172.16.1.0/24"
      public_cidr_block = "172.16.10.0/24"
    }
    02 = {
      private_cidr_block = "172.16.2.0/24"
      public_cidr_block = "172.16.11.0/24"
    }
    03 = {
      private_cidr_block = "172.16.3.0/24"
      public_cidr_block = "172.16.12.0/24"
    }
  }

  subnet_gateway_cidr_block = "172.16.0.0/16"

  vpc_node_group_instance_type = {
    01 = "t3.medium"
  }

  openid_connect_role_name = "S3-Readonly-OIDC-Role"
}
