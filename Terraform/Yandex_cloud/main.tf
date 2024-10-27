terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone = "ru-central1-a" # Зона доступности по умолчанию
  service_account_key_file = "/home/lurk/.config/yandex-cloud/authorized_key.json"
}

resource "yandex_vpc_network" "default" {
  name = "my-network"
  folder_id = "b1ghj3gm3a5ud4i8h84n"
}

resource "yandex_vpc_subnet" "subnet-1" {
  zone = "ru-central1-a"
  folder_id = "b1ghj3gm3a5ud4i8h84n"
  network_id = "${yandex_vpc_network.default.id}"
  v4_cidr_blocks = ["192.168.0.0/24", "192.168.1.0/24"]
}

