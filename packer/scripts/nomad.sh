#!/bin/bash
# Quit on errors.
set -e

# Download and install Nomad binary
curl https://releases.hashicorp.com/nomad/0.2.3/nomad_0.2.3_linux_amd64.zip > /tmp/nomad.zip
unzip /tmp/nomad.zip -d /usr/bin
rm /tmp/nomad.zip

# Move the Nomad files.
mv /tmp/etc/nomad.d /etc/nomad.d

# Set ownership and rights on Nomad directories.
install -o root -g root -m 755 -d /etc/nomad.d /var/local/nomad
install -o root -g root -m 644 /tmp/etc/systemd/system/nomad.service /etc/systemd/system/nomad.service
install -o root -g root -m 755 /tmp/usr/bin/nomad-config-ip /usr/bin/nomad-config-ip

# Enable the daemon.
systemctl daemon-reload
systemctl enable nomad
