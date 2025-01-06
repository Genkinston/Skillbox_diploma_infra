#Создание облачного роутера, подключенного к внешней сети
# Облачный роутер, подключенный к внешней сети,
# выполняет функцию 1:1 NAT для доступа из приватной сети в интернет через публичный IP-адрес роутера.

data "openstack_networking_network_v2" "external_network_1" {
  external = true

  depends_on = [
    selectel_vpc_project_v2.project_genkinstonlurk,
    selectel_iam_serviceuser_v1.serviceuser_1
  ]
}

resource "openstack_networking_router_v2" "router_1" {
  name                = "router"
  external_network_id = data.openstack_networking_network_v2.external_network_1.id
}

resource "openstack_networking_router_interface_v2" "router_interface_1" {
  router_id = openstack_networking_router_v2.router_1.id
  subnet_id = openstack_networking_subnet_v2.subnet_1.id
}

#Создание порта облачного сервера

resource "openstack_networking_port_v2" "port_1" {
  name       = "port"
  network_id = openstack_networking_network_v2.network_1.id

  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.subnet_1.id
  }
}

#Создание ssh порта облачного сервера

resource "openstack_networking_port_v2" "port_ssh" {
  name       = "ssh_port"
  network_id = openstack_networking_network_v2.network_1.id
  admin_state_up = true # вкл/выкл порта при необходимости работ

  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.subnet_1.id
  }
}

#Создание публичного ip-адреса ssh

resource "openstack_networking_floatingip_v2" "floatingip_ssh" {
  pool = "external-network"
  port_id = openstack_networking_port_v2.port_ssh.id
}

#Создание публичного ip-адреса с подключением к балансировщику

resource "openstack_networking_floatingip_v2" "floatingip_1" {
  pool = "external-network"
  port_id = openstack_lb_loadbalancer_v2.load_balancer_1.vip_port_id
}

#Получить IP-адрес балансировщика нагрузки

output "public_ip_address_lb" {
  value = openstack_networking_floatingip_v2.floatingip_1.address
}

#Получить IP-адрес ssh порта сервера

output "public_ip_address_ssh" {
  value = openstack_networking_floatingip_v2.floatingip_ssh.address
}