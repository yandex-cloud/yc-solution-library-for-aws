resource "aws_lambda_function" "yandex_sync" {
  function_name    = "yandex_sync"
  role             = aws_iam_role.yandex_sync.arn
  handler          = "main.handler"

  source_code_hash = data.archive_file.function.output_base64sha256
  filename         = data.archive_file.function.output_path
  timeout          = 30

  runtime = "python3.7"

  environment {
    variables = {
      AMAZON_BUCKET = aws_s3_bucket.aws_yc_sync.id
      AMAZON_ACCESS_KEY_ID = aws_iam_access_key.yandex_sync.id
      AMAZON_SECRET_ACCESS_KEY = aws_iam_access_key.yandex_sync.secret 
      YANDEX_BUCKET = yandex_storage_bucket.aws_yc_sync.id
      YANDEX_ACCESS_KEY_ID = yandex_iam_service_account_static_access_key.sa_static_key.access_key
      YANDEX_SECRET_ACCESS_KEY = yandex_iam_service_account_static_access_key.sa_static_key.secret_key
    }
  }
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.aws_yc_sync.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.yandex_sync.arn
    events              = ["s3:ObjectCreated:*"]
  }
}