#
# Auto scaling group consisting of Nomad client nodes.
#
resource "google_compute_autoscaler" "nomad-client-scaler" {
  count = "${var.groups}"
  name = "${var.stack}-nomad-client-scaler-${count.index}"
  zone = "${element(split(",", var.zones), count.index)}"

  target = "${element(google_compute_instance_group_manager.nomad-client-group.*.self_link, count.index)}"
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
resource "google_compute_instance_group_manager" "nomad-client-group" {
  count = "${var.groups}"
  name = "${var.stack}-nomad-client-group-${count.index}"
  zone = "${element(split(",", var.zones), count.index)}"

  description = "Group consisting of Nomad client nodes"
  instance_template = "${google_compute_instance_template.nomad-client.self_link}"
  base_instance_name = "${var.stack}-farm-${count.index}"
}

resource "template_file" "startup_script_template" {
  template = "${file(\"nomad/client/startup_script.sh.tpl\")}"
  vars {
    prefix = "${var.stack}-"
    ssh_key = "${var.ssh_key}"
  }
}

#
# A template that is used to create the Nomad client nodes.
#
resource "google_compute_instance_template" "nomad-client" {
  name = "${var.stack}-nomad-client"
  description = "Template for Nomad client nodes"
  instance_description = "Nomad client node"
  machine_type = "${var.machine_type}"
  tags = ["nomad", "client"]

  scheduling {
    automatic_restart = true
    on_host_maintenance = "MIGRATE"
  }

  disk {
    source_image = "${var.disk_image}"
    auto_delete = true
    boot = true
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata {
    startup-script = "${template_file.startup_script_template.rendered}"
  }
}
