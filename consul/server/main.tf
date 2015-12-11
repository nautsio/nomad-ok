resource "google_compute_instance" "consul-server" {
  count = "${var.cluster_size}"

  machine_type = "n1-standard-1"
  zone = "${var.region}"

  name = "consul-server-${count.index}"
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

resource "google_dns_record_set" "consul-server-dns" {
  count = 3

  managed_zone = "${var.dns_zone}"
  name = "${element(google_compute_instance.consul-server.*.name, count.index)}.${var.dns_name}"
  type = "A"
  ttl = 300
  rrdatas = ["${element(google_compute_instance.consul-server.*.network_interface.0.access_config.0.nat_ip, count.index)}"]
}
