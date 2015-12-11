#
# Our credentials.
#
provider "google" {
  account_file = ""
  credentials = "${file(\"account.json\")}"
  project = "innovation-day-nomad"
  region = "europe-west1-b"
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
  cluster_size = "${var.nomad_server.cluster_size}"
}
