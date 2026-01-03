output "tgw-id" {
  value = module.tgw.tgw-id
  description = "TGW ID"
}

output "vpc-1-id" {
    value = module.vpc-1.vpc_id
  
}

output "tgw-peering-id" {
    value = module.tgw.tgw-peering-id
    description = "TGW Peering ID between us-west-1 and us-east-1"
  
}

output "tgw-rt-id" {
    value = module.tgw.tgw-rt-id
    description = "TGW Main RT ID"
  
}

output "vpc-cidr" {
  value = module.vpc-1.vpc_cidr
  description = "CIDR of VPC 1"
}

output "tgw-arn" {
    value = module.tgw.tgw-arn
  
}

