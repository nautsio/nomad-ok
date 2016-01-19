resource "google_compute_network" "network" {
  name = "${var.name}"
  ipv4_range = "${var.range}"
}

resource "google_compute_firewall" "allow-from-everywhere" {
    name = "${var.name}-allow-from-everywhere"
    network = "${google_compute_network.network.name}"

    allow {
        protocol = "icmp"
    }

    allow {
        protocol = "tcp"
        ports = ["22", "4646", "8500"]
    }

    allow {
        protocol = "udp"
        ports = ["8500"]
    }

    source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow-all-internal" {
    name = "${var.name}-allow-from-all"
    network = "${google_compute_network.network.name}"

    allow {
        protocol = "icmp"
    }

    allow {
        protocol = "tcp"
        ports = ["0-65535"]
    }

    allow {
        protocol = "udp"
        ports = ["0-65535"]
    }

    source_ranges = ["${var.range}"]
}
