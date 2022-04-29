data "archive_file" "account_lambda" {
  type = "zip"

  source_dir  = "../${path.module}/lambdas/account/build"
  output_path = "../${path.module}/lambdas/account/outputs/account_lambda.zip"
}

resource "aws_s3_bucket" "account_lambda_bucket" {
  bucket = "account-lambda"

  force_destroy = true
}

resource "aws_s3_object" "account_lambda" {
  bucket = aws_s3_bucket.account_lambda_bucket.id

  key    = "account-lambda.zip"
  source = data.archive_file.account_lambda.output_path

  etag = filemd5(data.archive_file.account_lambda.output_path)
}

resource "aws_lambda_function" "account_lambda" {
  function_name = "account-lambda"

  s3_bucket = aws_s3_bucket.account_lambda_bucket.id
  s3_key    = aws_s3_object.account_lambda.key

  runtime = "nodejs14.x"
  handler = "index.handler"

  source_code_hash = data.archive_file.account_lambda.output_base64sha256

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "hello_world" {
  name = "/aws/lambda/${aws_lambda_function.account_lambda.function_name}"

  retention_in_days = 30
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.lambda.name}"

  retention_in_days = 30
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.account_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}

