#!/bin/bash

set -e

cat > /etc/nomad.d/local.hcl << EOF
datacenter = "dc1"

client {
  servers = ["default-nomad-0:4647", "default-nomad-1:4647", "default-nomad-2:4647"]
  node_class = "docker"
}

telemetry {
  statsite_address = "localhost:8125"
}
EOF

systemctl restart nomad
