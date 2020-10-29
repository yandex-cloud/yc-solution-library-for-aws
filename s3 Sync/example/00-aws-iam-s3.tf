resource "aws_iam_user" "yandex_sync" {
    name = "yandex_sync"
}


resource "aws_iam_access_key" "yandex_sync" {
  user = aws_iam_user.yandex_sync.name
}

resource "aws_iam_user_policy_attachment" "yandex_sync" {
  user = aws_iam_user.yandex_sync.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role" "yandex_sync" {
  name = "yandex_sync"

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
resource "aws_iam_policy" "yandex_sync" {
  name        = "yandex_sync"
  path        = "/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:*"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "yandex_sync" {
  role       = aws_iam_role.yandex_sync.name
  policy_arn = aws_iam_policy.yandex_sync.arn
}

resource "aws_s3_bucket" "aws_yc_sync" {
  bucket = "yc-s3-sync-${random_string.project_suffix.result}"
  acl    = "private"

}

resource "aws_s3_bucket" "aws_lambda" {
  bucket = "yc-s3-lambda-${random_string.project_suffix.result}"
  acl    = "private"

}