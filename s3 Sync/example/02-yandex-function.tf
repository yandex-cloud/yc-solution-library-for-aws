resource "yandex_function" "s3_sync" {
  name               = "s3-sync"
  runtime            = "python38"
  entrypoint         = "main.handler"
  memory             = "256"
  execution_timeout  = "30"

  environment = {
      AMAZON_BUCKET = aws_s3_bucket.aws_yc_sync.id
      AMAZON_ACCESS_KEY_ID = aws_iam_access_key.yandex_sync.id
      AMAZON_SECRET_ACCESS_KEY = aws_iam_access_key.yandex_sync.secret
      YANDEX_BUCKET = yandex_storage_bucket.aws_yc_sync.id
      YANDEX_ACCESS_KEY_ID = yandex_iam_service_account_static_access_key.sa_static_key.access_key
      YANDEX_SECRET_ACCESS_KEY = yandex_iam_service_account_static_access_key.sa_static_key.secret_key
  }

  user_hash = data.archive_file.function.output_base64sha256
  content {
    zip_filename = data.archive_file.function.output_path
  }
}

resource "yandex_function_trigger" "s3_sync" {
  name        = "s3-sync"
  
  function {
    id = yandex_function.s3_sync.id 
    service_account_id = yandex_iam_service_account.s3_sync_sa.id
  }

  object_storage {
      bucket_id = yandex_storage_bucket.aws_yc_sync.id
      create = true
      update = false
      delete = false
  }
}

 