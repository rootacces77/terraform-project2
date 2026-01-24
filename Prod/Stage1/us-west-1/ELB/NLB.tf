#############################
# NLB
#############################
resource "aws_lb" "nlb" {
  name               = "APP-NLB"
  load_balancer_type = "network"
  internal           = false
  security_groups    = [aws_security_group.app_nlb.id]
  subnets            = var.nlb_subnet_ids
  enable_deletion_protection = false

  tags = {
    Name = "APP-NLB"
  }
}

#############################
# NLB Listener 
#############################
resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = var.nlb_app_port
  protocol          = "UDP"

  ssl_policy      = "ELBSecurityPolicy-2016-08"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}