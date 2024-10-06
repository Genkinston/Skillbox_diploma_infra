data "twc_configurator" "configurator" {
  location = "ru-1"
  disk_type = "nvme"
}

data "twc_os" "os" {
  name = "ubuntu"
  version = "20.04"
}

resource "twc_server" "my-timeweb-server" {
  name = "My Timeweb Server"
  os_id = data.twc_os.os.id
  ssh_keys_ids = [twc_ssh_key.twcvm.id]

  configuration {
    configurator_id = data.twc_configurator.configurator.id
    disk = 102400
    cpu = 2
    ram = 1024 * 4
  }
}

resource "twc_ssh_key" "twcvm" {
  name = "twcvm"
  body = file("~/.ssh/twcvm.pub")
}