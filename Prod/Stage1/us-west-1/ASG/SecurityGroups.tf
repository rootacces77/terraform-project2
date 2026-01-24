#############################
# Security Group for APP Template
#############################
resource "aws_security_group" "app_template" {
  name        = "prod-app-template-sg"
  description = "NLB SG in shared PROD APP VPC"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow UDP APP Traffic"
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "udp"
    cidr_blocks = var.nlb_subnet_cidrs
  }

   ingress {
    description = "Allow Health Check"
    from_port   = var.tg_port
    to_port     = var.tg_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "PROD-APP-TEMPLATE-SG"
    Environment = "PROD"
  }
}


#############################
# Security Group for SEC Template
#############################
resource "aws_security_group" "sec_template" {
  name        = "prod-app-template-sg"
  description = "NLB SG in shared PROD APP VPC"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow UDP APP Traffic"
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "udp"
    cidr_blocks = var.nlb_subnet_cidrs
  }

   ingress {
    description = "Allow Health Check"
    from_port   = var.tg_port
    to_port     = var.tg_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "PROD-APP-TEMPLATE-SG"
    Environment = "PROD"
  }
}