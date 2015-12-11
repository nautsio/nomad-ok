resource "google_compute_instance" "server_instance" {
  count = "${var.cluster_size}"

  machine_type = "n1-standard-1"
  zone = "${var.region}"

  name = "consul-${count.index}"
  description = "Consul server node"
  tags = ["consul", "server"]

  scheduling {
    automatic_restart = true
    on_host_maintenance = "MIGRATE"
  }

  disk {
    image = "debian-8-jessie-v20151104"
  }

  disk {
    type = "local-ssd"
    scratch = true
  }

  network_interface {
    network = "default"
    access_config {}
  }
}

resource "google_dns_record_set" "external_dns" {
  count = 3

  managed_zone = "${var.external_dns_zone}"
  name = "${element(google_compute_instance.server_instance.*.name, count.index)}.${var.external_dns_name}"
  type = "A"
  ttl = 300
  rrdatas = ["${element(google_compute_instance.server_instance.*.network_interface.0.access_config.0.nat_ip, count.index)}"]
}

resource "google_dns_record_set" "internal_dns" {
  count = 3

  managed_zone = "${var.internal_dns_zone}"
  name = "${element(google_compute_instance.server_instance.*.name, count.index)}.${var.internal_dns_name}"
  type = "A"
  ttl = 300
  rrdatas = ["${element(google_compute_instance.server_instance.*.network_interface.0.address, count.index)}"]
}
