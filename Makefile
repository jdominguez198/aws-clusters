ZONE ?= $(shell bash -c 'read -p "Region zone ID [eu-west-1]: " region_zone; [[ ! -z "$$region_zone" ]] && echo $$region_zone || echo "eu-west-1"')
EKS_CLUSTER_NAME ?= $(shell bash -c 'read -p "Cluster name [k8s_aws]: " cluster_name; [[ ! -z "$$cluster_name" ]] && echo $$cluster_name || echo "k8s_aws"')
PREFIX ?= $(shell bash -c 'read -p "Prefix for some resource identifiers [prefix]: " prefix; [[ ! -z "$$prefix" ]] && echo $$prefix || echo "prefix"')
INGRESS_BACKEND_SERVICE_NAME ?= $(shell bash -c 'read -p "Ingress Backend Service name [nginx-example]: " ingress_service_name; [[ ! -z "$$ingress_service_name" ]] && echo $$ingress_service_name || echo "nginx-example"')
INGRESS_BACKEND_SERVICE_PORT ?= $(shell bash -c 'read -p "Ingress Backend Service port [80]: " ingress_service_port; [[ ! -z "$$ingress_service_port" ]] && echo $$ingress_service_port || echo "80"')
INGRESS_NAMESPACE ?= $(shell bash -c 'read -p "Ingress k8s namespace [ingress-nginx]: " ingress_namespace; [[ ! -z "$$ingress_namespace" ]] && echo $$ingress_namespace || echo "ingress-nginx"')
GA_NAME ?= $(shell bash -c 'read -p "Global Accelerator name [k8s_aws_gaip]: " ga_name; [[ ! -z "$$ga_name" ]] && echo $$ga_name || echo "k8s_aws_gaip"')
ELASTIC_IP_NAME ?= $(shell bash -c 'read -p "Elastic IP name [k8s_aws_eip]: " elastic_ip_name; [[ ! -z "$$elastic_ip_name" ]] && echo $$elastic_ip_name || echo "k8s_aws_eip"')

MAKE_ENV += \
	EKS_CLUSTER_NAME \
	PREFIX \
	ZONE \
	INGRESS_BACKEND_SERVICE_NAME \
	INGRESS_BACKEND_SERVICE_PORT \
	INGRESS_NAMESPACE \
	GA_NAME \
	ELASTIC_IP_NAME
SHELL_EXPORT := $(foreach v,$(MAKE_ENV),$(v)='$($(v))' )

eks-cluster/terraform.tfvars:
	@echo
	@echo Generating eks-cluster/terraform.tfvars file...
	@echo
	@$(SHELL_EXPORT) envsubst < eks-cluster/terraform.tfvars.template > eks-cluster/terraform.tfvars

eks-alb-controller/terraform.tfvars:
	@echo
	@echo Generating eks-alb-controller/terraform.tfvars file...
	@echo
	@$(SHELL_EXPORT) envsubst < eks-alb-controller/terraform.tfvars.template > eks-alb-controller/terraform.tfvars

eks-nginx-controller/terraform.tfvars:
	@echo
	@echo Generating eks-nginx-controller/terraform.tfvars file...
	@echo
	@$(SHELL_EXPORT) envsubst < eks-nginx-controller/terraform.tfvars.template > eks-nginx-controller/terraform.tfvars

elastic-ip/terraform.tfvars:
	@echo
	@echo Generating elastic-ip/terraform.tfvars file...
	@echo
	@$(SHELL_EXPORT) envsubst < elastic-ip/terraform.tfvars.template > elastic-ip/terraform.tfvars

global-accelerator/terraform.tfvars:
	@echo
	@echo Generating global-accelerator/terraform.tfvars file...
	@echo
	@$(SHELL_EXPORT) envsubst < global-accelerator/terraform.tfvars.template > global-accelerator/terraform.tfvars

initialize: \
	eks-cluster/terraform.tfvars \
	eks-alb-controller/terraform.tfvars \
	eks-nginx-controller/terraform.tfvars \
	global-accelerator/terraform.tfvars \
	elastic-ip/terraform.tfvars
