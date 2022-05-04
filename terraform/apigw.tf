resource "aws_apigatewayv2_deployment" "lambda" {
  api_id = aws_apigatewayv2_api.lambda[count.index].id

  depends_on = [
    aws_apigatewayv2_route.account_lambda
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_apigatewayv2_api" "lambda" {
  name          = "serverless_lambda_gw"
  protocol_type = "HTTP"

  count = 1
}

resource "aws_apigatewayv2_stage" "lambda" {
  api_id = aws_apigatewayv2_api.lambda[count.index].id

  name          = "v1"
  deployment_id = aws_apigatewayv2_deployment.lambda.id

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
  api_id = aws_apigatewayv2_api.lambda[count.index].id

  route_key = "ANY /account"
  target    = "integrations/${aws_apigatewayv2_integration.account_lambda.id}"
}

resource "aws_apigatewayv2_integration" "account_lambda" {
  api_id = aws_apigatewayv2_api.lambda[count.index].id

  integration_uri    = aws_lambda_function.account_lambda.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}
