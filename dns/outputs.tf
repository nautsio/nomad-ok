output "domain" {
  value = "${google_dns_managed_zone.managed_zone.dns_name}"
}

output "zone" {
  value = "${google_dns_managed_zone.managed_zone.name}"
}
