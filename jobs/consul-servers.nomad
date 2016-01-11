job "consul-servers" {
	datacenters = ["sys1", "dc1"]
	type = "system"

	constraint {
		attribute = "$attr.kernel.name"
		value = "linux"
	}

	update {
		stagger = "10s"
		max_parallel = 1
	}

	group "server" {
		restart {
			interval = "5m"
			attempts = 10
			delay = "25s"
		}

		constraint {
			attribute = "$node.datacenter"
			value = "sys1"
		}

		task "agent" {
			driver = "docker"

			config {
				image = "gliderlabs/consul-server:latest"
				network_mode="host"
				command = "-server"
				args=["-bootstrap-expect", "3", "-retry-join", "nomad-0"]
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

	group "client" {
		restart {
			interval = "5m"
			attempts = 10
			delay = "25s"
		}

		constraint {
			attribute = "$node.datacenter"
			value = "dc1"
		}

		task "agent" {
			driver = "docker"

			config {
				image = "gliderlabs/consul-agent:latest"
				network_mode="host"
				command = "-retry-join"
				args=["nomad-0"]
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
