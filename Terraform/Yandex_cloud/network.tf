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

# Создание группы безопасности

resource "yandex_vpc_security_group" "web_server_sg1" {
  name        = "Security_group_1"
  network_id  = "${yandex_vpc_network.default.id}"
  ingress {
    protocol       = "TCP"
    description    = "http"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "https"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }

  ingress {
    protocol       = "TCP"
    description    = "ssh"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  egress {
    protocol       = "ANY"
    description    = "any"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}