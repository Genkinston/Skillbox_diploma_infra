resource "yandex_lb_network_load_balancer" "foo" {
  name = "network-load-balancer-yandex"

  listener {
    name = "http-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.target-group-1.id

    healthcheck {
      name = "http"
      unhealthy_threshold = 5
      healthy_threshold   = 5
      http_options {
        port = 80
        path = "/ping"
      }
    }
  }
}

resource "yandex_lb_target_group" "target-group-1" {
  name      = "my-target-group"
  region_id = "ru-central1"

  target {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    address   = yandex_compute_instance.vm-2.network_interface.0.ip_address
  }
}