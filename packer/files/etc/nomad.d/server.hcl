server {
  enabled = true

  # Startup.
  bootstrap_expect = 3

  # Scheduler configuration.
  num_schedulers = 1
  enabled_schedulers = ["service", "batch"]
}
