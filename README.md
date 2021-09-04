# Kubernetes Cluster in AWS

## Table of contents
- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
  - [Create Cluster using EKS](#create-cluster-using-eks)
  - [(Extra) Create Cluster using ECS](#extra-create-cluster-using-ecs)
- [TO DO](#to-do)
- [Resources](#resources)

## Introduction

The goal of this repository is to understand how to use Terraform to create a cluster
with the following services:

- Cluster using EKS service
- Node groups with EC2 provisioning
- AutoScaler to manage horizontal escalation in Node groups
- Fargate profiles for specific namespaces and/or pods
- Load Balancer using ALB or NLB
- TLS certificates for Load Balancer using ACM
- Global static IP for Application Load Balancer using Global Accelerator
- Elastic IPs as static IPs for Network Load Balancer
- _EXTRA:_ Create an ECS Cluster with Elastic IPs and Network Load Balancer using FARGATE

## Prerequisites

- AWS account (obviously). Recommended to use non-root user for credentials
- AWS-CLI
- Terraform
- kubectl
- TLS certificates (`ssl_key`, `ssl_body`, and `ssl_chain`)

## Getting started

1. Run `make intitialize` to create all the `terraform.tfvars` files with the required variables
   to operate correctly with each AWS service
2. Follow the documentation in [s3-backend](s3-backend) folder to create a S3 Bucket to store the
   Terraform state

### Create Cluster using EKS

1. Follow the documentation in [eks-cluster](eks-cluster) folder to create the EKS Cluster with
   the required policies, roles and resources to start using k8s
2. Export `kubeconfig` files to operate with `kubectl` by typing in your terminal:

    ```bash
    aws eks --region <YOUR_REGION> update-kubeconfig --name <YOUR_EKS_CLUSTER_NAME>
    ```

3. Now you can add a Load Balancer connected to the Cluster and allow external traffic on two different ways:

   - Using a Network Load Balancer + Elastic IPs (x2) + SSL:
     - Get your Elastic IPs following the instructions in [elastic-ip](elastic-ip) folder.
     - Create the Network Load Balancer with NGINX Controller and SSL, following the instructions in
       [eks-nginx-controller](eks-nginx-controller) folder.
   - Using an Application Load Balancer + Global Accelerator + SSL:
     - Get your Accelerator following the instructions in [global-accelerator](global-accelerator) folder.
     - Create the Application Load Balancer with SSL, following the instructions in
       [eks-alb-controller](eks-alb-controller) folder.

### (Extra) Create Cluster using ECS

1. Get your Elastic IPs following the instructions in [elastic-ip](elastic-ip) folder.
2. Follow the documentation in [ecs-cluster](ecs-cluster) folder to create the ECS cluster with
   the required policies, roles and resources to start using your containers.
3. Now you'll have a cluster ready to use with `FARGATE` instances
     
## TO DO

- For `ecs-cluster`, include ACM and HTTPS listener
- Improve folders README to describe an overview
- Prepare each folder as private modules and include examples of its usage

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
