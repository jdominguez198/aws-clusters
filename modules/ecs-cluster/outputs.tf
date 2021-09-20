output "cluster_name" {
  description = "Cluster name generated"
  value = module.ecs.ecs_cluster_name
}

output "cluster_id" {
  description = "Cluster ID"
  value = module.ecs.ecs_cluster_id
}

output "cluster_vpc_id" {
  description = "Cluster's VPC ID"
  value = module.vpc.vpc_id
}

output "cluster_vpc_public_subnets" {
  description = "Cluster's VPC Public Subnets"
  value = module.vpc.public_subnets
}

output "cluster_vpc_private_subnets" {
  description = "Cluster's VPC Private Subnets"
  value = module.vpc.private_subnets
}

output "cluster_nlb_target_group_arn" {
  description = "Cluster's NLB Target Group ARN"
  value = module.nlb.target_group_arns.0
}

output "generic_task_execution_role_arn" {
  description = "IAM Role's ARN with basic permissions to use it as Task Execution Role"
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "generic_task_ssm_role_arn" {
  description = "IAM Role's ARN with basic permissions to use it as Task Role with SSM"
  value = aws_iam_role.ecs_task_ssm_role.arn
}

output "generic_service_discovery_namespace_id" {
  description = "Generic Service Discovery's ID for private usage"
  value = aws_service_discovery_private_dns_namespace.ecs_discovery_service_namespace.id
}
