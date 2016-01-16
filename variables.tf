variable "project" {
  default = "innovation-day-nomad"
}

variable "region" {
  default = "europe-west1-b"
}

variable "zones" {
  default = "europe-west1-b,europe-west1-c,europe-west1-d"
}

variable "disk_image" {
  default = "nomad-ok-1452903405"
}

variable "external" {
  default = {
    "dns_name" = "gcloud.nauts.io."
  }
}

variable "internal" {
  default = {
    "dns_name" = "local."
  }
}

variable "instance" {
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
    "machine_type" = "n1-standard-1"
#    "machine_type" = "g1-small"
  }
}

variable "nomad_server" {
  default = {
    "machine_type" = "n1-standard-1"
#    "machine_type" = "g1-small"
    "cluster_size" = 3
  }
}

variable "consul_server" {
  default = {
    "cluster_size" = 3
  }
}
