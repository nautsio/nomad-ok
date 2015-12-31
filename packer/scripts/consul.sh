#!/bin/bash
# Quit on errors.
set -e

# Set ownership and rights on Consul directories.
sudo install -o root -g root -m 755 -d /etc/consul.d /var/local/consul
sudo install -o root -g root -m 644 /tmp/etc/systemd/system/consul.service /etc/systemd/system/consul.service

# Move the Consul files.
sudo install -o root -g root -m 755 /tmp/etc/consul.d/* /etc/consul.d/
sudo install -o root -g root -m 755 /tmp/usr/bin/consul /usr/bin/consul

# Find, enable and start the daemons.
sudo systemctl daemon-reload
sudo systemctl enable consul.service
