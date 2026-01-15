locals {
    apex_domain = "project-practice.com"
    www_domain  = "www.${local.apex_domain}"
}

variable "domain_zone_id" {
    type = string
    description = "Domain Host Zone ID"
  
}