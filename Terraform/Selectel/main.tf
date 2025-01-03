terraform {
  required_providers {
    selectel = {
      source  = "selectel/selectel"
      version = "6.0.0"
    }
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "2.1.0"
    }
  }
}

#Инициализация провайдера
provider "selectel" {
  domain_name = var.selectel_account
  username    = var.service_admin_username
  password    = var.service_admin_password
  auth_region = "pool"
  auth_url    = "https://cloud.api.selcloud.ru/identity/v3/"
}

#Создаёт проект
resource "selectel_vpc_project_v2" "project_1" {
  name = "Skillbox_devops_project_1"
  custom_url = "geninstonlurk.selvpc.ru"
}

#Создаёт сервисного пользователя проекта
resource "selectel_iam_serviceuser_v1" "serviceuser_1" {
  name     = var.service_project_username
  password = var.service_project_password
  role {
    role_name  = "member"
    scope      = "project"
    project_id = selectel_vpc_project_v2.project_1.id
  }
}

#Инициализирует провайдер OpenStack
provider "openstack" {
  auth_url    = "https://cloud.api.selcloud.ru/identity/v3"
  domain_name = var.selectel_account
  tenant_id   = selectel_vpc_project_v2.project_1.id
  user_name   = selectel_iam_serviceuser_v1.serviceuser_1.name
  password    = selectel_iam_serviceuser_v1.serviceuser_1.password
  region      = "ru-9"
}

