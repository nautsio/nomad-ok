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
    name = "external-zone"
    description = "External zone"
    dns_name = "cloud.nauts.io."
}

resource "google_dns_managed_zone" "internal" {
  name = "internal-zone"
  description = "Internal zone"
  dns_name = "internal.nauts.io."
}

module "nomad-client" {
  source = "./nomad/client"
  region = "${var.region}"
  min_cluster_size = "${var.nomad_client.min_cluster_size}"
  max_cluster_size = "${var.nomad_client.max_cluster_size}"
}

module "nomad-server" {
  source = "./nomad/server"
  region = "${var.region}"
  external_dns_zone = "${google_dns_managed_zone.external.name}"
  external_dns_name = "${google_dns_managed_zone.external.dns_name}"
  internal_dns_zone = "${google_dns_managed_zone.internal.name}"
  internal_dns_name = "${google_dns_managed_zone.internal.dns_name}"
  cluster_size = "${var.nomad_server.cluster_size}"
}

module "consul-server" {
  source = "./consul/server"
  region = "${var.region}"
  external_dns_zone = "${google_dns_managed_zone.external.name}"
  external_dns_name = "${google_dns_managed_zone.external.dns_name}"
  internal_dns_zone = "${google_dns_managed_zone.internal.name}"
  internal_dns_name = "${google_dns_managed_zone.internal.dns_name}"
  cluster_size = "${var.consul_server.cluster_size}"
}
