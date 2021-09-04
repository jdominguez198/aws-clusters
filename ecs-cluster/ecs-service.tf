resource "aws_cloudwatch_log_group" "proxy_log_group" {
  name = local.ecs_proxy_name
  retention_in_days = 1
}

resource "aws_ecs_task_definition" "proxy_task" {
  family = local.ecs_proxy_name
  requires_compatibilities = ["FARGATE"]
  cpu = local.ecs_proxy_task_cpu
  memory = local.ecs_proxy_task_memory
  network_mode = "awsvpc"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name = local.ecs_proxy_name
      image = local.ecs_service_image
      essential = true
      networkMode = "awsvpc"
      enableExecuteCommand = true
      portMappings = [
        {
          protocol = "tcp"
          containerPort = local.ecs_service_port
          hostPort = local.ecs_service_port
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-region" = var.ZONE
          "awslogs-group" = local.ecs_proxy_name
          "awslogs-stream-prefix" = "complete-ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "proxy_service" {
  name = local.ecs_proxy_name
  cluster = module.ecs.ecs_cluster_id
  task_definition = aws_ecs_task_definition.proxy_task.arn
  enable_ecs_managed_tags = true
  enable_execute_command = true

  desired_count = 1

  deployment_maximum_percent = 100
  deployment_minimum_healthy_percent = 0
  launch_type = "FARGATE"

  network_configuration {
    # If task_definition use a non private image, the assign_public_ip should be true
    assign_public_ip = true
    security_groups = [module.vpc.default_security_group_id]
    subnets = module.vpc.private_subnets
  }

  load_balancer {
    target_group_arn = module.nlb.target_group_arns.0
    container_name = local.ecs_proxy_name
    container_port = local.ecs_service_port
  }

  lifecycle {
    # Subsequent deploys are likely to be done through an external deployment pipeline
    #  so if this is rerun without ignoring the task def change
    #  then terraform will roll it back :(
    ignore_changes = [
      task_definition,
      desired_count
    ]
  }
}
