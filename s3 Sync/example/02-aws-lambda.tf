resource "aws_lambda_function" "yandex_sync" {
  function_name = var.aws_function_name
  role          = aws_iam_role.yandex_sync.arn
  handler       = "main.handler"

  source_code_hash = data.archive_file.function.output_base64sha256
  filename         = data.archive_file.function.output_path
  timeout          = 30

  runtime = "python3.7"

  environment {
    variables = {
      AMAZON_BUCKET            = aws_s3_bucket.aws_yc_sync.id
      AMAZON_ACCESS_KEY_ID     = aws_iam_access_key.yandex_sync.id
      AMAZON_SECRET_ACCESS_KEY = aws_iam_access_key.yandex_sync.secret
      YANDEX_BUCKET            = yandex_storage_bucket.aws_yc_sync.id
      YANDEX_ACCESS_KEY_ID     = yandex_iam_service_account_static_access_key.sa_static_key.access_key
      YANDEX_SECRET_ACCESS_KEY = yandex_iam_service_account_static_access_key.sa_static_key.secret_key
    }
  }
}


resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_${var.aws_function_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.yandex_sync.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.aws_yc_sync.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.aws_yc_sync.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.yandex_sync.arn
    events              = ["s3:ObjectCreated:*"]
  }
  depends_on = [aws_lambda_permission.allow_bucket]
}