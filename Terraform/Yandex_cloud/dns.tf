resource "yandex_dns_zone" "zone1" {
  name        = "genkinstonlurk.ru"
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
  ttl     = 300
  data    = ["${yandex_compute_instance.vm-1.network_interface.0.nat_ip_address}"]
}

resource "yandex_dns_recordset" "balancer-nginx" {
  zone_id = yandex_dns_zone.zone1.id
  name    = "balancernginx.genkinstonlurk.ru"
  type    = "A"
  ttl     = 200
  data    = ["${yandex_compute_instance.vm-2.network_interface.0.nat_ip_address}"]
}
