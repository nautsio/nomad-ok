#!/bin/bash

set -e

cat > /etc/nomad.d/local.hcl << EOF
datacenter = "dc1"

client {
  node_class = "docker"
}

telemetry {
  statsite_address = "localhost:8125"
}
EOF

systemctl restart nomad
