variable "fqdn" {
  type        = string
  description = "The FQDN of the website and also name of the S3 bucket"
}

variable "zone_id" {
  type        = string
  description = "The zone ID of the zone that will contain the validation records"
}

variable "aliases" {
  type        = list(string)
  description = "list of domains the certificate should cover, limit of 10"
}
