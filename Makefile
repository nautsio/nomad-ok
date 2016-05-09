SHELL=/bin/bash

include defaults.mk

DOMAIN=$(STACK).$(TLD)
ifeq ($(strip $(STACK)),)
	STACK:=$(shell cat generated-stack-id 2> /dev/null || (uuidgen | cut -d- -f1 | tee generated-stack-id))
endif

STACK_DIR=stacks/$(STACK)
STATE_FILE=$(STACK_DIR)/terraform.tfstate
TF_DIR=.
TF_FLAGS=-state $(STATE_FILE) -var 'stack=$(STACK)' -var "ssh_key=$$(cat $(STACK_DIR)/ssh-key.pub)"
ifneq ($(strip $(PROJECT)),)
	TF_FLAGS+=-var 'project=$(PROJECT)'
endif

ifeq ($(STACK),common)
	TF_FLAGS+=-target=module.network
else
	TF_FLAGS+=-target=module.nomad_server -target=module.nomad_client
endif

TF_FLAGS+=$(TF_DIR)

.PHONY: stack-dir get ssh-key plan apply show refresh destroy list list-all copy-jobs check ssh mail

flags:
	echo $(TF_FLAGS)

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
	echo yes | terraform destroy $(TF_FLAGS)

list:
	 @gcloud compute --project "$(PROJECT)" instances list | egrep "^$(STACK)-" | sort

list-all:
	 @gcloud compute --project "$(PROJECT)" instances list

# suffix with domain if hostname, not IP address
HOSTFQDN=$(shell sed 's/\(^[^.]*$$\)/\1.$(DOMAIN)/' <<< $(HOST))

copy-jobs:
	scp -r -i stacks/$(STACK)/ssh-key jobs/ user@$(HOSTFQDN):

ssh:
	ssh -i stacks/$(STACK)/ssh-key user@$(HOSTFQDN) || true

check:
	NOMAD_ADDR=http://$(HOSTFQDN):4646 nomad node-status -allocs

stacks/$(STACK)/mail.msg: mail.sh
	./mail.sh $(STACK) $(FROM) $(TO) $(PROJECT) $(DOMAIN) > $@

mail: stacks/$(STACK)/mail.msg
	esmtp -v -i -X mail.log -f $(FROM) $(TO) < $<
