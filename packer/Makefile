include ../defaults.mk

default: image

build.log: nomad-ok.json $(shell find files scripts)
	packer -machine-readable build -debug -var 'project_id=$(PROJECT)' $< | tee $@

image: build.log
	@grep -oP 'googlecompute,artifact,0,id,\K\S+' $< | tee image
	@echo -e "variable \"disk_image\" {\n  default = \"$$(cat image)\"\n}" > ../disk_image.tf

list-images:
	@gcloud compute images list --project "$(PROJECT)" --no-standard-images --regexp '^nomad-ok-.*'

list-base-images:
	@gcloud compute images list --project "$(PROJECT)" --regexp '^debian-8.*'
