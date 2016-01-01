#!/bin/bash
# Quit on errors.
set -e

# Install tools.
apt-get update
apt-get install -y curl jq unzip
