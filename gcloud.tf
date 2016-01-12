#
# Our credentials.
#
provider "google" {
  account_file = ""
  credentials = "${file(\"account.json\")}"
  project = "${var.project}"
  region = "${var.region}"
}

resource "google_dns_managed_zone" "external" {
    name = "nomad-ok-external-zone"
    description = "Nomad OK External zone"
    dns_name = "cloud.nauts.io."
}

resource "google_dns_managed_zone" "internal" {
  name = "nomad-ok-internal-zone"
  description = "Nomad OK Internal zone"
  dns_name = "int.nauts.io."
}

module "nomad-client" {
  source = "./nomad/client"
  zones = "${var.zones}"
  groups = "${var.nomad_client.groups}"
  min_cluster_size = "${var.nomad_client.min_cluster_size}"
  max_cluster_size = "${var.nomad_client.max_cluster_size}"
  disk_image = "${var.disk_image}"
  machine_type = "${var.nomad_client.machine_type}"
}

module "nomad-server" {
  source = "./nomad/server"
  zones = "${var.zones}"
  external_dns_zone = "${google_dns_managed_zone.external.name}"
  external_dns_name = "${google_dns_managed_zone.external.dns_name}"
  internal_dns_zone = "${google_dns_managed_zone.internal.name}"
  internal_dns_name = "${google_dns_managed_zone.internal.dns_name}"
  cluster_size = "${var.nomad_server.cluster_size}"
  disk_image = "${var.disk_image}"
  machine_type = "${var.nomad_server.machine_type}"
}

#module "consul-server" {
#  source = "./consul/server"
#  region = "${var.region}"
#  external_dns_zone = "${google_dns_managed_zone.external.name}"
#  external_dns_name = "${google_dns_managed_zone.external.dns_name}"
#  internal_dns_zone = "${google_dns_managed_zone.internal.name}"
#  internal_dns_name = "${google_dns_managed_zone.internal.dns_name}"
#  cluster_size = "${var.consul_server.cluster_size}"
#  disk_image = "${var.disk_image}"
#}
