#Описание доменной зоны

resource "selectel_domains_zone_v2" "zone_1" {
  name       = "genkinstonlurk.ru."
  project_id = selectel_vpc_project_v2.project_genkinstonlurk.id
}

#Создать ресурсные записи⁠

resource "selectel_domains_rrset_v2" "a_rrset_1" {
  zone_id    = selectel_domains_zone_v2.zone_1.id
  name       = selectel_domains_zone_v2.zone_1.name
  type       = "A"
  ttl        = 60
  project_id = selectel_vpc_project_v2.project_genkinstonlurk.id
  records {
    content = openstack_networking_floatingip_v2.floatingip_1.address
  }
}
