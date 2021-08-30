ZONE ?= $(shell bash -c 'read -p "Region zone ID [eu-west-1]: " region_zone; [[ ! -z "$$region_zone" ]] && echo $$region_zone || echo "eu-west-1"')
EKS_CLUSTER_NAME ?= $(shell bash -c 'read -p "Cluster name [k8s_aws]: " cluster_name; [[ ! -z "$$cluster_name" ]] && echo $$cluster_name || echo "k8s_aws"')
PREFIX ?= $(shell bash -c 'read -p "Prefix for some resource identifiers [prefix]: " prefix; [[ ! -z "$$prefix" ]] && echo $$prefix || echo "prefix"')
INGRESS_BACKEND_SERVICE_NAME ?= $(shell bash -c 'read -p "Ingress Backend Service name [nginx-example]: " ingress_service_name; [[ ! -z "$$ingress_service_name" ]] && echo $$ingress_service_name || echo "nginx-example"')
INGRESS_BACKEND_SERVICE_PORT ?= $(shell bash -c 'read -p "Ingress Backend Service port [80]: " ingress_service_port; [[ ! -z "$$ingress_service_port" ]] && echo $$ingress_service_port || echo "80"')
INGRESS_NAMESPACE ?= $(shell bash -c 'read -p "Ingress k8s namespace [ingress-nginx]: " ingress_namespace; [[ ! -z "$$ingress_namespace" ]] && echo $$ingress_namespace || echo "ingress-nginx"')
GA_NAME ?= $(shell bash -c 'read -p "Global Accelerator name [k8s_aws_gaip]: " ga_name; [[ ! -z "$$ga_name" ]] && echo $$ga_name || echo "k8s_aws_gaip"')
ELASTIC_IP_NAME ?= $(shell bash -c 'read -p "Elastic IP name [k8s_aws_eip]: " elastic_ip_name; [[ ! -z "$$elastic_ip_name" ]] && echo $$elastic_ip_name || echo "k8s_aws_eip"')
STATE_BUCKET_PREFIX ?= $(shell bash -c 'read -p "Terraform State prefix [prefix]: " terraform_state_prefix; [[ ! -z "$$terraform_state_prefix" ]] && echo $$terraform_state_prefix || echo "prefix"')

.PHONY: \
	prompt_vars \
	initialize_vars \
	initialize_state \
	initialize \
	clean_vars \
	clean_state \
	clean

prompt_vars:
	$(eval MAKE_ENV += \
		STATE_BUCKET_PREFIX \
		EKS_CLUSTER_NAME \
		PREFIX \
		ZONE \
		INGRESS_BACKEND_SERVICE_NAME \
		INGRESS_BACKEND_SERVICE_PORT \
		INGRESS_NAMESPACE \
		GA_NAME \
		ELASTIC_IP_NAME)
	$(eval SHELL_EXPORT := $(foreach v,$(MAKE_ENV),$(v)='$($(v))' ))

eks-cluster/terraform.tfvars: prompt_vars
	@echo
	@echo Generating eks-cluster/terraform.tfvars file...
	@echo
	@$(SHELL_EXPORT) envsubst < eks-cluster/terraform.tfvars.template > eks-cluster/terraform.tfvars

eks-cluster/terraform.tfstate.tf: prompt_vars
	@echo
	@echo Generating eks-cluster/terraform.tfstate.tf file...
	@echo
	@$(SHELL_EXPORT) TF_SERVICE="eks-cluster" \
		envsubst < shared/terraform-tfstate.tf.template > eks-cluster/terraform.tfstate.tf

eks-alb-controller/terraform.tfvars: prompt_vars
	@echo
	@echo Generating eks-alb-controller/terraform.tfvars file...
	@echo
	@$(SHELL_EXPORT) envsubst < eks-alb-controller/terraform.tfvars.template > eks-alb-controller/terraform.tfvars

eks-alb-controller/terraform.tfstate.tf: prompt_vars
	@echo
	@echo Generating eks-alb-controller/terraform.tfstate.tf file...
	@echo
	@$(SHELL_EXPORT) TF_SERVICE="eks-alb-controller" \
		envsubst < shared/terraform-tfstate.tf.template > eks-alb-controller/terraform.tfstate.tf

eks-nginx-controller/terraform.tfvars: prompt_vars
	@echo
	@echo Generating eks-nginx-controller/terraform.tfvars file...
	@echo
	@$(SHELL_EXPORT) envsubst < eks-nginx-controller/terraform.tfvars.template > eks-nginx-controller/terraform.tfvars

eks-nginx-controller/terraform.tfstate.tf: prompt_vars
	@echo
	@echo Generating eks-nginx-controller/terraform.tfstate.tf file...
	@echo
	@$(SHELL_EXPORT) TF_SERVICE="eks-nginx-controller" \
		envsubst < shared/terraform-tfstate.tf.template > eks-nginx-controller/terraform.tfstate.tf

elastic-ip/terraform.tfvars: prompt_vars
	@echo
	@echo Generating elastic-ip/terraform.tfvars file...
	@echo
	@$(SHELL_EXPORT) envsubst < elastic-ip/terraform.tfvars.template > elastic-ip/terraform.tfvars

elastic-ip/terraform.tfstate.tf: prompt_vars
	@echo
	@echo Generating elastic-ip/terraform.tfstate.tf file...
	@echo
	@$(SHELL_EXPORT) TF_SERVICE="elastic-ip" \
		envsubst < shared/terraform-tfstate.tf.template > elastic-ip/terraform.tfstate.tf

global-accelerator/terraform.tfvars: prompt_vars
	@echo
	@echo Generating global-accelerator/terraform.tfvars file...
	@echo
	@$(SHELL_EXPORT) envsubst < global-accelerator/terraform.tfvars.template > global-accelerator/terraform.tfvars

global-accelerator/terraform.tfstate.tf: prompt_vars
	@echo
	@echo Generating global-accelerator/terraform.tfstate.tf file...
	@echo
	@$(SHELL_EXPORT) TF_SERVICE="global-accelerator" \
		envsubst < shared/terraform-tfstate.tf.template > global-accelerator/terraform.tfstate.tf

s3-backend/terraform.tfvars: prompt_vars
	@echo
	@echo Generating s3-backend/terraform.tfvars file...
	@echo
	@$(SHELL_EXPORT) envsubst < s3-backend/terraform.tfvars.template > s3-backend/terraform.tfvars

initialize_state: \
	eks-cluster/terraform.tfstate.tf \
	eks-alb-controller/terraform.tfstate.tf \
	eks-nginx-controller/terraform.tfstate.tf \
	elastic-ip/terraform.tfstate.tf \
	global-accelerator/terraform.tfstate.tf
	@echo State files initialized!

initialize_vars: \
	s3-backend/terraform.tfvars \
	eks-cluster/terraform.tfvars \
	eks-alb-controller/terraform.tfvars \
	eks-nginx-controller/terraform.tfvars \
	global-accelerator/terraform.tfvars \
	elastic-ip/terraform.tfvars
	@echo Variable files initialized!

initialize: initialize_state initialize_vars
	@echo All files initialized!

clean_state:
	rm -rf \
		eks-alb-controller/terraform.tfstate.tf \
    	eks-cluster/terraform.tfstate.tf \
    	eks-nginx-controller/terraform.tfstate.tf \
    	global-accelerator/terraform.tfstate.tf \
    	elastic-ip/terraform.tfstate.tf
	@echo Clean state files done!

clean_vars:
	rm -rf \
		s3-backend/terraform.tfvars \
		eks-alb-controller/terraform.tfvars \
		eks-cluster/terraform.tfvars \
    	eks-nginx-controller/terraform.tfvars \
    	global-accelerator/terraform.tfvars \
    	elastic-ip/terraform.tfvars
	@echo Clean variable files done!

clean: clean_state clean_vars
	@echo Full cleanup done!
