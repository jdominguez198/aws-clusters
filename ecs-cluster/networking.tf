data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.7.0"

  name = "${module.ecs.ecs_cluster_name}_vpc"

  cidr = local.subnet_gateway_cidr_block
  azs = data.aws_availability_zones.available.names
  private_subnets = [ local.subnets.01.private_cidr_block, local.subnets.02.private_cidr_block ]
  public_subnets = [ local.subnets.01.public_cidr_block, local.subnets.02.public_cidr_block ]
  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true
  enable_dns_support = true

  manage_default_security_group  = true
  default_security_group_ingress = [
    {
      protocol = lower(local.ecs_lb_target_protocol)
      from_port = local.ecs_lb_target_port
      to_port = local.ecs_lb_target_port
      cidr_blocks = "0.0.0.0/0"
      ipv6_cidr_blocks = "::/0"
    }
  ]
  default_security_group_egress  = [
    {
      protocol = "-1"
      from_port = 0
      to_port = 0
      cidr_blocks = "0.0.0.0/0"
      ipv6_cidr_blocks = "::/0"
    }
  ]
}

resource "aws_service_discovery_private_dns_namespace" "ecs_discovery_service_namespace" {
  name = "test"
  vpc = module.vpc.vpc_id
}
