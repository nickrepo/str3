module "vpc" {
  source                    = "../modules/VPC"
  env                       = var.env
  public_subnet_cidr_blocks = var.public_subnet_cidr_blocks
  vpc_cidr_block            = var.vpc_cidr_block
}

resource "aws_lb" "ECSLB" {
  name                       = "ECSLB-${var.env}"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.allow_http_lb.id]
  subnets                    = module.vpc.public_subnet_ids
  enable_deletion_protection = false
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

resource "aws_cloudwatch_metric_alarm" "lb_alarm" {
  alarm_name          = "lb_alarm-"
  alarm_description   = "unhealthy"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = 1
  period              = 60
  unit                = "Count"
  namespace           = "AWS/ApplicationELB"
  metric_name         = "UnHealthyHostCount"
  statistic           = "Sum"
  alarm_actions       = ["arn:aws:sns:eu-west-2:172019531624:devwarn-sns-core-ew2-techtest1"]

  dimensions = {
    TargetGroup  = aws_lb_target_group.ECSTG.arn_suffix
    LoadBalancer = aws_lb.ECSLB.arn_suffix
  }
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.Strat7.id
  name    = "nick.techtest1.ex-plor.co.uk"
  type    = "CNAME"
  ttl     = 300
  records = ["ECSLB-dev-2058094774.eu-west-2.elb.amazonaws.com"]
}