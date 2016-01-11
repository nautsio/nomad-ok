#!/bin/bash
# Quit on errors.
set -e

# pull both explicit versions & latest
docker pull redis
#docker pull mvanholsteijn/paas-monitor
docker pull jess/stress
docker pull sysdig/agent
docker pull gliderlabs/consul-server
