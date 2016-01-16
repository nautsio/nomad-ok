INSTANCE=default
INSTANCE_DIR=instances/$(INSTANCE)
STATE_FILE=$(INSTANCE_DIR)/terraform.tfstate
TF_DIR=.
TF_FLAGS=-state $(STATE_FILE) -var 'instance=$(INSTANCE)' -var "ssh_key=$$(cat $(INSTANCE_DIR)/ssh-key.pub)" $(TF_DIR)

instance-dir: $(INSTANCE_DIR)

$(INSTANCE_DIR):
	install -d $@

ssh-key: $(INSTANCE_DIR)/ssh-key

$(INSTANCE_DIR)/ssh-key:
	ssh-keygen -t rsa -f $@ -N '' -C user@$(INSTANCE)

plan: instance-dir ssh-key
	terraform plan -module-depth=-1 $(TF_FLAGS)

apply: instance-dir ssh-key
	terraform apply $(TF_FLAGS)

show: instance-dir
	terraform show $(TF_FLAGS)

refresh: instance-dir
	terraform refresh $(TF_FLAGS)

destroy: instance-dir
	terraform destroy $(TF_FLAGS)
