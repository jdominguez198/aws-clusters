module "nlb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "6.5.0"

  name = "${replace(module.ecs.ecs_cluster_name, "_", "-")}-nlb"
  load_balancer_type = "network"

  vpc_id = module.vpc.vpc_id
  enable_cross_zone_load_balancing = true

  # Use subnets for attaching IPs auto-assigned
//  subnets = module.vpc.public_subnets

  # Use subnet_mapping to attach specific EIPs
  subnet_mapping = [
    {
      allocation_id = data.aws_eip.eip-01.id
      subnet_id = module.vpc.public_subnets[0]
    },
    {
      allocation_id = data.aws_eip.eip-02.id
      subnet_id = module.vpc.public_subnets[1]
    }
  ]

  http_tcp_listeners = [
    {
      port = local.ecs_lb_target_port
      protocol = local.ecs_lb_target_protocol
      target_group_index = 0
      action_type = "forward"
    }
  ]

  target_groups = [
    {
      name_prefix = "h1"
      backend_protocol = local.ecs_lb_target_protocol
      backend_port = local.ecs_lb_target_port
      target_type = "ip"
      deregistration_delay = 10
    }
  ]
}
