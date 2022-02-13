variable "folder_id" {
  description = "YC Folder Id. Will take value from the environment variable"
}

variable "aws_iam_user" {
  description = "AWS IAM user name"
  default = "s3sync-user"
}

variable "yc_sync_sa" {
  description = "YC IAM service account name"
  default = "s3sync-sa"
}

variable "yc_function_name" {
  description = "YC Cloud Function name"
  default = "aws-s3sync"
}

variable "aws_function_name" {
  description = "AWS Lambda Function name"
  default = "yc-s3sync"
}
