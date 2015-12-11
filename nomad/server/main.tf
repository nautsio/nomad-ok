resource "google_compute_instance" "nomad-server" {
  count = "${var.cluster_size}"

  machine_type = "n1-standard-1"
  zone = "${var.region}"

  name = "nomad-server-${count.index}"
  description = "Nomad server node"
  tags = ["nomad", "server"]

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

resource "google_dns_managed_zone" "xebia" {
    name = "xebia-zone"
    description = "Main zone"
    dns_name = "xebia.com."
}

resource "google_dns_record_set" "nomad-server-dns" {
  count = 3

  managed_zone = "${google_dns_managed_zone.xebia.name}"
  name = "${element(google_compute_instance.nomad-server.*.name, count.index)}.${google_dns_managed_zone.xebia.dns_name}"
  type = "A"
  ttl = 300
  rrdatas = ["${element(google_compute_instance.nomad-server.*.network_interface.0.access_config.0.nat_ip, count.index)}"]
}
