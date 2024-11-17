resource "yandex_storage_bucket" "domain_bucket" {
    bucket = "genkinstonlurk.ru"
    bucket_domain_name = "genkinstonlurk.ru"
    acl    = "public-read"

    website {
      index_document = "balancernginx.genkinstonlurk.ru/index.html"
    }
}

