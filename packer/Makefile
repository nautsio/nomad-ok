default: image

build.log: nomad-ok.json $(shell find files scripts)
	packer -machine-readable build $< | tee $@

image: build.log
	@grep -oP 'googlecompute,artifact,0,id,\K\S+' $< | tee image
	@echo -e "variable \"disk_image\" {\n  default = \"$$(cat image)\"\n}" > ../disk_image.tf
