variable "fqdn" {
  type        = string
  description = "The FQDN of the website and also name of the S3 bucket"
}

variable "force_destroy" {
  type        = string
  description = "The force_destroy argument of the S3 bucket"
  default     = "false"
}

variable "ssl_certificate_arn" {
  type        = string
  description = "ARN of the certificate covering var.fqdn"
  default = ""
}

variable "web_acl_id" {
  type        = string
  description = "WAF Web ACL ID to attach to the CloudFront distribution, optional"
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "Tags"
  default     = {}
}

variable "aliases" {
  type = list(string)
  default = []
}

variable "provide_bucket_policy" {
  default = false
}

variable "bucket_policy" {
  default = ""
}

variable "viewer_protocol_policy" {
  default = "redirect-to-https"
}

variable "minimum_protocol_version" {
  default = "TLSv1.2_2021"
}

variable "zone_domain" {
  default = ""
}

variable "create_primary_record" {
  default = false
}

variable "create_ssl_certificate" {
  default = false
}

variable "create_s3_origin" {
  default = false
}

variable "s3_bucket_name" {
  default = ""
}

variable "s3_bucket_region" {
  default = "us-east-1"
}

variable "index_document" {
  default = "index.html"
}

variable "make_distribution_private" {
  default = "false"
}

variable "response_headers_policy_id" {
  default = ""
}
