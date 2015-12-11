#
# Auto scaling group consisting of Nomad client nodes.
#
resource "google_compute_autoscaler" "nomad-client-scaler" {
    name = "nomad-client-scaler"
    zone = "${var.region}"
    target = "${google_compute_instance_group_manager.nomad-client-group.self_link}"
    autoscaling_policy = {
        min_replicas = "${var.min_cluster_size}"
        max_replicas = "${var.max_cluster_size}"
        cooldown_period = 60
        cpu_utilization = {
            target = 0.75
        }
    }
}

resource "google_compute_instance_group_manager" "nomad-client-group" {
  description = "Group consisting of Nomad client nodes"
  name = "nomad-client-group"
  instance_template = "${google_compute_instance_template.nomad-client.self_link}"
  base_instance_name = "nomad-client"
  zone = "${var.region}"
}

resource "google_compute_instance_template" "nomad-client" {
  name = "nomad-client"
  description = "Template for Nomad client nodes"
  instance_description = "Nomad client node"
  machine_type = "n1-standard-1"
  tags = ["nomad", "client"]

  scheduling {
    automatic_restart = true
    on_host_maintenance = "MIGRATE"
  }

  disk {
    source_image = "debian-8-jessie-v20151104"
    auto_delete = true
    boot = true
  }

  network_interface {
    network = "default"
    access_config {}
  }
}
