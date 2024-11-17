resource "yandex_dns_zone" "zone1" {
  name        = "domain-bucket-zone-1"
  description = "desc"

  labels = {
    label1 = "label-1-value"
  }

  zone             = "genkinstonlurk.ru."
  public           = true
  private_networks = [yandex_vpc_network.default.id]
}

resource "yandex_dns_recordset" "server" {
  zone_id = yandex_dns_zone.zone1.id
  name    = "server1.genkinstonlurk.ru"
  type    = "A"
  ttl     = 200
  data    = ["192.168.1.12"]
}

resource "yandex_dns_recordset" "balancer-nginx" {
  zone_id = yandex_dns_zone.zone1.id
  name    = "balancernginx.genkinstonlurk.ru"
  type    = "A"
  ttl     = 200
  data    = ["192.168.1.11"]
}
