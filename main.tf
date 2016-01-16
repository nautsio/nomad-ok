module "networks" {
  source = "./network"

  stack = "${var.stack}"
  range = "10.20.30.0/24"
}

module "external_dns" {
  source = "./dns"

  name = "external-zone"
  description = "External zone"
  domain = "gce.nauts.io."
}

module "internal_dns" {
  source = "./dns"

  name = "internal-zone"
  description = "Internal zone"
  domain = "int.nauts.io."
}

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
}

module "nomad_server" {
  source = "./nomad/server"

  stack = "${var.stack}"
  ssh_key = "${var.ssh_key}"

  external_dns_zone = "${module.external_dns.zone}"
  external_dns_name = "${module.external_dns.domain}"

  internal_dns_zone = "${module.internal_dns.zone}"
  internal_dns_name = "${module.internal_dns.domain}"

  zones = "${var.zones}"
  cluster_size = "${var.nomad_server.cluster_size}"
  machine_type = "${var.nomad_server.machine_type}"
  disk_image = "${var.disk_image}"
}
