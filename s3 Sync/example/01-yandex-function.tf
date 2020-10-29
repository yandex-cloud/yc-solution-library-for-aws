data "archive_file" "function" {
  type        = "zip"
  source_dir  = "${path.module}/function"
  output_path = "${path.module}/sync.zip"
}


resource "yandex_function" "s3_sync" {
  name               = "s3-sync"
  runtime            = "python37"
  entrypoint         = "main.handler"
  memory             = "256"
  execution_timeout  = "10"
  user_hash = filebase64sha256("${path.module}/function/main.py")
  environment = {
      AWS_BUCKET = aws_s3_bucket.aws_yc_sync.id 
      AWS_ACCESS_KEY_ID = aws_iam_access_key.yandex_sync.id
      AWS_SECRET_ACCESS_KEY = aws_iam_access_key.yandex_sync.secret
      YANDEX_BUCKET = yandex_storage_bucket.aws_yc_sync.id
      YANDEX_ACCESS_KEY_ID = yandex_iam_service_account_static_access_key.sa_static_key.access_key
      YANDEX_SECRET_ACCESS_KEY = yandex_iam_service_account_static_access_key.sa_static_key.secret_key
  }
  content {
    zip_filename = "sync.zip"
  }
}

resource "yandex_function_trigger" "s3_sync" {
  name        = "s3-sync"
  description = "any description"
  

  function {
    id =  yandex_function.s3_sync.id 
    service_account_id = yandex_iam_service_account.s3_sync_sa.id

  }
  object_storage {
      bucket_id = yandex_storage_bucket.aws_yc_sync.id
      create = true
      update = true
      delete = true
  }
}