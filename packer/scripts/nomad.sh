#!/bin/bash
# Quit on errors.
set -e

# Move the Nomad files.
sudo mv /tmp/etc/nomad.d /etc/nomad.d
sudo mv /tmp/usr/bin/nomad /usr/bin/nomad

# Set ownership and rights on Nomad directories.
sudo install -o root -g root -m 755 -d /etc/nomad.d /var/local/nomad
sudo install -o root -g root -m 644 /tmp/etc/systemd/system/nomad.service /etc/systemd/system/nomad.service

# Find the daemons.
sudo systemctl daemon-reload
