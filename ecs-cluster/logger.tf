resource "aws_cloudwatch_log_group" "proxy_log_group" {
  name = "ecs-app"
  retention_in_days = 1
}
