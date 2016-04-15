#!/bin/bash

set -e

ADDR=$(ifconfig eth0 | grep -oP 'inet addr:\K\S+')

writeSshAuthorizedKey() {
  echo "${ssh_key}" > /home/user/.ssh/authorized_keys
}

writeNomadServerConfig() {
  cat > /etc/nomad.d/local.hcl << EOF
datacenter = "sys1"

leave_on_interrupt = false
leave_on_terminate = false

advertise {
  # We need to specify our host's IP because we can't
  # advertise 0.0.0.0 to other nodes in our cluster.
  rpc = "$ADDR:4647"
}

client {
  servers = ["${stack}-nomad-01:4647", "${stack}-nomad-02:4647", "${stack}-nomad-03:4647"]
  node_class = "system"
}

server {
  enabled = true

  # Startup.
  bootstrap_expect = 3

  # Scheduler configuration.
  num_schedulers = 1

  # join other servers
  retry_join = [ "${stack}-nomad-01", "${stack}-nomad-02", "${stack}-nomad-03" ]
}

telemetry {
  statsite_address = "localhost:8125"
}
EOF
}

writeConsulServerConfig() {
  cat > /etc/consul.d/server.json << EOF
{
  "client_addr": "0.0.0.0",
  "leave_on_terminate": true,
  "ui": true,
  "dns_config": {
    "allow_stale": false
  },
  "advertise_addr": "$ADDR",
  "statsite_addr": "localhost:8125",
  "server": true,
  "retry_join": [ "${stack}-nomad-01", "${stack}-nomad-02", "${stack}-nomad-03" ],
  "bootstrap_expect": 3
}
EOF
}

configureLoggly() {
  # skip if no token has been supplied
  [ -z "${loggly_token}" ] && return

  cat > /etc/rsyslog.d/22-loggly.conf << EOF
# Define the template used for sending logs to Loggly. Do not change this format.
\$template LogglyFormat,"<%pri%>%protocol-version% %timestamp:::date-rfc3339% %HOSTNAME% %app-name% %procid% %msgid% [${loggly_token}@41058 tag=${stack}] %msg%\n"

\$WorkDirectory /var/spool/rsyslog # where to place spool files
\$ActionQueueFileName fwdRule1 # unique name prefix for spool files
\$ActionQueueMaxDiskSpace 1g   # 1gb space limit (use as much as possible)
\$ActionQueueSaveOnShutdown on # save messages to disk on shutdown
\$ActionQueueType LinkedList   # run asynchronously
\$ActionResumeRetryCount -1    # infinite retries if host is down

# Send messages to Loggly over TCP using the template.
*.*             @@logs-01.loggly.com:514;LogglyFormat
EOF

  service rsyslog restart
}

configureLoggly
writeSshAuthorizedKey
writeNomadServerConfig
writeConsulServerConfig
