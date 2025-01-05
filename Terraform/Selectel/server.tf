#Создать флейвор с сетевым диском
resource "openstack_compute_flavor_v2" "flavor_1" {
  name      = "custom-flavor-with-network-volume"
  vcpus     = 2
  ram       = 2048
  disk      = 0
  is_public = false

  lifecycle {
    create_before_destroy = true
  }
}

#Получение образа

data "openstack_images_image_v2" "image_1" {
  name        = "Ubuntu 24.04 LTS 64-bit"
  most_recent = true
  visibility  = "public"
  container_format = "bare"
  disk_format      = "qcow2"

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
  volume_type          = "fast.ru-9a"
  availability_zone    = "ru-9a"
  enable_online_resize = true

  lifecycle {
    ignore_changes = [image_id]
  }
}

#Создание облачного сервера

resource "openstack_compute_instance_v2" "server_1" {
  name              = "server"
  flavor_id         = openstack_compute_flavor_v2.flavor_1.id
  key_pair          = selectel_vpc_keypair_v2.keypair_1.name
  availability_zone = "ru-9a"

  network {
    port = openstack_networking_port_v2.port_1.id
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