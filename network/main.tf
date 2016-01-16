resource "google_compute_network" "network" {
  name = "${var.name}"
  ipv4_range = "${var.range}"
}
