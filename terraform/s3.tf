resource "aws_s3_bucket" "website_bucket" {
  bucket = "website-bucket"
  acl = "private"
}

resource "aws_s3_bucket_object" "website_bucket_dist" {
  for_each = fileset("${path.module}/../frontend/client-app/dist/client-app", "*")

  bucket = "website-bucket"
  key    = each.value
  source = "${path.module}/../frontend/client-app/dist/client-app/${each.value}"
  etag   = filemd5("${path.module}/../frontend/client-app/dist/client-app/${each.value}")
}
