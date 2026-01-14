variable "apigw_origin_verify_header_name" {
    type = string
    description = "Header Key"
    default = "some_name"
  
}

variable "apigw_origin_verify_secret" {
     type = string
     description = "Header value"
     default = "some_secret"
  
}


variable "domain_zone_id" {
    type = string
    description = "Domain Host Zone ID"
  
}