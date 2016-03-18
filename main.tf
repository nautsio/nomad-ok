#
# Create a network for the stack.
#
module "network" {
  source = "./network"

  name = "${var.stack}"
  range = "10.20.30.0/24"
}

#
# Create a farm of Nomad client nodes.
#
module "nomad_client_eu" {
  source = "./nomad/client"

  stack = "${var.stack}"
  ssh_key = "${var.ssh_key}"

  region = "eu"
  zones = "europe-west1-b,europe-west1-c,europe-west1-d"
  groups = "${var.nomad_client.groups}"
  min_cluster_size = "${var.nomad_client.min_cluster_size}"
  max_cluster_size = "${var.nomad_client.max_cluster_size}"
  machine_type = "${var.nomad_client.machine_type}"
  preemptible_instance = "${var.nomad_client.preemptible_instance}"
  disk_image = "${var.disk_image}"
  network = "${module.network.name}"
}

module "nomad_client_us" {
  source = "./nomad/client"

  stack = "${var.stack}"
  ssh_key = "${var.ssh_key}"

  region = "us"
  zones = "us-east1-b,us-east1-c,us-east1-d"
  groups = "${var.nomad_client.groups}"
  min_cluster_size = "${var.nomad_client.min_cluster_size}"
  max_cluster_size = "${var.nomad_client.max_cluster_size}"
  machine_type = "${var.nomad_client.machine_type}"
  preemptible_instance = "${var.nomad_client.preemptible_instance}"
  disk_image = "${var.disk_image}"
  network = "${module.network.name}"
}

#
# Create a cluster of Nomad server nodes.
#
module "nomad_server_eu" {
  source = "./nomad/server"

  stack = "${var.stack}"
  ssh_key = "${var.ssh_key}"

  external_dns_zone = "${var.external_domain.zone}"
  external_dns_name = "${format("%s.%s.%s", "eu", var.stack, var.external_domain.domain)}"

  region = "eu"
  zones = "europe-west1-b,europe-west1-c,europe-west1-d"
  cluster_size = "${var.nomad_server.cluster_size}"
  machine_type = "${var.nomad_server.machine_type}"
  disk_image = "${var.disk_image}"
  network = "${module.network.name}"
}

#
# Create a cluster of Nomad server nodes.
#
module "nomad_server_us" {
  source = "./nomad/server"

  stack = "${var.stack}"
  ssh_key = "${var.ssh_key}"

  external_dns_zone = "${var.external_domain.zone}"
  external_dns_name = "${format("%s.%s.%s", "us", var.stack, var.external_domain.domain)}"

  region = "us"
  zones = "us-east1-b,us-east1-c,us-east1-d"
  cluster_size = "${var.nomad_server.cluster_size}"
  machine_type = "${var.nomad_server.machine_type}"
  disk_image = "${var.disk_image}"
  network = "${module.network.name}"
}
