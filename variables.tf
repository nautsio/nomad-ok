variable "project" {
  default = "innovation-day-nomad"
}

variable "region" {
  default = "europe-west1-b"
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
