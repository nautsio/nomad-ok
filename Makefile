INSTANCE=default
INSTANCE_DIR=instances/$(INSTANCE)
STATE_FILE=$(INSTANCE_DIR)/terraform.tfstate
TF_DIR=.
TF_FLAGS=-state $(STATE_FILE) -var 'instance=$(INSTANCE)' $(TF_DIR)

instance-dir: $(INSTANCE_DIR)

$(INSTANCE_DIR):
	install -d $@

plan: instance-dir
	terraform plan -module-depth=-1 $(TF_FLAGS)

apply: instance-dir
	terraform apply $(TF_FLAGS)

show: instance-dir
	terraform show $(TF_FLAGS)

destroy: instance-dir
	terraform destroy $(TF_FLAGS)
