#!/bin/bash

set -e

ADDR=$(ifconfig eth0 | grep -oP 'inet addr:\K\S+')

writeSshAuthorizedKey() {
  echo "${ssh_key}" > /home/user/.ssh/authorized_keys
}

writeNomadClientConfig() {
  cat > /etc/nomad.d/local.hcl << EOF
datacenter = "dc1"

# let clients leave
leave_on_interrupt = true
leave_on_terminate = true

client {
  servers = ["${stack}-nomad-01:4647", "${stack}-nomad-02:4647", "${stack}-nomad-03:4647"]
  node_class = "docker"
}

telemetry {
  statsite_address = "localhost:8125"
}
EOF
}

writeConsulClientConfig() {
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
  "retry_join": [ "${stack}-nomad-01", "${stack}-nomad-02", "${stack}-nomad-03" ]
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
writeNomadClientConfig
writeConsulClientConfig
