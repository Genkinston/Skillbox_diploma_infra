resource "yandex_dns_zone" "zone1" {
  name        = "domain"
  description = "desc"

  labels = {
    label1 = "label-1-value"
  }

  zone             = "genkinstonlurk.ru."
  public           = true
  private_networks = [yandex_vpc_network.default.id]
}

resource "yandexcloud_dns_record" "zone1" {
  zone_id = yandexcloud_dns_zone.zone1.id
  name = "www"
  type = "CNAME"
  ttl = 300
  value = "www.genkinstonlurk.ru"
}

resource "yandex_dns_recordset" "server" {
  zone_id = yandex_dns_zone.zone1.id
  name    = "server1.genkinstonlurk.ru"
  type    = "A"
  ttl     = 300
  data    = ["${yandex_compute_instance.vm-1.network_interface.0.nat_ip_address}"]
}

resource "yandex_dns_recordset" "balancer-nginx" {
  zone_id = yandex_dns_zone.zone1.id
  name    = "balancernginx.genkinstonlurk.ru"
  type    = "A"
  ttl     = 200
  data    = ["${yandex_compute_instance.vm-balancernginx.network_interface.0.nat_ip_address}"]
}
