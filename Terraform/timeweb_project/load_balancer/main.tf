terraform {
  required_providers {
    twc = {
      source = "tf.timeweb.cloud/timeweb-cloud/timeweb-cloud"
    }
  }
  required_version = ">= 1.4.4"
}

provider "twc" {
  token = "${var.TWC_KEY}"
}

resource "twc_ssh_key" "twcvm" {
  name = "twcvm"
  body = file("~/.ssh/twcvm.pub")
}

resource "timeweb_dns_record" "example" {
  domain = "genkinstonlurk.ru"
  name   = "www"
  type   = "A"
  value  = timeweb_instance.example.public_ip
}

# Create new Project
resource "twc_project" "Skillbox_DevOps_Project" {
  name        = "Skillbox_DevOps_Project"
  description = "Skillbox_DevOps_Project description"
}
