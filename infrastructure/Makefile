.PHONY: init plan apply destroy
LLM_ENV=dev-01
init:
	terraform init
	terraform workspace select -or-create ${LLM_ENV}

plan: init
	terraform plan -var-file=workspace_vars/${LLM_ENV}.tfvars

apply: init
	terraform apply -auto-approve -var-file=workspace_vars/${LLM_ENV}.tfvars

destroy: init
	terraform destroy -var-file=workspace_vars/${LLM_ENV}.tfvars