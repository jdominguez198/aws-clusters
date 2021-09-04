module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "3.3.0"
  name = "${var.PREFIX}_${var.ECS_CLUSTER_NAME}"
  container_insights = true
  capacity_providers = ["FARGATE"]
}
