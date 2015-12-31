#!/bin/bash
# Quit on errors.
set -e

# Install Docker
curl -sSL https://get.docker.com/ | sh

# Enable cgroups memory accounting
perl -pi -e 's/^GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX="debian-installer=en_US cgroup_enable=memory swapaccount=1"/' /etc/default/grub
update-grub
