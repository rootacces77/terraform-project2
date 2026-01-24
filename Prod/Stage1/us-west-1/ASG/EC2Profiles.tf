############################
# IAM Role for EC2 APP 
############################
resource "aws_iam_role" "ec2_role" {
  name = "EC2APPRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}


#SSM POLICY ATTACHMENT
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

#CloudWatch POLICY ATTACHMENT
resource "aws_iam_role_policy_attachment" "cw_agent" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

#S3 POLICY ATTACHMENT
resource "aws_iam_role_policy_attachment" "s3_fullaccess" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}


#EventBridge POLICY ATTACHMENT
resource "aws_iam_role_policy_attachment" "eventbridge_fullaccess" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess"
}


# EC2 PROFILE
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "AppEC2Profile"
  role = aws_iam_role.ec2_role.name
}