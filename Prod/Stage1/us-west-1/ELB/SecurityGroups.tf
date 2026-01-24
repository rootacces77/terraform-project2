#############################
# Security Group for NLB
#############################
resource "aws_security_group" "app_nlb" {
  name        = "prod-app-nlb-sg"
  description = "NLB SG in shared PROD APP VPC"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow UDP Traffic for APP"
    from_port   = var.nlb_app_port
    to_port     = var.nlb_app_port
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "PROD-APP-NLB-SG"
    Environment = "PROD"
  }
}