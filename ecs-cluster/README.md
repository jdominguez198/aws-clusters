# ECS Cluster

## Introduction

Create a ECS cluster in AWS using Terraform

## Prerequisites

- Non-root AWS user with enough credentials

## Getting Started

### Set Terraform variables

Copy the file `terraform.tfvars.sample` into a new file named `terraform.tfvars` and set
the following variables:

- `ELASTIC_IP_NAME` => Name of the EIPs created
- `PREFIX` => Prefix for naming usages

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

If you want to delete the ECS Cluster, you can do it using Terraform too. Just type the following command:

```
terraform destroy
```

You will be prompted to confirm the delete operations. Take in mind that this will remove all the cluster and service
on it, so you should be sure to do it before you type `yes`.
