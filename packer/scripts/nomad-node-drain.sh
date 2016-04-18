#!/bin/bash

TOOL=nomad-node-drain

install -o root -g root -m 755 /tmp/usr/bin/${TOOL} /usr/bin/${TOOL}
install -o root -g root -m 644 /tmp/etc/systemd/system/${TOOL}.service /etc/systemd/system/${TOOL}.service

# Find, enable and start the daemon.
systemctl daemon-reload
systemctl enable ${TOOL}.service
