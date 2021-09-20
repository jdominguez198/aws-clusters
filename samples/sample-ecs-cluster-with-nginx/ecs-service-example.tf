resource "aws_ecs_task_definition" "example_task" {
  family = local.ecs_proxy_name
  requires_compatibilities = ["FARGATE"]
  cpu = local.ecs_proxy_task_cpu
  memory = local.ecs_proxy_task_memory
  network_mode = "awsvpc"
  execution_role_arn = module.ecs-sample.generic_task_execution_role_arn
  task_role_arn = module.ecs-sample.generic_task_ssm_role_arn

  container_definitions = jsonencode([
    {
      name = local.ecs_proxy_name
      image = local.ecs_service_image
      essential = true
      networkMode = "awsvpc"
      enableExecuteCommand = true,
      readonlyRootFilesystem = false,
      linuxParameters = {
        "initProcessEnabled" = true
      }
      portMappings = [
        {
          protocol = lower(local.ecs_lb_target_protocol),
          containerPort = local.ecs_service_port,
          hostPort = local.ecs_service_port
        }
      ]
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-region = local.ecs_cluster_region,
          awslogs-group = "${module.ecs-sample.cluster_name}-logs",
          awslogs-stream-prefix = "complete-ecs"
        }
      }
    }
  ])
}

resource "aws_security_group" "example_task_sg" {
  name = "${local.ecs_proxy_name}_sg"
  vpc_id = module.ecs-sample.cluster_vpc_id

  ingress {
    protocol = "tcp"
    from_port = local.ecs_service_port
    to_port = local.ecs_service_port
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
    namespace_id = module.ecs-sample.generic_service_discovery_namespace_id
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
  cluster = module.ecs-sample.cluster_id
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
    subnets = module.ecs-sample.cluster_vpc_public_subnets
  }

  load_balancer {
    target_group_arn = module.ecs-sample.cluster_nlb_target_group_arn
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
