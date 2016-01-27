job "helloworld" {
  datacenters = ["dc1"]
  type = "service"

  update {
    stagger = "30s"
    max_parallel = 1
  }

  group "helloworld" {
    count = 1
    task "helloworld" {
      driver = "docker"
      config {
        image = "cargonauts/helloworld:v1"
        port_map {
          http = 80
        }
      }
      resources {
        cpu = 100
        memory = 200
        network {
        port "http" {}
        }
      }
    }
  }
}
