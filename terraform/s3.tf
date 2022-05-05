resource "aws_s3_bucket" "website_bucket" {
  bucket = "website-bucket"
}

resource "aws_s3_object" "website_bucket_dist" {
  for_each = fileset("${path.module}/../client-app/dist/client-app", "*")

  bucket = aws_s3_bucket.website_bucket.id
  key    = each.value
  source = "${path.module}/../client-app/dist/client-app/${each.value}"
  etag   = filemd5("${path.module}/../client-app/dist/client-app/${each.value}")
}

resource "aws_s3_bucket_website_configuration" "website_bucket" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
