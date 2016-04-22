#
# Auto scaling group consisting of Nomad client nodes.
#
resource "google_compute_autoscaler" "nomad_client_scaler" {
  count = "${var.groups}"
  name = "${format("%s-nomad-client-scaler-%02d", var.stack, count.index + 1)}"
  zone = "${element(split(",", var.zones), count.index)}"

  target = "${element(google_compute_instance_group_manager.nomad_client_group.*.self_link, count.index)}"
  autoscaling_policy = {
    min_replicas = "${var.min_cluster_size}"
    max_replicas = "${var.max_cluster_size}"
    cooldown_period = 60
    cpu_utilization = {
      target = 0.75
    }
  }
}

#
# Instance group manager that manages the Nomad client nodes.
#
resource "google_compute_instance_group_manager" "nomad_client_group" {
  count = "${var.groups}"
  name = "${format("%s-nomad-client-group-%02d", var.stack, count.index + 1)}"
  zone = "${element(split(",", var.zones), count.index)}"

  description = "Group consisting of Nomad client nodes"
  instance_template = "${google_compute_instance_template.nomad_client.self_link}"
  base_instance_name = "${format("%s-farm-%02d", var.stack, count.index + 1)}"
}

resource "template_file" "startup_script_template" {
  template = "${file(\"nomad/client/startup_script.sh.tpl\")}"
  vars {
    stack = "${var.stack}"
    loggly_token= "${var.loggly_token}"
  }
}

#
# A template that is used to create the Nomad client nodes.
#
resource "google_compute_instance_template" "nomad_client" {
  name = "${format("%s-nomad-client", var.stack)}"
  description = "Template for Nomad client nodes"
  instance_description = "Nomad client node"
  machine_type = "${var.machine_type}"
  tags = ["nomad", "client"]

  scheduling {
    automatic_restart = false
#    on_host_maintenance = "MIGRATE"
    preemptible = "${var.preemptible_instance}"
  }

  disk {
    source_image = "${var.disk_image}"
    auto_delete = true
    boot = true
  }

  network_interface {
    network = "${var.network}"
    access_config {}
  }

  metadata {
    startup-script = "${template_file.startup_script_template.rendered}"
    ssh-keys = "user:${var.ssh_key}"
  }
}
