resource "aws_ram_resource_share" "vpc_1_subnets_shared" {
  name                      = "vpc-1-subnets-shared"
  allow_external_principals = false   # only inside the same AWS Org
}


resource "aws_ram_principal_association" "vpc_1_access" {
  resource_share_arn = aws_ram_resource_share.vpc_1_subnets_shared.arn
  principal          = var.prod_account_id
}


resource "aws_ram_resource_association" "vpc_1_subnets" {
  count              = length(var.vpc-1-subnet-arns)
  resource_share_arn = aws_ram_resource_share.vpc_1_subnets_shared.arn
  resource_arn       = var.vpc-1-subnet-arns[count.index]
}
