terraform {
  required_providers {
    selectel = {
      source  = "selectel/selectel"
      version = "5.4.0"
    }
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "2.0.0"
    }
  }
}

provider "selectel" {
  domain_name = "account_id"
  username    = "Terraform"
  password    = "password"
  auth_region = "ru-2"
  auth_url    = "https://cloud.api.selcloud.ru/identity/v3/"
}

resource "selectel_vpc_project_v2" "project_1" {
  name = "name" #Наименование проекта который вы импортировали
}

resource "selectel_iam_serviceuser_v1" "serviceuser_1" {
  name     = "Terraform"
  password = "password" #Наименование сервисного пользователя и пароль
   role {
     role_name  = "iam_admin"
     scope      = "account"
    }
   role {
     role_name  = "member"
     scope      = "account"
    }
   role {
     project_id = "uuid" #Вставьте uuid проекта, либо переменную
     role_name  = "member"
     scope      = "project"
    }
}

provider "openstack" {
  auth_url    = "https://cloud.api.selcloud.ru/identity/v3"
  domain_name = "account_id"
  tenant_id   = selectel_vpc_project_v2.project_1.id
  user_name   = selectel_iam_serviceuser_v1.serviceuser_1.name
  password    = selectel_iam_serviceuser_v1.serviceuser_1.password
  region      = "ru-2"
}


resource "openstack_networking_network_v2" "DUDE" {
  name           = "private-network"
  admin_state_up = "true"
  depends_on = [
    selectel_vpc_project_v2.project_1,
    selectel_iam_serviceuser_v1.serviceuser_1
  ]
}

