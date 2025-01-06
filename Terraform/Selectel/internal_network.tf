#Создание сети
resource "openstack_networking_network_v2" "network_1" {
  name           = "private-network"
  admin_state_up = "true"

  depends_on = [
    selectel_vpc_project_v2.project_genkinstonlurk,
    selectel_iam_serviceuser_v1.serviceuser_1
  ]
}

#Создание подсети
resource "openstack_networking_subnet_v2" "subnet_1" {
  name       = "private-subnet"
  network_id = openstack_networking_network_v2.network_1.id
  cidr       = "192.168.200.0/24"
}