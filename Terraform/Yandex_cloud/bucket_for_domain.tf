resource "yandex_storage_bucket" "domain_bucket" {
    bucket = "genkinstonlurk.ru"
    acl    = "public-read"

}

