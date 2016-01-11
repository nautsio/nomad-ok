client {
  enabled = true
  network_interface = "eth0"
  network_speed = 1000
  servers = ["nomad-0:4647", "nomad-1:4647", "nomad-2:4647"]

  options = {
    "driver.raw_exec.enable" = "1"
  }

}
