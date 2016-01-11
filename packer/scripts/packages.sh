#!/bin/bash
# Quit on errors.
set -e

apt-get update

# Install tools.
DEBIAN_FRONTEND=noninteractive apt-get install -y curl jq unzip linux-headers-$(uname -r)

# Install kernel headers for Sysdig
DEBIAN_FRONTEND=noninteractive apt-get install -y linux-headers-$(uname -r)
