resource "aws_s3_bucket" "website_bucket" {
  bucket = "website-bucket"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_s3_object" "website_bucket_dist" {
  for_each = fileset("${path.module}/../client-app/dist/client-app", "*")

  bucket = aws_s3_bucket.website_bucket.id
  key    = each.value
  source = "${path.module}/../client-app/dist/client-app/${each.value}"
  etag   = filemd5("${path.module}/../client-app/dist/client-app/${each.value}")
}
