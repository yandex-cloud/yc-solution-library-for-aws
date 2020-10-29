resource "aws_lambda_function" "yandex_sync" {
  filename      = "${path.module}/sync.zip"
  function_name = "yandex_sync"
  role          = aws_iam_role.yandex_sync.arn
  handler       = "main.handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("${path.module}/function/main.py")

  runtime = "python3.7"

  environment {
    variables = {
      AWS_BUCKET = aws_s3_bucket.aws_yc_sync.id 
      YANDEX_BUCKET = yandex_storage_bucket.aws_yc_sync.id
      YANDEX_ACCESS_KEY_ID = yandex_iam_service_account_static_access_key.sa_static_key.access_key
      YANDEX_SECRET_ACCESS_KEY = yandex_iam_service_account_static_access_key.sa_static_key.secret_key
    }
  }
}