# EKS Ingress

## Introduction

Create the Load Balancer (Ingress) for EKS Cluster in AWS using Terraform

## Prerequisites

- Non-root AWS user with enough credentials
- [EKS Cluster](../eks-cluster) up and working
- You should have a set of Elastic IPs first (you can do it following [Elastic IP](../elastic-ip) instructions). Then
use the name used to set the Terraform variable `ELASTIC_IP_NAME`.

## Getting Started

### Set Terraform variables

Copy the file `terraform.tfvars.sample` into a new file named `terraform.tfvars` and set
the following variables:

- `EKS_CLUSTER_NAME` => Name of the EKS cluster
- `ELASTIC_IP_NAME` => Name used in Elastic IPs to use them
- `INGRESS_BACKEND_SERVICE_NAME` => Name of the default backend service where the Load Balancer will
  point to listen
- `INGRESS_BACKEND_SERVICE_PORT` => Port of the default backend service where the Load Balancer will
  point to listen
  
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

## Cleanup

If you want to delete the Ingress, Certificates and GA endpoints, you can do it using
Terraform too. Just type the following command:

```
terraform destroy
```

You will be prompted to confirm the delete operations. Take in mind that this will remove the ingress
and the certificates, so you should be sure to do it before you type `yes`.
