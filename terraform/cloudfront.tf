module "cdn" {
  source = "cloudposse/cloudfront-s3-cdn/aws"

  origin_bucket = aws_s3_bucket.website_bucket.id
}
