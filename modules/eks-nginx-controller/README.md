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


### Inputs

Name                                 | Description                                           | Type     | Default  |
-------------------------------------|-------------------------------------------------------|----------|----------|
eip_name                             | Name of the Elastic IPs for the Load Balancer         | string   | `n/a`
eks_ingress_namespace                | Name of the Ingress namespace                         | string   | `ingress-nginx`
eks_ingress_backend_name             | Name of the default backend Ingress                   | string   | `n/a`
eks_ingress_backend_port             | Port of the default backend Ingress                   | number   | `n/a`
acm_ssl_key_path                     | Path of the SSL's Private Key file                    | string   | `n/a`
acm_ssl_body_path                    | Path of the SSL's Body file                           | string   | `n/a`
acm_ssl_chain_path                   | Path of the SSL's Chain file                          | string   | `n/a`


### Outputs

No output generated
