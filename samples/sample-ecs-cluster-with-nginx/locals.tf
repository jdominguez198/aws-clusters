locals {
  ecs_cluster_name = "ecs_sample"
  ecs_cluster_prefix = "on"
  ecs_cluster_region = "eu-west-1"
  ecs_cluster_region_zone_01 = "eu-west-1a"
  ecs_cluster_region_zone_02 = "eu-west-1b"
  ecs_cluster_region_zone_03 = "eu-west-1c"
  ecs_elastic_ip_name = "ecs_sample_ips"
  ecs_generic_service_discovery_name = "ecs_sample_local"

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
