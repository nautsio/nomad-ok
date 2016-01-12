#
# The Nomad server nodes.
#
resource "google_compute_instance" "server_instance" {
  count = "${var.cluster_size}"

  machine_type = "${var.machine_type}"
  zone = "${element(split(",", var.zones), count.index)}"

  name = "nomad-${count.index}"
  description = "Nomad server node"
  tags = ["nomad", "server"]

  scheduling {
    automatic_restart = true
    on_host_maintenance = "MIGRATE"
  }

  disk {
    image = "${var.disk_image}"
  }

  disk {
    type = "local-ssd"
    scratch = true
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata_startup_script = "${file(\"nomad/server/startup_script.sh\")}"
}

resource "google_compute_project_metadata" "project_metadata" {
  metadata {
    nomad_servers = "${join(",", google_compute_instance.server_instance.*.name)}"
  }
}

#
# The external DNS records for the Nomad servers.
#
resource "google_dns_record_set" "external_dns" {
  count = "${var.cluster_size}"

  managed_zone = "${var.external_dns_zone}"
  name = "${element(google_compute_instance.server_instance.*.name, count.index)}.${var.external_dns_name}"
  type = "A"
  ttl = 300
  rrdatas = ["${element(google_compute_instance.server_instance.*.network_interface.0.access_config.0.nat_ip, count.index)}"]
}

#
# The internal DNS records for the Nomad servers.
#
resource "google_dns_record_set" "internal_dns" {
  count = "${var.cluster_size}"

  managed_zone = "${var.internal_dns_zone}"
  name = "${element(google_compute_instance.server_instance.*.name, count.index)}.${element(google_compute_instance.server_instance.*.zone, count.index)}.${var.internal_dns_name}"
  type = "A"
  ttl = 300
  rrdatas = ["${element(google_compute_instance.server_instance.*.network_interface.0.address, count.index)}"]
}
