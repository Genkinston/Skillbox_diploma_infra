resource "twc_server" "my-timeweb-server" {
  name = "My Timeweb Server"
  os_id = data.twc_os.os.id
  ssh_keys_ids = [twc_ssh_key.twcvm.id]
  project_id = resource.twc_project.Skillbox_DevOps_Project.id

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
