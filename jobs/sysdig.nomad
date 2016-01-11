job "sysdig" {
	datacenters = ["sys1", "dc1"]
	type = "service"

	constraint {
		attribute = "$attr.kernel.name"
		value = "linux"
	}

	update {
		stagger = "10s"
		max_parallel = 1
	}

	group "sysdig" {
		restart {
			interval = "5m"
			attempts = 10
			delay = "25s"
		}

		task "sysdig" {
			driver = "raw_exec"

			config {
				command = "/usr/bin/docker"
				args=["run", "--name", "sysdig-agent", "--privileged", "--net", "host",
							"--pid", "host", "-e", "ACCESS_KEY=7535a00e-58aa-4073-b55e-eb0ccd22c410",
 							"-e", "TAGS=nomad", "-v", "/var/run/docker.sock:/host/var/run/docker.sock",
 							"-v", "/dev:/host/dev", "-v", "/proc:/host/proc:ro", "-v", "/boot:/host/boot:ro",
 							"-v", "/lib/modules:/host/lib/modules:ro", "-v", "/usr:/host/usr:ro",
 							"sysdig/agent"]
			}

			resources {
				cpu = 500 # 500 Mhz
				memory = 256 # 256MB
				network {
					mbits = 10
					port "db" {
					}
				}
			}
		}
	}
}
