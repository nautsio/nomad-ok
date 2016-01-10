job "consul-servers" {
	datacenters = ["sys1"]
	type = "system"

	constraint {
		attribute = "$attr.kernel.name"
		value = "linux"
	}

	update {
		stagger = "10s"
		max_parallel = 1
	}

	group "consul" {
		restart {
			interval = "5m"
			attempts = 10
			delay = "25s"
		}

		task "server" {
			driver = "docker"

			config {
				image = "gliderlabs/consul-server:latest"
				network_mode="host"
				command = "-server"
				args=["-bootstrap-expect", "3", "-join", "nomad-0"]
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
