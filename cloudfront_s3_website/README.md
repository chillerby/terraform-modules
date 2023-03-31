# Terraform module to setup a S3 Website with CloudFront, ACM

This module helps you create a S3 website, assuming that:

* it runs HTTPS via Amazon's Certificate Manager ("ACM")
* its domain is backed by a Route53 zone
* and of course, your AWS account provides you access to all these resources necessary.

## Sample Usage

You can literally copy and paste the following example, change the following attributes, and you're ready to go:

* `fqdn` set to your static website's hostname
* `provide_bucket_policy` (default: false) if the user would like to provide their own bucket policy in case they need to deploy to the bucket from another account
* `bucket_policy` only set if `provide_bucket_policy` is true, only set if you understand bucket policy permissions


```hcl
# AWS Region for S3 and other resources
provider "aws" {
  region = "us-west-2"
  alias = "main"
}

# AWS Region for Cloudfront (ACM certs only supports us-east-1)
provider "aws" {
  region = "us-east-1"
  alias = "cloudfront"
}

# Variables
variable "fqdn" {
  description = "The fully-qualified domain name root of the resulting S3 website."
  default     = "example.com"
}

variable "redirect_target" {
  description = "The fully-qualified domain name to redirect to."
  default     = "www.example.com"
}

# Using this module
module "main" {
  source = "git::ssh://git@github.com/chillerby/terraform-modules.git//cloudfront_s3_website?ref=main"

  fqdn = var.fqdn
  redirect_target = var.redirect_target
  ssl_certificate_arn = aws_acm_certificate_validation.cert.certificate_arn

  force_destroy = "true"

  providers = {
    aws.main = aws.main
    aws.cloudfront = aws.cloudfront
  }

  # Optional WAF Web ACL ID, defaults to none.
  web_acl_id = data.terraform_remote_state.site.waf-web-acl-id
}

# Route 53 record for the static site

data "aws_route53_zone" "main" {
  provider     = "aws.main"
  name         = "${var.fqdn}"
  private_zone = false
}

resource "aws_route53_record" "web" {
  provider = "aws.main"
  zone_id  = "${data.aws_route53_zone.main.zone_id}"
  name     = "${var.fqdn}"
  type     = "A"

  alias {
    name    = "${module.main.cf_domain_name}"
    zone_id = "${module.main.cf_hosted_zone_id}"
    evaluate_target_health = false
  }
}

# Outputs

output "s3_bucket_id" {
  value = "${module.main.s3_bucket_id}"
}

output "s3_domain" {
  value = "${module.main.s3_website_endpoint}"
}

output "s3_hosted_zone_id" {
  value = "${module.main.s3_hosted_zone_id}"
}

output "cloudfront_domain" {
  value = "${module.main.cf_domain_name}"
}

output "cloudfront_hosted_zone_id" {
  value = "${module.main.cf_hosted_zone_id}"
}

output "cloudfront_distribution_id" {
  value = "${module.main.cf_distribution_id}"
}

output "route53_fqdn" {
  value = "${aws_route53_record.web.fqdn}"
}

```
