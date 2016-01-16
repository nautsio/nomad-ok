#!/bin/bash

set -e

echo "${ssh_key}" > /home/user/.ssh/authorized_keys

ADDR=$(ifconfig eth0 | grep -oP 'inet addr:\K\S+')
cat > /etc/nomad.d/local.hcl << EOF
datacenter = "sys1"

advertise {
  # We need to specify our host's IP because we can't
  # advertise 0.0.0.0 to other nodes in our cluster.
  rpc = "$ADDR:4647"
}

client {
  servers = ["${prefix}nomad-01:4647", "${prefix}nomad-02:4647", "${prefix}nomad-03:4647"]
  node_class = "system"
}

server {
  enabled = true

  # Startup.
  bootstrap_expect = 3

  # Scheduler configuration.
  num_schedulers = 1

  # join other servers
  retry_join = [ "${prefix}nomad-01", "${prefix}nomad-02", "${prefix}nomad-03" ]
}

telemetry {
  statsite_address = "localhost:8125"
}
EOF

systemctl restart nomad
