resource "aws_route53_record" "main" {
  count           = var.create_primary_record ? 1 : 0
  provider        = aws.dns
  zone_id         = data.aws_route53_zone.main.zone_id
  name            = var.fqdn
  type            = "A"
  allow_overwrite = true

  alias {
    name    = aws_cloudfront_distribution.main.domain_name
    zone_id = aws_cloudfront_distribution.main.hosted_zone_id
    evaluate_target_health = false
  }
}
