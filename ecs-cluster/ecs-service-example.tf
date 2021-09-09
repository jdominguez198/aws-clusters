resource "aws_ecs_task_definition" "example_task" {
  family = local.ecs_proxy_name
  requires_compatibilities = ["FARGATE"]
  cpu = local.ecs_proxy_task_cpu
  memory = local.ecs_proxy_task_memory
  network_mode = "awsvpc"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn = aws_iam_role.ecs_task_ssm_role.arn

  container_definitions = file("./task-definitions/proxy-example.json")
}

resource "aws_security_group" "example_task_sg" {
  name = "${local.ecs_proxy_name}_sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_service_discovery_service" "example_task_discovery" {
  name = local.ecs_proxy_name

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.ecs_discovery_service_namespace.id
    routing_policy = "MULTIVALUE"

    dns_records {
      ttl = 5
      type = "A"
    }
  }

  health_check_custom_config {
    failure_threshold = 5
  }
}

resource "aws_ecs_service" "example_service" {
  name = local.ecs_proxy_name
  cluster = module.ecs.ecs_cluster_id
  task_definition = aws_ecs_task_definition.example_task.arn
  enable_ecs_managed_tags = true
  enable_execute_command = true

  desired_count = 1

  deployment_maximum_percent = 100
  deployment_minimum_healthy_percent = 0
  launch_type = "FARGATE"

  network_configuration {
    # If task_definition use a non private image, the assign_public_ip should be true
    assign_public_ip = true
    security_groups = [aws_security_group.example_task_sg.id]
    subnets = module.vpc.private_subnets
  }

  load_balancer {
    target_group_arn = module.nlb.target_group_arns.0
    container_name = local.ecs_proxy_name
    container_port = local.ecs_service_port
  }

  service_registries {
    registry_arn = aws_service_discovery_service.example_task_discovery.arn
    container_name = local.ecs_proxy_name
  }

  lifecycle {
    # Subsequent deploys are likely to be done through an external deployment pipeline
    #  so if this is rerun without ignoring the task def change
    #  then terraform will roll it back :(
//    ignore_changes = [
//      task_definition,
//      desired_count
//    ],
    create_before_destroy = true
  }
}
