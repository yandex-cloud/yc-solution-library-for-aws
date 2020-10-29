resource "aws_lambda_function" "yandex_sync" {
  function_name    = "yandex_sync"
  role             = aws_iam_role.yandex_sync.arn
  handler          = "main.handler"

  source_code_hash = data.archive_file.function.output_path
  filename         = data.archive_file.function.output_path

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
