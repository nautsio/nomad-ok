#!/bin/bash

set -e

echo "${ssh_key}" > /home/user/.ssh/authorized_keys

cat > /etc/nomad.d/local.hcl << EOF
datacenter = "dc1"

client {
  servers = ["${prefix}nomad-01:4647", "${prefix}nomad-02:4647", "${prefix}nomad-03:4647"]
  node_class = "docker"
}

telemetry {
  statsite_address = "localhost:8125"
}
EOF

systemctl restart nomad
