variable "lambda_func1" {
  default = "func1"
}

data "archive_file" "func1" {
  type        = "zip"
  output_path = "../api/${var.lambda_func1}/src.zip"
  source_dir  = "../api/${var.lambda_func1}"
  excludes    = ["../api/${var.lambda_func1}/tests"]
}

data "aws_iam_role" "func1_role" {
  name = "LambdaSESMailRole"
}

resource "aws_s3_object" "func1" {
  bucket = aws_s3_bucket.send_mail_ses_src.id
  key    = "${var.lambda_func1}.zip"
  source = data.archive_file.func1.output_path
}

resource "aws_lambda_function" "func1" {
  function_name    = var.lambda_func1
  handler          = "src.app.lambda_handler"
  source_code_hash = base64sha256(data.archive_file.func1.output_path)
  runtime          = "nodejs22.x"
  s3_bucket        = aws_s3_bucket.api.id
  s3_key           = aws_s3_object.func1.key
  role             = data.aws_iam_role.func1_role
}

resource "aws_cloudwatch_log_group" "func1" {
  name              = "/aws/lambda/${var.lambda_func1}"
  retention_in_days = 3
}