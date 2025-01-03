#Описание доменной зоны
resource "selectel_domains_zone_v2" "zone_1" {
  name       = "genkinstonlurk.ru."
  project_id = selectel_vpc_project_v2.project_1.id
}