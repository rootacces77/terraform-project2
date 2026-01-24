#############################
# APP Launch Template
#############################
resource "aws_launch_template" "app_template" {
  name_prefix   = "ec2-app-template"
  image_id      = data.aws_ami.al2023.id
  instance_type = var.app_instance_type

  iam_instance_profile {
    arn = aws_iam_instance_profile.ec2_profile.arn
  }

  vpc_security_group_ids = [aws_security_group.app_template.id]

  user_data = base64encode(<<-EOF
              #!/bin/bash
              dnf install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
              yum install -y amazon-cloudwatch-agent awscli

              systemctl enable --now amazon-ssm-agent

              mkdir /tmp/scripts
              aws s3 cp ${var.scripts_bucket_url}/* /tmp/scripts/
              chmod +x /tmp/scripts/*
              cp /tmp/scripts/cw-log-config.json /opt/aws/amazon-cloudwatch-agent/etc/

              /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
             -a fetch-config -m ec2 \
             -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json \
             -s

             python3 /tmp/scripts/health_server.py --port 80 &
             python3 /tmp/scripts/listener_log.py -protocol udp -port 8080 --log-file /var/log/udp_8080.log &


              EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "ec2-app-instance"
      Environment = "PROD"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}


#############################
# SEC Launch Template
#############################
resource "aws_launch_template" "sec_template" {
  name_prefix   = "ec2-sec-template"
  image_id      = data.aws_ami.al2023.id
  instance_type = var.app_instance_type

  iam_instance_profile {
    arn = aws_iam_instance_profile.ec2_profile.arn
  }

  vpc_security_group_ids = [aws_security_group.sec_template.id]

  user_data = base64encode(<<-EOF
              #!/bin/bash
              dnf install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
              systemctl enable --now amazon-ssm-agent

              python3 /tmp/scripts/health_server.py --port 80
              python3 emit_random_ip_event.py --event-bus default --cidr 198.51.100.0/24 --message "Malformed traffic detected"
              EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "ec2-sec-instance"
      Environment = "PROD"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}