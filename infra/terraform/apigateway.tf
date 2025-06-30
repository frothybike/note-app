# resource "aws_api_gateway_rest_api" "send_mail_api" {
#   name = "SendMailAPI"
#   description = "Send Mail API"
# }

# resource "aws_api_gateway_resource" "send_mail_api_resource" {
#   rest_api_id = aws_api_gateway_rest_api.send_mail_api.id
#   parent_id   = aws_api_gateway_rest_api.send_mail_api.root_resource_id
#   path_part   = "send"
# }

# resource "aws_api_gateway_method" "send_mail_api_get" {
#   rest_api_id   = aws_api_gateway_rest_api.send_mail_api.id
#   resource_id   = aws_api_gateway_resource.send_mail_api_resource.id
#   http_method   = "POST"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_integration" "send_mail_api_get" {
#   rest_api_id   = aws_api_gateway_rest_api.send_mail_api.id
#   resource_id   = aws_api_gateway_resource.send_mail_api_resource.id
#   http_method   = aws_api_gateway_method.send_mail_api_get.http_method

#   integration_http_method = "POST"
#   type                    = "AWS"
#   uri                     = aws_lambda_function.func1.invoke_arn

#   request_templates = {
#     "application/json" = <<EOF
# {
#     "form": {
#         "subject":  "$util.escapeJavaScript($input.path('$.subject'))",
#         "email":  "$util.escapeJavaScript($input.path('$.email'))",
#         "body":  "$util.escapeJavaScript($input.path('$.body'))"
#     }
# }
# EOF
#   }
# }

# resource "aws_api_gateway_deployment" "send_mail_api" {
#   depends_on = [
#     "aws_api_gateway_integration.send_mail_api_get",
#   ]

#   rest_api_id = aws_api_gateway_rest_api.send_mail_api.id
#   stage_name  = "v1"
# }



# resource "aws_api_gateway_method_response" "post_response" {
#   rest_api_id = aws_api_gateway_rest_api.send_mail_api.id
#   resource_id = aws_api_gateway_resource.send_mail_api_resource.id
#   http_method = aws_api_gateway_method.send_mail_api_get.http_method
#   status_code = "200"

#   response_models = {
#     "application/json" = "Empty"
#   }

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Origin"  = true
#     "method.response.header.Access-Control-Allow-Methods" = true
#     "method.response.header.Access-Control-Allow-Headers" = true
#   }
# }

# resource "aws_api_gateway_integration_response" "post_response" {
#   rest_api_id   = aws_api_gateway_rest_api.send_mail_api.id
#   resource_id   = aws_api_gateway_resource.send_mail_api_resource.id
#   http_method   = aws_api_gateway_method.send_mail_api_get.http_method
#   status_code   = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Origin"  = "'https://www.namabanana.com'"
#     "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS'"
#     "method.response.header.Access-Control-Allow-Headers" = "'Content-Type'"
#   }

#   depends_on = [
#     aws_api_gateway_integration.send_mail_api_get,
#     aws_api_gateway_method_response.post_response
#   ]
# }

# resource "aws_api_gateway_integration" "options_integration" {
#   rest_api_id   = aws_api_gateway_rest_api.send_mail_api.id
#   resource_id   = aws_api_gateway_resource.send_mail_api_resource.id
#   http_method = "OPTIONS"
#   type        = "MOCK"

#   request_templates = {
#     "application/json" = <<EOF
# {
#   "statusCode": 200
# }
# EOF
#   }
# }

# resource "aws_api_gateway_integration_response" "options_response" {
#   rest_api_id   = aws_api_gateway_rest_api.send_mail_api.id
#   resource_id   = aws_api_gateway_resource.send_mail_api_resource.id
#   http_method = "OPTIONS"
#   status_code = "200"

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Origin"  = "'https://www.namabanana.com'"
#     "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS'"
#     "method.response.header.Access-Control-Allow-Headers" = "'Content-Type'"
#   }
# }

# resource "aws_api_gateway_method_response" "options_response" {
#   rest_api_id   = aws_api_gateway_rest_api.send_mail_api.id
#   resource_id   = aws_api_gateway_resource.send_mail_api_resource.id
#   http_method = "OPTIONS"
#   status_code = "200"

#   response_models = {
#     "application/json" = "Empty"
#   }

#   response_parameters = {
#     "method.response.header.Access-Control-Allow-Origin"  = true
#     "method.response.header.Access-Control-Allow-Methods" = true
#     "method.response.header.Access-Control-Allow-Headers" = true
#   }
# }
