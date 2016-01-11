#!/bin/bash

set -e

ADDR=$(ifconfig eth0 | grep -oP 'inet addr:\K\S+')
cat > /etc/nomad.d/local.hcl << EOF
datacenter = "sys1"

advertise {
  # We need to specify our host's IP because we can't
  # advertise 0.0.0.0 to other nodes in our cluster.
  rpc = "$ADDR:4647"
}

client {
  node_class = "system"
}

server {
  enabled = true

  # Startup.
  bootstrap_expect = 3

  # Scheduler configuration.
  num_schedulers = 1

  # join other servers
  retry_join = [ "nomad-0", "nomad-1", "nomad-2" ]
}
EOF

systemctl restart nomad
