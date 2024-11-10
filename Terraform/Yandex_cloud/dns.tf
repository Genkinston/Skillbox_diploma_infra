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
