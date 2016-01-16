STACK=eveld
STACK_DIR=stacks/$(STACK)
STATE_FILE=$(STACK_DIR)/terraform.tfstate
TF_DIR=.
TF_FLAGS=-state $(STATE_FILE) -var 'stack=$(STACK)' -var "ssh_key=$$(cat $(STACK_DIR)/ssh-key.pub)" $(TF_DIR)

.PHONY: stack-dir ssh-key plan apply show refresh destroy

stack-dir: $(STACK_DIR)

$(STACK_DIR):
	install -d $@

ssh-key: $(STACK_DIR)/ssh-key

$(STACK_DIR)/ssh-key:
	ssh-keygen -t rsa -f $@ -N '' -C user@$(STACK)

get:
	terraform get

plan: stack-dir ssh-key
	terraform plan -module-depth=-1 $(TF_FLAGS)

apply: stack-dir ssh-key
	terraform apply $(TF_FLAGS)

show: stack-dir
	terraform show $(TF_FLAGS)

refresh: stack-dir
	terraform refresh $(TF_FLAGS)

destroy: stack-dir
	terraform destroy $(TF_FLAGS)
