resource "aws_s3_bucket" "website_bucket" {
  bucket = "social-site-website-bucket"
  acl    = "public-read"
}

resource "aws_s3_bucket_object" "website_bucket_dist" {
  for_each = fileset("${path.module}/../client-app/dist/client-app", "*")

  bucket = aws_s3_bucket.website_bucket.bucket
  key    = each.value
  source = "${path.module}/../client-app/dist/client-app/${each.value}"
  etag   = filemd5("${path.module}/../client-app/dist/client-app/${each.value}")
}

resource "aws_s3_bucket_website_configuration" "website_bucket" {
  bucket = aws_s3_bucket.website_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_versioning" "website_bucket_versioning" {
  bucket = aws_s3_bucket.website_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
