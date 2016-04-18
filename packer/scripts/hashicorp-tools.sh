#!/bin/bash
# Quit on errors.
set -e

install_hashicorp_tool() {
  local TOOL=$1
  local REL_VERSION=$2
  local DEV_VERSION=$3

  echo installing ${TOOL} version ${REL_VERSION}

  # Download and install binary
  curl https://releases.hashicorp.com/${TOOL}/${REL_VERSION}/${TOOL}_${REL_VERSION}_linux_amd64.zip > /tmp/dist.zip
  unzip /tmp/dist.zip -d /usr/bin
  mv /usr/bin/${TOOL} /usr/bin/${TOOL}-${REL_VERSION}
  rm /tmp/dist.zip

  # If provided, install local binary and make it default
  if [ -e /tmp/usr/bin/${TOOL} ]; then
    install -o root -g root -m 755 /tmp/usr/bin/${TOOL} /usr/bin/${TOOL}-${DEV_VERSION}
    ln -s /usr/bin/${TOOL}-${DEV_VERSION} /usr/bin/${TOOL}
  else
    ln -s /usr/bin/${TOOL}-${REL_VERSION} /usr/bin/${TOOL}
  fi

  # Move the config files.
  mv /tmp/etc/${TOOL}.d /etc/${TOOL}.d

  # Set ownership and rights on directories.
  install -o root -g root -m 755 -d /etc/${TOOL}.d /var/local/${TOOL}
  install -o root -g root -m 644 /tmp/etc/systemd/system/${TOOL}.service /etc/systemd/system/${TOOL}.service

  # Find, enable and start the daemon.
  systemctl daemon-reload
  systemctl enable ${TOOL}.service
}

install_hashicorp_tool consul 0.6.4
install_hashicorp_tool nomad 0.3.1 0.3.2-rc1
