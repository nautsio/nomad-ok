#!/bin/bash

set -e

cat > /etc/nomad.d/local.hcl << EOF
datacenter = "dc1"

client {
  node_class = "docker"
}
EOF

systemctl restart nomad
