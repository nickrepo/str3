module "vpc" {
  source = "../modules/VPC"
  env = var.env
  public_subnet_cidr_blocks = var.public_subnet_cidr_blocks
  vpc_cidr_block = var.vpc_cidr_block
}

resource "aws_lb" "ECSLB" {
  name                       = "ECSLB-${var.env}"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.allow_http_lb.id]
  subnets                    = module.vpc.public_subnet_ids
  enable_deletion_protection = false
  zone_id = "Z05128831KF80S7BI24HD"
}

resource "aws_lb_target_group" "ECSTG" {
  name        = "ECSTG-${var.env}"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id

  health_check {
    interval = 5
    timeout  = 2
  }
}

resource "aws_lb_listener" "ECSListener" {
  load_balancer_arn = aws_lb.ECSLB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ECSTG.arn
  }
}

