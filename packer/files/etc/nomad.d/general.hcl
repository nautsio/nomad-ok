# Location
region = "global"

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
