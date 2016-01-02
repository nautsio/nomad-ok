variable "project" {
  default = "innovation-day-nomad"
}

variable "region" {
  default = "europe-west1-b"
}

variable "disk_image" {
  default = "nomad-ok-1451775321"
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

variable "nomad_client" {
  default = {
    "min_cluster_size" = 3
    "max_cluster_size" = 6
  }
}

variable "nomad_server" {
  default = {
    "cluster_size" = 3
  }
}

variable "consul_server" {
  default = {
    "cluster_size" = 3
  }
}
