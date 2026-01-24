
#############################
# NLB Target Group
#############################
resource "aws_lb_target_group" "app_tg" {
  name        = "app-tg"
  port        = var.nlb_app_port
  protocol    = "HTTP"
  target_type = var.target_type
  vpc_id      = var.vpc_id

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    port                = var.tg_port
    matcher             = "200"
    interval            = 60
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 5
  }

  tags = {
    Name = "app-tg"
  }
}