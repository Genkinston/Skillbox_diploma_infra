#Получение образа

data "openstack_images_image_v2" "image_1" {
  name        = "Ubuntu 22.04 LTS 64-bit"
  most_recent = true
  visibility  = "public"

  depends_on = [
    selectel_vpc_project_v2.project_genkinstonlurk,
    selectel_iam_serviceuser_v1.serviceuser_1
  ]
}

#Создание загрузочного сетевого диска

resource "openstack_blockstorage_volume_v3" "volume_1" {
  name                 = "boot-volume-for-server"
  size                 = "5"
  image_id             = data.openstack_images_image_v2.image_1.id
  volume_type          = "basic.ru-9a"
  availability_zone    = "ru-9a"
  enable_online_resize = true

  lifecycle {
    ignore_changes = [image_id]
  }
}

#Создание облачного сервера

resource "openstack_compute_instance_v2" "server_1" {
  name              = "server"
  flavor_id         = "1"
  key_pair          = selectel_vpc_keypair_v2.keypair_1.name
  availability_zone = "ru-9a"

  network {
    port = openstack_networking_port_v2.port_1.id
    #name = openstack_networking_network_v2.network_1.name
    #fixed_ip_v4 = "192.168.200.4"
  }

  network {
    port = openstack_networking_port_v2.port_ssh.id
  }

  lifecycle {
    ignore_changes = [image_id]
  }

  block_device {
    uuid             = openstack_blockstorage_volume_v3.volume_1.id
    source_type      = "volume"
    destination_type = "volume"
    boot_index       = 0
  }

  vendor_options {
    ignore_resize_confirmation = true
  }
}