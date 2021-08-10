# Kubernetes Cluster in AWS

## Introduction

The goal of this repository is to understand how to use Terraform to create a cluster
with the following services:

- Cluster using EKS service
- Node groups with EC2 provisioning
- AutoScaler to manage horizontal escalation in Node groups
- Load Balancer using ALB
- TLS certificates for Load Balancer using ACM
- Global static IP for Load Balancer using Global Accelerator

## Prerequisites

- AWS account (obviously). Recommended to use non-root user for credentials
- AWS-CLI
- Terraform
- kubectl
- Accelerator created without listeners in Global Accelerator service
- TLS certificates (key, crt, and ca)

## Getting started

1. Follow the documentation in [eks-cluster](eks-cluster) folder to create the EKS Cluster with
the required policies, roles and resources to start using k8s
2. Follow the documentation in [eks-ingress](eks-ingress) folder to create the Load Balancer
with the TLS certificates and the Static IP assigned from Global Accelerator service

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
