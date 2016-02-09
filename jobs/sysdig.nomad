job "sysdig" {
	datacenters = ["sys1", "dc1"]
	type = "system"

	constraint {
		attribute = "${attr.kernel.name}"
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
			mode = "delay"
		}

		task "sysdig" {
			driver = "raw_exec"

			config {
				command = "/usr/bin/docker"
				args=["run",
							"--privileged",
							"--net", "host",
							"--pid", "host",
 							"-e", "ACCESS_KEY",
							"-e", "TAGS",
							"-v", "/var/run/docker.sock:/host/var/run/docker.sock",
 							"-v", "/dev:/host/dev",
							"-v", "/proc:/host/proc:ro",
							"-v", "/boot:/host/boot:ro",
 							"-v", "/lib/modules:/host/lib/modules:ro",
							"-v", "/usr:/host/usr:ro",
 							"sysdig/agent"]
			}

			env {
					TAGS="stack:bbakker,nomad.dc:$node.datacenter,zone:$attr.platform.gce.zone"
					ACCESS_KEY="7535a00e-58aa-4073-b55e-eb0ccd22c410"
			}

			# NB is not reachable outside localhost
			service {
				name = "${TASKGROUP}"
				tags = ["statsite"]
				port = "sysdig_statsite"
			}

			resources {
				cpu = 50 # 500 Mhz
				memory = 256 # 256MB
				network {
					mbits = 10
					port "sysdig_statsite" {
						static = "8125"
					}
				}
			}
		}
	}
}
