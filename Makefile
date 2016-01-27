SHELL=/bin/bash

STACK:=$(shell cat default-stack-id 2> /dev/null || (uuidgen | cut -d- -f1 | tee default-stack-id))
STACK_DIR=stacks/$(STACK)
STATE_FILE=$(STACK_DIR)/terraform.tfstate
TF_DIR=.
TF_FLAGS=-state $(STATE_FILE) -var 'stack=$(STACK)' -var "ssh_key=$$(cat $(STACK_DIR)/ssh-key.pub)" $(TF_DIR)

HOST:=nomad-01
FROM:=bbakker@xebia.com
DOMAIN=$(STACK).gce.nauts.io

.PHONY: stack-dir ssh-key plan apply show refresh destroy list list-all copy-jobs ssh mail

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

list:
	 @gcloud compute --project "innovation-day-nomad" instances list | egrep "^$(STACK)-" | sort

list-all:
	 @gcloud compute --project "innovation-day-nomad" instances list

# suffix with domain if hostname, not IP address
HOSTFQDN=$(shell sed 's/\(^[^.]*$$\)/\1.$(DOMAIN)/' <<< $(HOST))

copy-jobs:
	scp -r -i stacks/$(STACK)/ssh-key jobs/ user@$(HOSTFQDN):

ssh:
	ssh -i stacks/$(STACK)/ssh-key user@$(HOSTFQDN) || true

stacks/$(STACK)/mail.msg: mail.sh
	./mail.sh $(STACK) $(FROM) $(TO) > $@

mail: stacks/$(STACK)/mail.msg
	esmtp -v -i -X mail.log -f $(FROM) $(TO) < $<
