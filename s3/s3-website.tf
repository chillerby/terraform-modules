resource "aws_s3_bucket" "main" {
  provider = aws.main
  bucket   = var.fqdn

  force_destroy = var.force_destroy

  tags = merge(
    var.tags,
    {
      "Name" = var.fqdn
    },
  )
}

resource "aws_s3_bucket_website_configuration" "main" {
  bucket = aws_s3_bucket.main.bucket

  index_document {
    suffix = var.index_document
  }
}

locals {
  bucket_policy = <<EOP
{
    "Version": "2012-10-17",
    "Statement": {
        "Sid": "AllowCloudFrontServicePrincipalReadOnly",
        "Effect": "Allow",
        "Principal": {
            "Service": "cloudfront.amazonaws.com"
        },
        "Action": "s3:GetObject",
        "Resource": "${aws_s3_bucket.main.arn}/*",
        "Condition": {
            "StringEquals": {
                "AWS:SourceArn": "${var.cloudfront_distribution_arn}"
            }
        }
    }
}
EOP
}


resource "aws_s3_bucket_policy" "static_website" {
  provider = aws.main
  bucket   = aws_s3_bucket.main.id

  policy = var.provide_bucket_policy ? var.bucket_policy : local.bucket_policy
}
