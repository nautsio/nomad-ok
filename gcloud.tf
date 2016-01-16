module "nomad-client" {
  source = "./nomad/client"
  zones = "${var.zones}"
  groups = "${var.nomad_client.groups}"
  min_cluster_size = "${var.nomad_client.min_cluster_size}"
  max_cluster_size = "${var.nomad_client.max_cluster_size}"
  disk_image = "${var.disk_image}"
  machine_type = "${var.nomad_client.machine_type}"
  instance = "${var.instance}"
  ssh_key = "${var.ssh_key}"
}

module "nomad-server" {
  source = "./nomad/server"
  zones = "${var.zones}"
  external_dns_zone = "nomad-ok-external-zone"
  external_dns_name = "cloud.nauts.io."
  internal_dns_zone = "nomad-ok-internal-zone"
  internal_dns_name = "int.nauts.io."
  cluster_size = "${var.nomad_server.cluster_size}"
  disk_image = "${var.disk_image}"
  machine_type = "${var.nomad_server.machine_type}"
  instance = "${var.instance}"
  ssh_key = "${var.ssh_key}"
}
