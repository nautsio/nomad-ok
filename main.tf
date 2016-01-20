#
# Create a network for the stack.
#
module "network" {
  source = "./network"

  name = "${var.stack}"
  range = "10.20.30.0/24"
}

#
# Create an internal DNS zone for the stack e.g. stack.local.
#
module "internal_dns" {
  source = "./dns"

  name = "${format("%s-internal-zone", var.stack)}"
  description = "Internal zone"
  domain = "${format("%s.%s", var.stack, var.internal_domain)}"
}

#
# Create a farm of Nomad client nodes.
#
module "nomad_client" {
  source = "./nomad/client"

  stack = "${var.stack}"
  ssh_key = "${var.ssh_key}"

  zones = "${var.zones}"
  groups = "${var.nomad_client.groups}"
  min_cluster_size = "${var.nomad_client.min_cluster_size}"
  max_cluster_size = "${var.nomad_client.max_cluster_size}"
  machine_type = "${var.nomad_client.machine_type}"
  disk_image = "${var.disk_image}"
  network = "${module.network.name}"
}

#
# Create a cluster of Nomad server nodes.
#
module "nomad_server" {
  source = "./nomad/server"

  stack = "${var.stack}"
  ssh_key = "${var.ssh_key}"

  external_dns_zone = "${var.external_domain.zone}"
  external_dns_name = "${format("%s.%s", var.stack, var.external_domain.domain)}"

  internal_dns_zone = "${module.internal_dns.zone}"
  internal_dns_name = "${module.internal_dns.domain}"

  zones = "${var.zones}"
  cluster_size = "${var.nomad_server.cluster_size}"
  machine_type = "${var.nomad_server.machine_type}"
  disk_image = "${var.disk_image}"
  network = "${module.network.name}"
}
