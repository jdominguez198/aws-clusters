# Kubernetes Cluster in AWS

## Introduction

The goal of this repository is to understand how to use Terraform to create a cluster
with the following services:

- Cluster using EKS service
- Node groups with EC2 provisioning
- AutoScaler to manage horizontal escalation in Node groups
- Load Balancer using ALB or NLB
- TLS certificates for Load Balancer using ACM
- Global static IP for Application Load Balancer using Global Accelerator
- Elastic IPs as static IPs for Network Load Balancer

## Prerequisites

- AWS account (obviously). Recommended to use non-root user for credentials
- AWS-CLI
- Terraform
- kubectl
- TLS certificates (`ssl_key`, `ssl_body`, and `ssl_chain`)

## Getting started

1. Follow the documentation in [eks-cluster](eks-cluster) folder to create the EKS Cluster with
   the required policies, roles and resources to start using k8s
2. Now you can add a Load Balancer connected to the Cluster on two different ways:

   - Using a Network Load Balancer + Elastic IPs (x2) + SSL.
   
      This option is for sites with a low average connections or for
      sites with traffic focused on a unique region.

      Follow the instructions in [eks-nginx-controller](eks-nginx-controller) folder to create the Network Load Balancer
      using NGINX Controller and two already created Elastic IPs acting as Static IPs. If you don't have any Elastic IP
      created, you can create them using the instructions in [elastic-ip](elastic-ip) folder.
   - Using an Application Load Balancer + Global Accelerator + SSL.

      This option is for sites with a high average connections or for sites with traffic focused
      in different regions.
      
      Follow the instructions in [eks-alb-controller](eks-alb-controller) folder to create the Application Load Balancer
      using the native AWS controller with an Accelerator already created using Global Accelerator service, acting as
      Static IPs. If you don't have any Accelerator created, you can create it using the instructions in
      [global-accelerator](global-accelerator) folder.

NOTE: You can create all the `terraform.tfvars` (file with variables used for all operations) needed
by using `make initialize` in the root folder.

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
