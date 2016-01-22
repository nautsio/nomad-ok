#!/bin/bash
# Quit on errors.
set -e

REL_VERSION=0.2.3
DEV_VERSION=0.3.0-dev

# Download and install Nomad binary
curl https://releases.hashicorp.com/nomad/${REL_VERSION}/nomad_${REL_VERSION}_linux_amd64.zip > /tmp/nomad.zip
unzip /tmp/nomad.zip -d /usr/bin
mv /usr/bin/nomad /usr/bin/nomad-${REL_VERSION}
rm /tmp/nomad.zip

# If provided, install local nomad binary and maked default
if [ -e /tmp/usr/bin/nomad ]; then
  install -o root -g root -m 755 /tmp/usr/bin/nomad /usr/bin/nomad-${DEV_VERSION}
  ln -s /usr/bin/nomad-${DEV_VERSION} /usr/bin/nomad
else
  ln -s /usr/bin/nomad-${REL_VERSION} /usr/bin/nomad
fi

# Move the Nomad files.
mv /tmp/etc/nomad.d /etc/nomad.d

# Set ownership and rights on Nomad directories.
install -o root -g root -m 755 -d /etc/nomad.d /var/local/nomad
install -o root -g root -m 644 /tmp/etc/systemd/system/nomad.service /etc/systemd/system/nomad.service

systemctl daemon-reload
systemctl enable nomad.service
