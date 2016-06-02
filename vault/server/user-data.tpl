#cloud-config
---
write-files:
- path: /tmp/vault.conf
  permissions: '0644'
  content: |
    # Location
    backend "file" {
      path = "/tmp/vault"
    }

    listener "tcp" {
      address = "0.0.0.0:8200"
      tls_disable = 1
    }

coreos:
  units:
    - name: "vault.service"
      command: "start"
      content: |
        [Unit]
        Description=Vault Server
        After=docker.service
        [Service]
        TimeoutStartSec=0
        ExecStartPre=/usr/bin/install -d /opt/bin /tmp/vault
        ExecStartPre=/usr/bin/wget -q -O /opt/bin/vault https://storage.googleapis.com/xebia-hashicontest-eu-west1/bin/vault-0.5.3
        ExecStartPre=/usr/bin/chmod 755 /opt/bin/vault
        ExecStart=/opt/bin/vault server -config=/tmp/vault.conf
        [Install]
        WantedBy=multi-user.target
