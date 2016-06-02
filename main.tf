#
# Create a network for the stack.
#
module "network" {
  source = "./network"

  name = "${var.network_name}"
}

#
# Create a farm of Nomad client nodes.
#
module "nomad_client" {
  source = "./nomad/client"

  stack = "${var.stack}"
  ssh_key = "${var.ssh_key}"
  loggly_token= "${var.loggly_token}"

  zones = "${var.nomad_client.zones}"
  groups = "${var.nomad_client.groups}"
  min_cluster_size = "${var.nomad_client.min_cluster_size}"
  max_cluster_size = "${var.nomad_client.max_cluster_size}"
  machine_type = "${var.nomad_client.machine_type}"
  preemptible_instance = "${var.nomad_client.preemptible_instance}"
  disk_image = "${var.disk_image}"
  network = "${var.network_name}"
}

#
# Create a cluster of Nomad server nodes.
#
module "nomad_server" {
  source = "./nomad/server"

  stack = "${var.stack}"
  ssh_key = "${var.ssh_key}"
  loggly_token= "${var.loggly_token}"

  register_hostnames = "1"
  external_dns_zone = "${var.external_domain.zone}"
  external_dns_name = "${format("%s.%s", var.stack, var.external_domain.domain)}"

  zones = "${var.zones}"
  cluster_size = "${var.nomad_server.cluster_size}"
  machine_type = "${var.nomad_server.machine_type}"
  disk_image = "${var.disk_image}"
  network = "${var.network_name}"
}

#
# Create a cluster of Vault server nodes.
#
module "vault_server" {
  source = "./vault/server"

  stack = "${var.stack}"
  ssh_key = "${var.ssh_key}"
  loggly_token= "${var.loggly_token}"

  register_hostnames = "1"
  external_dns_zone = "${var.external_domain.zone}"
  external_dns_name = "${format("%s.%s", var.stack, var.external_domain.domain)}"

  zones = "${var.zones}"
  cluster_size = "${var.vault_server.cluster_size}"
  machine_type = "${var.vault_server.machine_type}"
  disk_image = "${var.disk_image}"
  network = "${var.network_name}"
}
