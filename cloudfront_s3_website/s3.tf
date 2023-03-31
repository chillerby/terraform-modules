module "s3" {
  source = "./s3"

  count                       = var.create_s3_origin ? 1 : 0
  fqdn                        = var.fqdn
  tags                        = var.tags
  provide_bucket_policy       = var.provide_bucket_policy
  bucket_policy               = var.bucket_policy
  force_destroy               = var.force_destroy
  index_document              = var.index_document
  cloudfront_distribution_arn = aws_cloudfront_distribution.main.arn

  providers = {
    aws.main = aws.main
  }
}
