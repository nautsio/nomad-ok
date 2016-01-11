#!/bin/bash

set -e

cat > /etc/nomad.d/local.hcl << EOF
datacenter = "dc1"

client {
  node_class = "docker"
  options = {
    "driver.raw_exec.enable" = "1"
  }
}
EOF

systemctl restart nomad
