#!/bin/bash

set -e

echo "${ssh_key}" > /home/user/.ssh/authorized_keys

ADDR=$(ifconfig eth0 | grep -oP 'inet addr:\K\S+')

cat > /etc/nomad.d/local.hcl << EOF
datacenter = "dc1"

# let clients leave 
leave_on_interrupt = true
leave_on_terminate = true

client {
  servers = ["${prefix}nomad-01:4647", "${prefix}nomad-02:4647", "${prefix}nomad-03:4647"]
  node_class = "docker"
}

telemetry {
  statsite_address = "localhost:8125"
}
EOF

cat > /etc/consul.d/client.json << EOF
{
  "client_addr": "0.0.0.0",
  "leave_on_terminate": true,
	"dns_config": {
		"allow_stale": true,
		"max_stale": "1s"
	},
  "statsite_addr": "localhost:8125",
  "advertise_addr": "$ADDR",
  "retry_join": [ "${prefix}nomad-01", "${prefix}nomad-02", "${prefix}nomad-03" ]
}
