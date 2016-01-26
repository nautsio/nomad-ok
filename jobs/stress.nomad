job "stress" {
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

    group "stress" {
        count = 4

        restart {
    			interval = "120s"
    			attempts = 10
    			delay = "10s"
    			mode = "delay"
    		}

        task "stress" {
            driver = "docker"
            config {
                image = "jess/stress:latest"
								command = "--cpu"
								args = ["1"]
            }

            resources {
                cpu = 500
                memory = 200
            }
        }
    }
}
