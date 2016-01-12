image: nomad-ok.json
	packer -machine-readable build $< | tee packer-build.out
	grep -oP 'googlecompute,artifact,0,id,\K\S+' packer-build.out | tee image
	perl -pi -e "s/nomad-ok-\d+/$(cat packer/image)/" variables.tf
