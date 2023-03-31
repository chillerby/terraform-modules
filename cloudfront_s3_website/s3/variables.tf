variable "fqdn" {
  type        = string
  description = "The FQDN of the website and also name of the S3 bucket"
}

variable "tags" {
  type        = map(string)
  description = "Tags"
  default     = {}
}

variable "provide_bucket_policy" {
  default = false
}

variable "bucket_policy" {
  default = ""
}

variable "force_destroy" {
  type        = string
  description = "The force_destroy argument of the S3 bucket"
  default     = "false"
}

variable "index_document" {
  default = "index.html"
}

variable "cloudfront_distribution_arn" {
}
