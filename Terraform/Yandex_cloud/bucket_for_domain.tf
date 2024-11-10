resource "yandex_object_storage_bucket" "domain_bucket" {
 name = "genkinstonlurk"
 description = "Bucket for genkinstonlurk.ru"

 access_control {
 default_action = "ALLOW"
 rules {
 rule {
 action = "ALLOW"
 resource = "*"
 }
 }
 }
}