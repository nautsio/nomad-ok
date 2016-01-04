# Location
region = "global"

# Logging
enable_debug = true
enable_syslog = true
syslog_facility = "LOCAL0"
log_level = "INFO"

# Node
data_dir = "/var/local/nomad"
bind_addr="0.0.0.0"
ports {
  http = 4646
  rpc = 4647
  serf = 4648
}
leave_on_interrupt = false
leave_on_terminate = false
disable_updates_check = false
disable_anonymous_signature = false
