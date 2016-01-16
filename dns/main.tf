resource "google_dns_managed_zone" "managed_zone" {
    name = "${var.name}"
    description = "${var.description}"
    dns_name = "${var.domain}"
}
