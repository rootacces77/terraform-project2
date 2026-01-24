output "vpc_id" {
  value = aws_vpc.vpc_2.id
  description = "VPC 2 ID"
}

output "vpc_2_private1_subnets" {
  value = [for s in aws_subnet.vpc_2_private_1 : s.arn]
  description = "ARN of Private 1 Subnets"
}

output "vpc_2_public_subnets" {
  value = [for s in aws_subnet.vpc_2_public : s.arn]
  description = "ARN of Public Subnets"
}

output "vpc_2_private2_subnets" {
  value = [for s in aws_subnet.vpc_2_private_2 : s.arn]
  description = "ARN of Private 2 Subnets"
}

output "vpc_cidr" {
  value = aws_vpc.vpc_2.cidr_block
  description = "CIDR of VPC 2"
}


output "vpc_2_public_subnets_ids" {
  value =  [for s in aws_subnet.vpc_2_public : s.id]
  description = "ID's of Public Subnets "
  
}

output "vpc_2_private1_subnets_ids" {
  value =  [for s in aws_subnet.vpc_2_private_1 : s.id]
  description = "ID's of Private 1 Subnets "
  
}

output "vpc_2_private2_subnets_ids" {
  value =  [for s in aws_subnet.vpc_2_private_2 : s.id]
  description = "ID's of Private 2 Subnets "
  
}

output "vpc2_private1_rt_id" {
  value = aws_route_table.vpc_2_private_rt.id
  description = "ID of VPC-2 PRIVATE-1 Subnet RT "
  
}