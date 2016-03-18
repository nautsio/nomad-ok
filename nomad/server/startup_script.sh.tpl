#!/bin/bash

set -e

echo "${ssh_key}" > /home/user/.ssh/authorized_keys

ADDR=$(ifconfig eth0 | grep -oP 'inet addr:\K\S+')
cat > /etc/nomad.d/local.hcl << EOF
region = "${region}"
datacenter = "sys1-${region}"

leave_on_interrupt = false
leave_on_terminate = false

advertise {
  # We need to specify our host's IP because we can't
  # advertise 0.0.0.0 to other nodes in our cluster.
  rpc = "$ADDR:4647"
}

client {
  servers = ["${prefix}nomad-${region}-01:4647", "${prefix}nomad-${region}-02:4647", "${prefix}nomad-${region}-03:4647"]
  node_class = "system"
}

server {
  enabled = true

  # Startup.
  bootstrap_expect = 3

  # Scheduler configuration.
  num_schedulers = 1

  # join other servers
  retry_join = [ "${prefix}nomad-eu-01", "${prefix}nomad-us-01", "${prefix}nomad-asia-01" ]
}

telemetry {
  statsite_address = "localhost:8125"
}
EOF

cat > /etc/consul.d/server.json << EOF
{
  "datacenter": "${region}",
  "client_addr": "0.0.0.0",
  "leave_on_terminate": true,
  "ui": true,
  "dns_config": {
    "allow_stale": false
  },
  "advertise_addr": "$ADDR",
  "statsite_addr": "localhost:8125",
  "server": true,
  "retry_join": [ "${prefix}nomad-${region}-01" ],
  "retry_join_wan": [
    "${prefix}nomad-eu-01", "${prefix}nomad-us-01", "${prefix}nomad-asia-01",
    "${prefix}nomad-eu-02", "${prefix}nomad-us-02", "${prefix}nomad-asia-02",
    "${prefix}nomad-eu-03", "${prefix}nomad-us-03", "${prefix}nomad-asia-03"
   ],
  "bootstrap_expect": 3
}
EOF
