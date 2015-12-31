#!/bin/bash
# Quit on errors.
set -e

# pull both explicit versions & latest
docker pull redis:3.0.5
docker pull redis:latest
docker pull mvanholsteijn/paas-monitor:9c3fcd7
docker pull mvanholsteijn/paas-monitor:latest
docker pull jess/stress
