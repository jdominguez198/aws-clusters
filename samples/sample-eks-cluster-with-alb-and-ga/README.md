# ECS Cluster for ClubCuvée Project

## Introduction

Create an ECS cluster with a pair of Public IPs in AWS using Terraform

## Prerequisites

- Non-root AWS user with enough credentials
- kubectl

## Getting Started

### Add SSL certificates

Add SSL certificates under `certificates` folder. You should use the following files:
- `ssl_key`
- `ssl_body`
- `ssl_chain`

### Initialize Terraform

You should initialize Terraform on this folder to download all requirements for the library. You should type
in your terminal:

```
terraform init
```

### Check what you're going to create

Before you create all the resources required, you can check what Terraform will create, using:

```
terraform plan
```

The command will show you a summary of the resources to be created.

### Create the resources

Now that you what is going to be created, you should perform the operations. Now, type this command:

```
terraform apply
```

It will ask you to confirm to perform all the operations. Type `yes` when you're ready.

### Deploy the NGINX proxy as Web Server

Once the EKS cluster is ready, you can create any Kubernetes resources on it. For this sample, we will create a Web
Server using a NGINX proxy.

First, you must expose the `kubeconfig` configuration for your `kubectl` usage, with the following command:

```
aws eks --region eu-west-1 update-kubeconfig --name eks_alb_sample
```

Now, use the following commands to give Kubernetes the instructions to define a Deployment and a Service for the Web Server:

```
kubectl apply -f manifests/nginx-deployment.yaml
kubectl apply -f manifests/nginx-service.yaml
```

## Cleanup

If you want to delete the whole ECS Cluster and Public IPs, you can do it using Terraform too. Just type the
following command:

```
terraform destroy
```

You will be prompted to confirm the delete operations. Take in mind that this will remove all the cluster and services
on it, so you should be sure to do it before you type `yes`.
