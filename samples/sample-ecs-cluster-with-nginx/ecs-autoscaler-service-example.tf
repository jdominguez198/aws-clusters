resource "aws_appautoscaling_target" "autoscaler_target_proxy" {
  max_capacity = local.ecs_proxy_autoscaler_max_tasks
  min_capacity = local.ecs_proxy_autoscaler_min_tasks
  resource_id = "service/${module.ecs-sample.cluster_name}/${aws_ecs_service.example_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
}

resource "aws_appautoscaling_policy" "autoscaler_policy_memory_proxy" {
  name = "${aws_ecs_service.example_service.name}-memory-autoscaling"
  policy_type = "TargetTrackingScaling"
  resource_id = aws_appautoscaling_target.autoscaler_target_proxy.resource_id
  scalable_dimension = aws_appautoscaling_target.autoscaler_target_proxy.scalable_dimension
  service_namespace = aws_appautoscaling_target.autoscaler_target_proxy.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value = local.ecs_proxy_autoscaler_cpu_average
    scale_in_cooldown = 120
    scale_out_cooldown = 120
  }
}

resource "aws_appautoscaling_policy" "autoscaler_policy_cpu_proxy" {
  name = "${aws_ecs_service.example_service.name}-cpu-autoscaling"
  policy_type = "TargetTrackingScaling"
  resource_id = aws_appautoscaling_target.autoscaler_target_proxy.resource_id
  scalable_dimension = aws_appautoscaling_target.autoscaler_target_proxy.scalable_dimension
  service_namespace = aws_appautoscaling_target.autoscaler_target_proxy.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = local.ecs_proxy_autoscaler_memory_average
    scale_in_cooldown = 120
    scale_out_cooldown = 120
  }
}
