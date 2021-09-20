# EKS Ingress

## Introduction

Create the Load Balancer (Ingress) for EKS Cluster in AWS using Terraform

## Prerequisites

- Non-root AWS user with enough credentials
- An EKS cluster. You can use module [eks-cluster](../eks-cluster) to create one.
- SSL certificates

## Getting Started

### Usage

You can consume this module using the following block:

```
module "alb-controller" {
  source = "../../modules/eks-alb-controller"

  cluster_name = "my_eks_cluster"
  name_prefix = "my_prefix"
  accelerator_name = "example-accelerator"
  region = "eu-west-1"
  eks_ingress_backend_name = "web-example"
  eks_ingress_backend_port = 80
  acm_ssl_key_path = "./certificates/ssl_key"
  acm_ssl_body_path = "./certificates/ssl_body"
  acm_ssl_chain_path = "./certificates/ssl_chain"
}
```

### Inputs

Name                                 | Description                                           | Type     | Default  |
-------------------------------------|-------------------------------------------------------|----------|----------|
cluster_name                         | Name used for the Cluster                             | string   | `n/a`
name_prefix                          | Prefix used for several resource names                | string   | `n/a`
accelerator_name                     | Name used for the Global Accelerator instance         | string   | `n/a`
region                               | Region where the Cluster will be created              | string   | `eu-west-1`
eks_ingress_backend_name             | Name of the default backend Ingress                   | string   | `n/a`
eks_ingress_backend_port             | Port of the default backend Ingress                   | number   | `n/a`
acm_ssl_key_path                     | Path of the SSL's Private Key file                    | string   | `n/a`
acm_ssl_body_path                    | Path of the SSL's Body file                           | string   | `n/a`
acm_ssl_chain_path                   | Path of the SSL's Chain file                          | string   | `n/a`

### Outputs

No output generated
