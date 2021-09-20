# AWS Clusters modules & deployments

## Table of contents
- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
  - [Modules](#modules)
  - [Samples](#samples)
- [Resources](#resources)

## Introduction

This repository contains multiple approaches to build and deploy Clusters in AWS, using ECS & EKS services.

As part of the approaches, you can get the following services usages:

- Cluster using EKS service
- Node groups with EC2 provisioning
- AutoScaler to manage horizontal escalation in Node groups
- Fargate profiles for specific namespaces and/or pods
- Load Balancer using ALB or NLB
- TLS certificates for Load Balancer using ACM
- Global static IP for Application Load Balancer using Global Accelerator
- Elastic IPs as static IPs for Network Load Balancer
- ECS Cluster with Elastic IPs and Network Load Balancer using FARGATE

## Prerequisites

- AWS account (obviously). Recommended to use non-root user for credentials
- AWS-CLI
- Terraform
- kubectl
- TLS certificates (`ssl_key`, `ssl_body`, and `ssl_chain`)

## Getting started

### Modules

- [ECS Cluster](modules/ecs-cluster) => Create a Cluster using ECS service with a Network Load Balancer for connect
  a pair of Elastic IPs to be used in an external DNS
- [EKS Cluster](modules/eks-cluster) => Create a Cluster using EKS service (Kubernetes) with EC2 node pool and a
  Fargate profile to be used in combination of an Application Load Balancer or a Network Load Balancer
- [EKS Application Load Balancer](modules/eks-alb-controller) => Create an Application Load Balancer to allow public
  traffic to access the EKS cluster as an Ingress, using Global Accelerator to expose the public IPs
- [Global Accelerator](modules/global-accelerator) => Create an Accelerator using the Global Accelerator service to
  create a pair of Public IPs with high availability and AnyCast replication
- [EKS Network Load Balancer](modules/eks-nginx-controller) => Create a Network Load Balancer to allow public traffic
  to access the EKS cluster, using a pair of Elastic IPs. The Ingress used is a NGINX Controller
- [Elastic IPs](modules/elastic-ip) => Create a pair of Public IPs to connect an ECS or EKS cluster to external traffic

### Samples
- [ECS Cluster with a Web Server](samples/sample-ecs-cluster-with-nginx) => Create an ECS Cluster with an example of a
  NGINX proxy service to serve a Web
- [EKS Cluster with Application Load Balancer](samples/sample-eks-cluster-with-alb-and-ga) => Create an EKS Cluster
  with an Application Load Balancer and a Global Accelerator to create a Kubernetes cluster ready for production usage
- [EKS Cluster with Network Load Balancer](samples/sample-eks-cluster-with-alb-and-ga) => Create an EKS Cluster
  with a Network Load Balancer and a pair of Elastic IPs to create a Kubernetes cluster ready for production usage

## Resources

- https://github.com/AJarombek/global-aws-infrastructure/blob/master/eks/main.tf
- https://github.com/terraform-aws-modules/terraform-aws-eks/issues/1248
- https://medium.com/nerd-for-tech/deploy-aws-eks-cluster-with-oidc-provider-using-terraform-c4731ffe4038
- https://github.com/Young-ook/terraform-aws-eks/tree/1.4.16/modules/iam-role-for-serviceaccount
- https://aws.amazon.com/es/premiumsupport/knowledge-center/eks-alb-ingress-controller-setup/
- https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/examples/irsa/irsa.tf
- https://aws.amazon.com/es/blogs/opensource/kubernetes-ingress-aws-alb-ingress-controller/
- https://github.com/aws-samples/terraform-eks-code
- https://learnk8s.io/terraform-eks
- https://github.com/lablabs/terraform-aws-eks-alb-ingress/blob/0.5.0/examples/basic/main.tf
- https://learn.hashicorp.com/tutorials/terraform/eks
- https://github.com/kubernetes-sigs/aws-load-balancer-controller/blob/main/docs/examples/2048/2048_full_latest.yaml
- https://www.magalix.com/blog/deploying-kubernetes-cluster-with-eks
- https://github.com/kubernetes/ingress-nginx/tree/main/deploy/static/provider/aws
- https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.2/guide/service/annotations/
- https://www.hashicorp.com/blog/wait-conditions-in-the-kubernetes-provider-for-hashicorp-terraform
- https://github.com/uktrade/terraform-module-eks-base/blob/master/base/05-ingress-controller.tf
- https://aws.amazon.com/es/blogs/opensource/network-load-balancer-nginx-ingress-controller-eks/
- https://kind.sigs.k8s.io/docs/user/ingress/
- https://github.com/jet/kube-webhook-certgen
- https://blog.gruntwork.io/how-to-manage-terraform-state-28f5697e68fa
- https://www.terraform.io/docs/language/settings/backends/s3.html
- https://github.com/rhythmictech/terraform-aws-nlb-ecs-task/
- https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html
- https://engineering.finleap.com/posts/2020-02-20-ecs-fargate-terraform/
- https://aws.amazon.com/de/blogs/compute/task-networking-in-aws-fargate/
- https://github.com/finleap/tf-ecs-fargate-tmpl/blob/master/ecs/main.tf
- https://aws.amazon.com/es/blogs/developer/provision-aws-infrastructure-using-terraform-by-hashicorp-an-example-of-running-amazon-ecs-tasks-on-aws-fargate/
