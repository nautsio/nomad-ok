#!/bin/bash
# Quit on errors.
set -e

# Download and install Nomad binary
curl https://releases.hashicorp.com/nomad/0.2.3/nomad_0.2.3_linux_amd64.zip > /tmp/nomad.zip
sudo unzip /tmp/nomad.zip -d /usr/bin

# Move the Nomad files.
sudo mv /tmp/etc/nomad.d /etc/nomad.d

# Set ownership and rights on Nomad directories.
sudo install -o root -g root -m 755 -d /etc/nomad.d /var/local/nomad
sudo install -o root -g root -m 644 /tmp/etc/systemd/system/nomad.service /etc/systemd/system/nomad.service

# Find the daemons.
sudo systemctl daemon-reload
