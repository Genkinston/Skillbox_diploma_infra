resource "yandex_vpc_network" "default" {
  name = "my-network"
  folder_id = "b1ghj3gm3a5ud4i8h84n"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name = "subnet1"
  zone = "ru-central1-a"
  folder_id = "b1ghj3gm3a5ud4i8h84n"
  network_id = "${yandex_vpc_network.default.id}"
  v4_cidr_blocks = ["192.168.1.0/24"]
}