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

resource "yandex_dns_zone" "zone1" {
  name        = "my_private_zone"
  description = "desc"

  labels = {
    label1 = "label-1-value"
  }

  zone             = "genkinstonlurk.ru."
  public           = true
  private_networks = [yandex_vpc_network.default.id]
}

resource "yandex_dns_recordset" "domain_bucket" {
  zone_id = yandex_dns_zone.zone1.id
  name    = "genkinstonlurk.ru.website.yandexcloud.net."
  type    = "A"
  ttl     = 200
  data    = ["192.168.1.11"]
}
