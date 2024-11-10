resource "twc_server" "my-timeweb-balancer" {
  name = "My Timeweb Balancer"
  os_id = data.twc_os.os.id
  project_id = resource.twc_project.Skillbox_DevOps_Project.id
  ssh_keys_ids = [twc_ssh_key.twcvm.id]

  configuration {
    configurator_id = data.twc_configurator.configurator.id
    disk = 15360
    cpu = 1
    ram = 1024 * 1
  }
}

data "twc_configurator" "configurator" {
  location = "ru-1"
  disk_type = "ssd"
}

data "twc_os" "os" {
  name = "ubuntu"
  version = "24.04"
}

resource "twc_server_ip" "domain" {
  source_server_id = twc_server.my-timeweb-balancer.id

  type = "ipv4"
  ptr = "genkinstonlurk.ru"
}
