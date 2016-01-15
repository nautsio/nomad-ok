resource "google_dns_managed_zone" "external" {
    name = "nomad-ok-external-zone"
    description = "Nomad OK External zone"
    dns_name = "cloud.nauts.io."
}

resource "google_dns_managed_zone" "internal" {
  name = "nomad-ok-internal-zone"
  description = "Nomad OK Internal zone"
  dns_name = "int.nauts.io."
}
