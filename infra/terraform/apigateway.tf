resource "aws_api_gateway_rest_api" "send_mail_api" {
  name = "SendMailAPI"
  description = "Send Mail API"
}

resource "aws_api_gateway_resource" "send_mail_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.send_mail_api.id
  parent_id   = aws_api_gateway_rest_api.send_mail_api.root_resource_id
  path_part   = "send"
}

resource "aws_api_gateway_method" "send_mail_api_get" {
  rest_api_id   = aws_api_gateway_rest_api.send_mail_api.id
  resource_id   = aws_api_gateway_resource.send_mail_api_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "send_mail_api_get" {
  rest_api_id   = aws_api_gateway_rest_api.send_mail_api.id
  resource_id   = aws_api_gateway_resource.send_mail_api_resource.id
  http_method   = aws_api_gateway_method.send_mail_api_get.http_method

  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.func1.invoke_arn
}

resource "aws_api_gateway_deployment" "send_mail_api" {
  depends_on = [
    "aws_api_gateway_integration.send_mail_api_get",
  ]

  rest_api_id = aws_api_gateway_rest_api.send_mail_api.id
  stage_name  = "v1"
}