module "cdn" {
  source  = "cloudposse/cloudfront-s3-cdn/aws"
  version = "0.82.4"

  origin_bucket = aws_s3_bucket.website_bucket.id
}
