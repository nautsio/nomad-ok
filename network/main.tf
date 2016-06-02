resource "google_compute_network" "network" {
  name = "${var.name}"
  auto_create_subnetworks = true
}

resource "google_compute_firewall" "allow-from-everywhere" {
    name = "${var.name}-allow-from-everywhere"
    network = "${google_compute_network.network.name}"

    allow {
        protocol = "icmp"
    }

    allow {
        protocol = "tcp"
        ports = ["22", "4646", "8200", "8500"]
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

    # TODO: don't hard code IP range defined by Google
    source_ranges = ["10.128.0.0/9"]
}
