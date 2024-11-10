variable "folder_id" {
  description = "Yandex.Cloud Folder ID where resources will be created"
  default     = "b1ghj3gm3a5ud4i8h84n"
}

resource "yandex_compute_instance_group" "ig-1" {
  name               = "nlb-vm-group"
  folder_id          = var.folder_id
  service_account_id = "ajen93iok4b9hqcqbtm6"
  instance_template {
    platform_id = "standard-v3"
    resources {
      core_fraction = 20
      memory        = 1
      cores         = 2
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd83b9pkhhr6m7tegqjm"
        type     = "network-hdd"
        size     = 3
      }
    }

    network_interface {
      network_id = "${yandex_vpc_network.default.id}"
      subnet_ids = ["${yandex_vpc_subnet.subnet-1.id}"]
      nat        = true
    }


    metadata = {
      user-data = "#cloud-config\nusers:\n  - name: ubuntu\n    groups: sudo\n    shell: /bin/bash\n    sudo: 'ALL=(ALL) NOPASSWD:ALL'\n    ssh-authorized-keys:\n      - ${file("~/.ssh/yacloud.pub")}"
    }
  }

  scale_policy {
    fixed_scale {
      size = 2
    }
  }

  allocation_policy {
    zones = ["ru-central1-a"]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

  load_balancer {
    target_group_name = "nlb-tg"
  }
}



resource "yandex_lb_network_load_balancer" "foo" {
  name = "nlb-1"
  listener {
    name = "nlb-listener"
    port = 80
  }
  attached_target_group {
    target_group_id = "${yandex_compute_instance_group.ig-1.load_balancer.0.target_group_id}"
    healthcheck {
      name                = "health-check-1"
      unhealthy_threshold = 5
      healthy_threshold   = 5
      http_options {
        port = 80
      }
    }
  }
}
