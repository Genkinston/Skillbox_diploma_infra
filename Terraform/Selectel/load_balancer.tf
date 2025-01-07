#Создать облачный балансировщик нагрузки

resource "openstack_lb_loadbalancer_v2" "load_balancer_1" {
  name          = "load-balancer"
  vip_subnet_id = openstack_networking_subnet_v2.subnet_1.id
  flavor_id     = "3265f75f-01eb-456d-9088-44b813d29a60"
}

#Создать правило⁠ http

resource "openstack_lb_listener_v2" "listener_1" {
  name            = "listener"
  protocol        = "HTTP"
  protocol_port   = "80"
  loadbalancer_id = openstack_lb_loadbalancer_v2.load_balancer_1.id
}

#Создать правило⁠ http

resource "openstack_lb_listener_v2" "listener_2" {
  name            = "listener_ssh"
  protocol        = "TCP"
  protocol_port   = "22"
  loadbalancer_id = openstack_lb_loadbalancer_v2.load_balancer_1.id
  admin_state_up = true
}

#Создать целевую группу⁠

resource "openstack_lb_pool_v2" "pool_1" {
  name        = "pool"
  protocol    = "HTTP"
  lb_method   = "ROUND_ROBIN"
  listener_id = openstack_lb_listener_v2.listener_1.id
}

resource "openstack_lb_pool_v2" "pool_ssh" {
  name        = "pool_ssh"
  protocol    = "TCP"
  lb_method   = "ROUND_ROBIN"
  listener_id = openstack_lb_listener_v2.listener_2.id
}

#Добавить сервер в целевую группу http

resource "openstack_lb_member_v2" "member_1" {
  name          = "member"
  subnet_id     = openstack_networking_subnet_v2.subnet_1.id
  pool_id       = openstack_lb_pool_v2.pool_1.id
  address       = openstack_compute_instance_v2.server_1.network[0].fixed_ip_v4
  protocol_port = "8080"
}

resource "openstack_lb_member_v2" "member_ssh" {
  name          = "member_ssh"
  subnet_id     = openstack_networking_subnet_v2.subnet_1.id
  pool_id       = openstack_lb_pool_v2.pool_ssh.id
  address       = openstack_compute_instance_v2.server_1.network[0].fixed_ip_v4
  protocol_port = "22"
}

#Создать проверку доступности⁠ http

resource "openstack_lb_monitor_v2" "monitor_1" {
  name        = "monitor"
  pool_id     = openstack_lb_pool_v2.pool_1.id
  type        = "HTTP"
  delay       = "10"
  timeout     = "4"
  max_retries = "5"
}

