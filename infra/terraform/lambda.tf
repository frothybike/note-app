variable "lambda_func1" {
  default = "func1"
}

variable "to_address" {
  type = string
}

variable "from_address" {
  type = string
}

data "archive_file" "func1" {
  type        = "zip"
  output_path = "../../backend/api/${var.lambda_func1}/${var.lambda_func1}.zip"
  source_file  = "../../backend/api/${var.lambda_func1}/${var.lambda_func1}.mjs"
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
  handler          = "send-mail-ses.handler"
  source_code_hash = base64sha256(data.archive_file.func1.output_path)
  runtime          = "nodejs22.x"
  s3_bucket        = aws_s3_bucket.send_mail_ses_src.id
  s3_key           = aws_s3_object.func1.key
  role             = data.aws_iam_role.func1_role.arn

  environment {
		variables = {
			FROM_ADDRESS = var.from_address
      TO_ADDRESS   = var.to_address
		}
	}
}

resource "aws_cloudwatch_log_group" "func1" {
  name              = "/aws/lambda/${var.lambda_func1}"
  retention_in_days = 3
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.func1.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.send_mail_api.execution_arn}/*"
}