#!/bin/bash
# Quit on errors.
set -e

useradd -m -G docker --shell /bin/bash user

# allow passwordless sudo
echo user ALL=NOPASSWD: ALL > /etc/sudoers.d/user
chmod 440 /etc/sudoers.d/user

install -d -o user -g user -m 755 /home/user/.ssh
