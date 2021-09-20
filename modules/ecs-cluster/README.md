# ECS Cluster module

## Introduction

Create a ECS cluster with Network Load Balancer and Fargate provider in AWS using Terraform

## Getting Started

### Usage

You can consume this module using the following block:

```
module "my_ecs_cluster" {
  source = "../../modules/ecs-cluster"

  cluster_name = "example_cluster"
  name_prefix = "dev"
  eip_name = "my_elastic_ips"
}
```

### Inputs

Name                                 | Description                                           | Type     | Default  |
-------------------------------------|-------------------------------------------------------|----------|----------|
cluster_name                         | Name used for the Cluster                             | string   | `n/a`
name_prefix                          | Prefix used for several resource names                | string   | `n/a`
region                               | Region where the Cluster will be created              | string   | `eu-west-1`
region_zone_01                       | First region zone                                     | string   | `eu-west-1a`
region_zone_02                       | Second region zone                                    | string   | `eu-west-1b`
region_zone_03                       | Third region zone                                     | string   | `eu-west-1c`
eip_name                             | Name of the Elastic IPs for the Load Balancer         | string   | `n/a`
generic_service_discovery_namespace  | Namespace used for service discovery between services | string   | `local`


### Outputs

Name                                   | Description
---------------------------------------|-------------
cluster_name                           | Cluster name generated
cluster_id                             | Cluster ID
cluster_vpc_id                         | Cluster's VPC ID
cluster_vpc_public_subnets             | Cluster's VPC Public Subnets
cluster_vpc_private_subnets            | Cluster's VPC Private Subnets
cluster_nlb_target_group_arn           | Cluster's NLB Target Group ARN
generic_task_execution_role_arn        | IAM Role's ARN with basic permissions to use it as Task Execution Role
generic_task_ssm_role_arn              | IAM Role's ARN with basic permissions to use it as Task Role with SSM
generic_service_discovery_namespace_id | Generic Service Discovery's ID for private usage
