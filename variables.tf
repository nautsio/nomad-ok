variable "project" {
  default = "innovation-day-nomad"
}

variable "region" {
  default = "europe-west1-b"
}

variable "zones" {
  default = "europe-west1-b,europe-west1-c,europe-west1-d"
}

variable "external_domain" {
  default = "gce.nauts.io."
}

variable "internal_domain" {
  default = "local."
}

variable "stack" {
  default = "default"
}

variable "ssh_key" {
  default = ""
}

variable "nomad_client" {
  default = {
    "groups" = 2
    "min_cluster_size" = 2
    "max_cluster_size" = 4
    "machine_type" = "g1-small"
  }
}

variable "nomad_server" {
  default = {
    "machine_type" = "g1-small"
    "cluster_size" = 3
  }
}

variable "consul_server" {
  default = {
    "cluster_size" = 3
  }
}
