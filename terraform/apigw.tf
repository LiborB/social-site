#resource "aws_apigatewayv2_deployment" "lambda" {
#  api_id = aws_apigatewayv2_api.lambda.id
#
#  lifecycle {
#    create_before_destroy = true
#  }
#
#  depends_on = [
#    aws_apigatewayv2_route.account_lambda
#  ]
#}

resource "aws_apigatewayv2_api" "lambda" {
  name          = "serverless_lambda_gw"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "lambda" {
  api_id = aws_apigatewayv2_api.lambda.id

  name          = "v1"
  deployment_id = "initial"

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

resource "aws_apigatewayv2_route" "account_lambda" {
  api_id = aws_apigatewayv2_api.lambda.id

  route_key = "ANY /account"
  target    = "integrations/${aws_apigatewayv2_integration.account_lambda.id}"
}

resource "aws_apigatewayv2_integration" "account_lambda" {
  api_id = aws_apigatewayv2_api.lambda.id

  integration_uri    = aws_lambda_function.account_lambda.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}
