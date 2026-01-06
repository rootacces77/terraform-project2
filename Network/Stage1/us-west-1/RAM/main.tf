resource "aws_ram_resource_share" "vpc_1_subnets_shared" {
  name                      = "vpc_1_subnets_shared"
  allow_external_principals = false   # only inside the same AWS Org
}


resource "aws_ram_principal_association" "vpc_1_access" {
  resource_share_arn = aws_ram_resource_share.vpc_1_subnets_shared.arn
  principal          = var.prod_account_id
}


resource "aws_ram_resource_association" "vpc_1_subnets" {
  count              = length(var.vpc_1_subnet_arns)
  resource_share_arn = aws_ram_resource_share.vpc_1_subnets_shared.arn
  resource_arn       = var.vpc_1_subnet_arns[count.index]
}
