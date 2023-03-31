module "certificate" {
  source = "./certificate"

  count   = var.create_ssl_certificate ? 1 : 0
  fqdn    = var.fqdn
  zone_id = data.aws_route53_zone.main.zone_id
  aliases = local.aliases

  providers = {
    aws.cloudfront = aws.cloudfront
    aws.dns = aws.dns
  }
}
