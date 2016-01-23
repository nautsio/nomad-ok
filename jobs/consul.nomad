job "consul" {
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
			mode = "delay"
		}

		constraint {
			attribute = "$node.datacenter"
			value = "sys1"
		}

		task "consul-server" {
			driver = "docker"

			config {
				image = "gliderlabs/consul-server:latest"
				network_mode="host"
				command = "-advertise"
				args=["$network.ip-address",
							"-retry-join", "default-nomad-01",
							"-retry-join", "default-nomad-02",
							"-retry-join", "default-nomad-03",
							"-server",
							"-bootstrap-expect", "3"]
			}
			resources {
				cpu = 500 # 500 Mhz
				memory = 256 # 256MB
				network {
					mbits = 10
					port "consul_server" {
						static="8300"
					}
					port "consul_serf_lan" {
						static="8301"
					}
					port "consul_serf_wan" {
						static="8302"
					}
					port "consul_rpc" {
						static="8400"
					}
					port "consul_http" {
						static="8500"
					}
					port "consul_dns" {
						static="8600"
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
			mode = "delay"
		}

		constraint {
			attribute = "$node.datacenter"
			value = "dc1"
		}

		task "consul-client" {
			driver = "docker"

			config {
				image = "gliderlabs/consul-agent:latest"
				network_mode="host"
				command = "-advertise"
				args=["$network.ip-address",
							"-retry-join", "default-nomad-01",
							"-retry-join", "default-nomad-02",
							"-retry-join", "default-nomad-03"]
			}

			resources {
				cpu = 50 # 500 Mhz
				memory = 256 # 256MB
				network {
					mbits = 10
					port "consul_server" {
						static="8300"
					}
					port "consul_serf_lan" {
						static="8301"
					}
					port "consul_serf_wan" {
						static="8302"
					}
					port "consul_rpc" {
						static="8400"
					}
					port "consul_http" {
						static="8500"
					}
					port "consul_dns" {
						static="8600"
					}
				}
			}
		}
	}
}
