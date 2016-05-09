#
# The Nomad server nodes.
#
resource "template_file" "startup_script_template" {
  template = "${file(\"nomad/server/startup_script.sh.tpl\")}"
  vars {
    stack = "${var.stack}"
    loggly_token = "${var.loggly_token}"
  }
}

resource "google_compute_instance" "server_instance" {
  count = "${var.cluster_size}"

  machine_type = "${var.machine_type}"
  zone = "${element(split(",", var.zones), count.index)}"

  name = "${format("%s-nomad-%02d", var.stack, count.index + 1)}"
  description = "Nomad server node"
  tags = ["nomad", "server"]

  scheduling {
    automatic_restart = true
    on_host_maintenance = "MIGRATE"
  }

  disk {
    type = "pd-standard"
    image = "${var.disk_image}"
  }

  network_interface {
    network = "${var.network}"
    access_config {}
  }

  metadata = {
    ssh-keys = "user:${var.ssh_key}"
  }

  metadata_startup_script = "${template_file.startup_script_template.rendered}"
}

#
# The external DNS records for the Nomad servers.
#

resource "google_dns_record_set" "external_dns" {
  count = "${var.cluster_size * var.register_hostnames}"

  managed_zone = "${var.external_dns_zone}"
  name = "${format("%s-%s.%s", element(split("-", element(google_compute_instance.server_instance.*.name, count.index)), 1), element(split("-", element(google_compute_instance.server_instance.*.name, count.index)), 2), var.external_dns_name)}"
  type = "A"
  ttl = 300
  rrdatas = ["${element(google_compute_instance.server_instance.*.network_interface.0.access_config.0.assigned_nat_ip, count.index)}"]
}
