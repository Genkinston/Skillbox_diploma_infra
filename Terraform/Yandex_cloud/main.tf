terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone = "ru-central1-a" # Зона доступности по умолчанию
  service_account_key_file = "/home/lurk/.config/yandex-cloud/authorized_key.json"
  folder_id = "b1ghj3gm3a5ud4i8h84n"
}