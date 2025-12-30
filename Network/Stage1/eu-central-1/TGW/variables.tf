variable "name" {
    type = string
    description = "Name of the TGW"
  
}

variable "vpc-1-id" {
    type = string
    description = "ID of VPC-1"
  
}

variable "vpc-1-subnet-ids" {
    type = list(string)
    description = "ID's of VPC-1 subnets"
  
}
