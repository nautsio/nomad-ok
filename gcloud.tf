#
# Our credentials.
#
provider "google" {
  account_file = ""
  credentials = "${file(\"account.json\")}"
  project = "innovation-day-nomad"
  region = "europe-west1-b"
}

resource "google_dns_managed_zone" "xebia" {
    name = "xebia-zone"
    description = "Main zone"
    dns_name = "xebia.com."
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
  dns_zone = "${google_dns_managed_zone.xebia.name}"
  dns_name = "${google_dns_managed_zone.xebia.dns_name}"
  cluster_size = "${var.nomad_server.cluster_size}"
}

module "consul-server" {
  source = "./consul/server"
  region = "${var.region}"
  dns_zone = "${google_dns_managed_zone.xebia.name}"
  dns_name = "${google_dns_managed_zone.xebia.dns_name}"
  cluster_size = "${var.consul_server.cluster_size}"
}
