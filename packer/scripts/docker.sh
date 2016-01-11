#!/bin/bash
# Quit on errors.
set -e

# Install Docker
curl -sSL https://get.docker.com/ | sh

# maybe work around issue 'System error: The minimum allowed cpu-shares is 1024'
install -o root -g root -m 755 -d /etc/systemd/system/docker.service.d
install -o root -g root -m 644 /tmp/etc/systemd/system/docker.service.d/exec.conf /etc/systemd/system/docker.service.d/exec.conf

systemctl daemon-reload

# Enable cgroups memory accounting
perl -pi -e 's/^(GRUB_CMDLINE_LINUX=".*)"/$1 debian-installer=en_US cgroup_enable=memory swapaccount=1"/' /etc/default/grub
update-grub
