AWS_ACCOUNT_ID ?= $(shell bash -c 'read -p "AWS Account ID: " aws_account_id; echo $$aws_account_id')
ZONE ?= $(shell bash -c 'read -p "Region zone ID [eu-west-1]: " region_zone; [[ ! -z "$$region_zone" ]] && echo $$region_zone || echo "eu-west-1"')
GA_NAME ?= $(shell bash -c 'read -p "Global Accelerator name [k8s-aws-ga-ip]: " ga_name; [[ ! -z "$$ga_name" ]] && echo $$ga_name || echo "k8s-aws-ga-ip"')
EKS_CLUSTER_NAME ?= $(shell bash -c 'read -p "Cluster name [k8s_aws]: " cluster_name; [[ ! -z "$$cluster_name" ]] && echo $$cluster_name || echo "k8s_aws"')
INGRESS_BACKEND_SERVICE_NAME ?= $(shell bash -c 'read -p "Ingress Backend Service name [nginx]: " ingress_service_name; [[ ! -z "$$ingress_service_name" ]] && echo $$ingress_service_name || echo "nginx"')
INGRESS_BACKEND_SERVICE_PORT ?= $(shell bash -c 'read -p "Ingress Backend Service port [80]: " ingress_service_port; [[ ! -z "$$ingress_service_port" ]] && echo $$ingress_service_port || echo "80"')

MAKE_ENV += AWS_ACCOUNT_ID ZONE GA_NAME EKS_CLUSTER_NAME INGRESS_BACKEND_SERVICE_NAME INGRESS_BACKEND_SERVICE_PORT
SHELL_EXPORT := $(foreach v,$(MAKE_ENV),$(v)='$($(v))' )

eks-cluster/terraform.tfvars:
	@echo
	@echo Generating eks-cluster/terraform.tfvars file...
	@echo
	@$(SHELL_EXPORT) envsubst < eks-cluster/terraform.tfvars.template > eks-cluster/terraform.tfvars

eks-ingress/terraform.tfvars:
	@echo
	@echo Generating eks-ingress/terraform.tfvars file...
	@echo
	@$(SHELL_EXPORT) envsubst < eks-ingress/terraform.tfvars.template > eks-ingress/terraform.tfvars

global-accelerator/terraform.tfvars:
	@echo
	@echo Generating global-accelerator/terraform.tfvars file...
	@echo
	@$(SHELL_EXPORT) envsubst < global-accelerator/terraform.tfvars.template > global-accelerator/terraform.tfvars

initialize: eks-cluster/terraform.tfvars eks-ingress/terraform.tfvars global-accelerator/terraform.tfvars
