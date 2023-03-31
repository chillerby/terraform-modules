output "s3_bucket_website_endpoint" {
  value = aws_s3_bucket_website_configuration.main.website_endpoint
}

output "s3_bucket_name" {
  value = aws_s3_bucket.main.bucket
}

