job "helloworld" {
    region = "global"
    datacenters = ["dc1"]

    type = "service"

    priority = 50

    constraint {
  		attribute = "$attr.kernel.name"
  		value = "linux"
  	}

    update {
        stagger = "10s"
        max_parallel = 1
    }

    group "helloworld" {
        count = 2

        constraint {
    			attribute = "$node.datacenter"
    			value = "dc1"
    		}

        restart {
    			interval = "30s"
    			attempts = 10
    			delay = "10s"
    			mode = "delay"
    		}

        task "helloworld" {
            driver = "docker"
            config {
                image = "b.gcr.io/kuar/helloworld:2.0.0"
                port_map {
        					http = 80
        				}
            }

            resources {
                cpu = 100
                memory = 200
                network {
                  mbits = 10
                  port "http" {

                  }
                }
            }

            service {
              name = "${TASKGROUP}-helloworld-v2"
      				tags = ["global", "hello", "v2"]
      				port = "http"
      				check {
      					name = "alive"
      					type = "http"
      					interval = "10s"
      					timeout = "2s"
      				}
            }
        }

        task "redis" {
            driver = "docker"
            config {
                image = "redis:2.8.22"
                port_map {
        					db = 6379
        				}
            }
            resources {
                cpu = 100
                memory = 200
            }
        }
    }
}
