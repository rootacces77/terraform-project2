resource "aws_vpc" "vpc_2" {
  cidr_block           = "10.17.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "VPC-2"
    Terraform   = "true"
  }
}

resource "aws_internet_gateway" "vpc_2_igw" {
  vpc_id = aws_vpc.vpc_2.id

  tags = {
    Name        = "VPC-2-IGW"
    Terraform   = "true"
  }
}

########################
# SUBNETS CIDR
########################
locals {
  vpc_2_public_subnets = {
    "us-east-1a" = "10.17.0.0/20"
    "us-east-1b" = "10.17.16.0/20"
    "us-east-1c" = "10.17.32.0/20"
  }
  vpc_2_private1_subnets = {
    "us-east-1a" = "10.17.48.0/20"
    "us-east-1b" = "10.17.64.0/20"
    "us-east-1c" = "10.17.80.0/20"
  }
  vpc_2_private2_subnets = {
    "us-east-1a" = "10.17.96.0/20"
    "us-east-1b" = "10.17.112.0/20"
    "us-east-1c" = "10.17.128.0/20"
  }
}

########################
# PUBLIC SUBNETS
########################

resource "aws_subnet" "vpc_2_public" {
  for_each = local.vpc_2_public_subnets

  vpc_id                  = aws_vpc.vpc_1.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = {
    Name        = "VPC-2-SBNT-PUBLIC"
    Tier        = "PUBLIC"
    Terraform   = "true"
  }
}

#NAT

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.vpc_2_public["us-east-1a"].id

  tags = {
    Name = "nat-gw-public-1"
  }
}



#RT
resource "aws_route_table" "vpc_2_public_rt" {
  vpc_id = aws_vpc.vpc_2.id

  tags = {
    Name        = "VPC-2-PUBLIC-RT"
    Terraform   = "true"
  }
}

resource "aws_route_table_association" "vpc_2_public_rt" {
  for_each       = aws_subnet.vpc_2_public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.vpc_2_public.id
}

resource "aws_route" "vpc_2_public_igw_route" {
  route_table_id         = aws_route_table.vpc_2_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc_2_igw.id
}

########################
# PRIVATE SUBNETS 1
########################

resource "aws_subnet" "vpc_2_private_1" {
  for_each = local.vpc_2_private1_subnets

  vpc_id                  = aws_vpc.vpc_2.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = false

  tags = {
    Name        = "VPC-2-SBNT-PRIVATE-1"
    Tier        = "PRIVATE1-1"
    Terraform   = "true"
  }
}

resource "aws_route_table" "vpc_2_private_1_rt" {
  vpc_id = aws_vpc.vpc_2.id

  tags = {
    Name        = "VPC-2-PRIVATE-2-RT"
    Terraform   = "true"
  }
}

resource "aws_route_table_association" "vpc_2_private_1_rt" {
  for_each       = aws_subnet.vpc_2_private_1
  subnet_id      = each.value.id
  route_table_id = aws_route_table.vpc_2_private_1_rt.id
}



########################
# PRIVATE SUBNETS 2
########################

resource "aws_subnet" "vpc_2_private_2" {
  for_each = local.vpc_2_private2_subnets

  vpc_id                  = aws_vpc.vpc_vpc_2.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = false

  tags = {
    Name        = "VPC-2-SBNT-PRIVATE-2"
    Tier        = "PRIVATE"
    Terraform   = "true"
  }
}

resource "aws_route_table" "vpc_2_private_rt" {
  vpc_id = aws_vpc.vpc_2

  tags = {
    Name        = "VPC-2-PRIVATE-RT"
    Terraform   = "true"
  }
}


resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.vpc_2_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "vpc_2_private_rt" {
  for_each       = aws_subnet.vpc_2_private_2
  subnet_id      = each.value.id
  route_table_id = aws_route_table.vpc_2_private_rt.id
}