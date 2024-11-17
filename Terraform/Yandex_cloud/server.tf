resource "yandex_compute_disk" "boot-disk-1" {
  name     = "boot-disk-1"
  type     = "network-hdd"
  zone     = "ru-central1-a"
  size     = "10"
  image_id = "fd83b9pkhhr6m7tegqjm"
  folder_id = "b1ghj3gm3a5ud4i8h84n"
}

resource "yandex_compute_instance" "vm-1" {
  name = "server1"
  folder_id = "b1ghj3gm3a5ud4i8h84n"
  hostname = "server1.genkinstonlurk.ru"
  
  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk-1.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
    security_group_ids = ["${yandex_vpc_security_group.web_server_sg1.id}"]
  }

  scheduling_policy {
    preemptible = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/yacloud.pub")}"
    user-data = "#cloud-config\nusers:\n  - name: lurk\n    groups: sudo\n    shell: /bin/bash\n    sudo: 'ALL=(ALL) NOPASSWD:ALL'\n    ssh-authorized-keys:\n      - ${file("/home/lurk/.ssh/yacloud.pub")}"
  }
}