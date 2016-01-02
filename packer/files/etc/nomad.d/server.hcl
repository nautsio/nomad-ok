server {
  enabled = true

  # Startup.
  bootstrap_expect = 3

  # Scheduler configuration.
  num_schedulers = 1

  # join other servers
  retry_join = [ "nomad-0", "nomad-1", "nomad-2" ]
}
