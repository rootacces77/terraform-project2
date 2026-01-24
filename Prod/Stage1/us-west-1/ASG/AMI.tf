#############################
# Amazon Linux 2023 standard AMI
#############################
data "aws_ami" "al2023" {
  most_recent = true

  # Amazon-owned public AMIs
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
} 
