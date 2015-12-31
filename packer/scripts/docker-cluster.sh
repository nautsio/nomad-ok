#!/bin/bash
# Quit on errors.
set -e

# Install Docker and add vagrant to docker group.
curl -sSL https://get.docker.com/ | sh
usermod -aG docker vagrant

# Docker overlay networking.
install -o root -g root -m 755 -d /etc/systemd/system/docker.service.d
install -o root -g root -m 644 /tmp/etc/systemd/system/docker.service.d/cluster.conf /etc/systemd/system/docker.service.d/cluster.conf

service docker restart

install -o root -g root -m 755 /tmp/usr/bin/docker-compose /usr/bin/docker-compose

# Pull all images we want to pre-load for the workshop.
docker pull swarm:1.0.0
