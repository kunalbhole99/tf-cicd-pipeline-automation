######################################################
## Instance Target Group
######################################################

resource "aws_lb_target_group" "alb_target_group" {
  name     = "tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.vpc_selected.id
  stickiness {
    type    = "lb_cookie"
    enabled = false
  }

  health_check {
    path                = "/get"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-399"
  }

  tags = {
    "Name" = "tg"
  }
}