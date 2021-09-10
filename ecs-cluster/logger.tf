resource "aws_cloudwatch_log_group" "proxy_log_group" {
  name = "${module.ecs.ecs_cluster_name}-logs"
  retention_in_days = 1
}
