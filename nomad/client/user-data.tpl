#cloud-config
---
write-files:
- path: /tmp/nomad.conf
  permissions: '0644'
  content: |
    # Location
    region = "global"
    datacenter = "dc1"
    # Logging
    enable_debug = true
    enable_syslog = true
    syslog_facility = "LOCAL0"
    # show lots of logs for educational purposes
    log_level = "DEBUG"
    # Node
    data_dir = "/var/local/nomad"
    # we bind to 0.0.0.0 for easy of use, so we access it both via localhost and
    # the public interface. This is NOT secure off course
    bind_addr="0.0.0.0"
    ports {
      http = 4646
      rpc = 4647
      serf = 4648
    }
    disable_update_check = false
    disable_anonymous_signature = false
    leave_on_interrupt = true
    leave_on_terminate = true
    client {
      enabled = true
      servers = ["${stack}-nomad-01:4647", "${stack}-nomad-02:4647", "${stack}-nomad-03:4647"]
      node_class = "docker"
      network_interface = "ens4v1"
      network_speed = 1000
      options = {
        "driver.raw_exec.enable" = "1"
      }
    }
    telemetry {
      statsite_address = "localhost:8125"
    }

coreos:
  units:
    - name: "nomad.service"
      command: "start"
      content: |
        [Unit]
        Description=Nomad Agent
        After=docker.service
        [Service]
        TimeoutStartSec=0
        ExecStartPre=/usr/bin/install -d /opt/bin
        ExecStartPre=/usr/bin/wget -q -O /opt/bin/nomad https://storage.googleapis.com/xebia-hashicontest-eu-west1/bin/nomad-0.3.2
        ExecStartPre=/usr/bin/chmod 755 /opt/bin/nomad
        ExecStart=/opt/bin/nomad agent -config=/tmp/nomad.conf
        [Install]
        WantedBy=multi-user.target
