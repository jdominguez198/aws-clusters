module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "3.3.0"
  name = "${var.name_prefix}_${var.cluster_name}"
  container_insights = true
  capacity_providers = ["FARGATE"]
}
