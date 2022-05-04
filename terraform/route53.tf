resource "aws_apigatewayv2_domain_name" "lambdas" {
  domain_name = "libor.example.com"

  domain_name_configuration {
    certificate_arn = aws_acm_certificate
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_route53_record" "example" {
  name    = aws_apigatewayv2_domain_name.lambdas.domain_name
  type    = "A"
  zone_id = aws_route53_zone.primary.zone_id

  alias {
    name                   = aws_apigatewayv2_domain_name.lambdas.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.lambdas.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "example.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_zone" "primary" {
  name = "example.com"
}
