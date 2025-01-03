#Создание публичного ip-адреса

resource "openstack_networking_floatingip_v2" "floatingip_1" {
  pool = "external-network"
}

#Назначение ассоциации публичного и приватного ip-адреса облачного сервера

resource "openstack_networking_floatingip_associate_v2" "association_1" {
  port_id     = openstack_networking_port_v2.port_1.id
  floating_ip = openstack_networking_floatingip_v2.floatingip_1.address
}

#Создание облачного роутера, подключенного к внешней сети

data "openstack_networking_network_v2" "external_network_1" {
  external = true

  depends_on = [
    selectel_vpc_project_v2.project_1,
    selectel_iam_serviceuser_v1.serviceuser_1
  ]
}

#Получение ip-адреса облачного сервера

output "public_ip_address" {
  value = openstack_networking_floatingip_v2.floatingip_1.fixed_ip
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


#Создание сети
resource "openstack_networking_network_v2" "network_1" {
  name           = "private-network"
  admin_state_up = "true"

  depends_on = [
    selectel_vpc_project_v2.project_1,
    selectel_iam_serviceuser_v1.serviceuser_1
  ]
}

#Создание подсети
resource "openstack_networking_subnet_v2" "subnet_1" {
  name       = "private-subnet"
  network_id = openstack_networking_network_v2.network_1.id
  cidr       = "192.168.200.0/24"
}