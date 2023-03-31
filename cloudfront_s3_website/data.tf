locals {
  zone_domain = var.zone_domain != "" ? var.zone_domain : var.fqdn
}

data "aws_region" "main" {
  provider = aws.main
}

data "aws_route53_zone" "main" {
  provider     = aws.dns
  name         = local.zone_domain
  private_zone = false
}

data "aws_wafv2_web_acl" "private" {
  provider = aws.cloudfront
  name  = "cloudfront-block-external-ips"
  scope = "CLOUDFRONT"
}
