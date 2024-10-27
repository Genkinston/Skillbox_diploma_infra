resource "yandex_compute_disk" "boot-disk-2" {
  name     = "boot-disk-2"
  type     = "network-hdd"
  zone     = "ru-central1-a"
  size     = "20"
  image_id = "fd83b9pkhhr6m7tegqjm"
  folder_id = "b1ghj3gm3a5ud4i8h84n"
}

resource "yandex_compute_instance" "vm-2" {
  name = "server1"
  folder_id = "b1ghj3gm3a5ud4i8h84n"
  
  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk-2.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/yacloud.pub")}"
  }
}