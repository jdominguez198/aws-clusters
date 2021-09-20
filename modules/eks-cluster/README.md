# EKS Cluster

## Introduction

Create a EKS cluster with AutoScaler in AWS using Terraform

## Prerequisites

- Non-root AWS user with enough credentials

## Getting Started

### Usage

You can consume this module using the following block:

```
module "eks-cluster-sample" {
  source = "../../modules/eks-cluster"

  cluster_name = "my_eks_cluster"
  name_prefix = "my_prefix"
  region = "eu-west-1"
  region_zone_01 = "eu-west-1a"
  region_zone_02 = "eu-west-1b"
  region_zone_03 = "eu-west-1c"
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

### Outputs

Name                                   | Description
---------------------------------------|-------------
cluster_id                             | Cluster ID
cluster_endpoint                       | Cluster Endpoint
cluster_vpc_id                         | Cluster VPC ID
