output "vpc_id" {
  value = aws_vpc.vpc_1.id
  description = "VPC 1 ID"
}

output "vpc_1_private1_subnets" {
  value = [for s in aws_subnet.vpc_1_private1 : s.arn]
  description = "ARN of ClientVPN Subnets"
}

output "vpc_1_public_subnets" {
  value = [for s in aws_subnet.vpc_1_public : s.arn]
  description = "ARN of Public Subnets"
}

output "vpc_1_private2_subnets" {
  value = [for s in aws_subnet.vpc_1_private2: s.arn]
  description = "ARN of Private Subnets"
}

output "vpc_cidr" {
  value = aws_vpc.vpc_1.cidr_block
  description = "CIDR of VPC 1"
}


output "vpc_1_public_subnets_ids" {
  value =  [for s in aws_subnet.vpc_1_public : s.id]
  description = "ID's of Public Subnets "
  
}

output "vpc_1_private2_subnets_ids" {
  value =  [for s in aws_subnet.vpc_1_private2 : s.id]
  description = "ID's of Private Subnets "
  
}

output "vpc_1_private1_subnets_ids" {
  value =  [for s in aws_subnet.vpc_1_private1 : s.id]
  description = "ID's of ClientVPN Subnets "
  
}

output "vpc1_private1_rt_id" {
  value = aws_route_table.vpc_1_private1_rt
  description = "ID of VPC_1 Private 1 Subnet RT "
  
}