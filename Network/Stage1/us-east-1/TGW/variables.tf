variable "name" {
    type = string
    description = "Name of the TGW"
  
}

variable "vpc-1-id" {
    type = string
    description = "ID of VPC-1"
  
}

variable "vpc-2-id" {
    type = string
    description = "ID of VPC-2"
  
}

variable "vpc-1-subnet-ids" {
    type = list(string)
    description = "ID's of VPC-1 subnets"
  
}

variable "vpc-2-subnet-ids" {
    type = list(string)
    description = "ID's of VPC-2 subnets"
  
}