#CW alarm to check UnHealthyHosts behind LB
resource "aws_cloudwatch_metric_alarm" "lb_alarm" {
  alarm_name          = "LB-UnHealthyHostCount"
  alarm_description   = "unhealthy"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = 1
  period              = 60
  unit                = "Count"
  namespace           = "AWS/ApplicationELB"
  metric_name         = "UnHealthyHostCount"
  statistic           = "Sum"
  # alarm_actions       = ["arn:aws:sns:eu-west-2:172019531624:devwarn-sns-core-ew2-techtest1"]

  dimensions = {
    TargetGroup  = aws_lb_target_group.ECSTG.arn_suffix
    LoadBalancer = aws_lb.ECSLB.arn_suffix
  }
}
## Error rate for HTTP 5XX responses
resource "aws_cloudwatch_metric_alarm" "foobar" {
  alarm_name                = "5XX_Error_Rate"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  threshold                 = 10
  alarm_description         = "Request error rate has exceeded 10%"
  insufficient_data_actions = []
  #alarm_actions       = ["arn:aws:sns:eu-west-2:172019531624:devwarn-sns-core-ew2-techtest1"]

  metric_query {
    id          = "e1"
    expression  = "m2/m1*100"
    label       = "Error Rate"
    return_data = "true"
  }

  metric_query {
    id = "m1"

    metric {
      metric_name = "RequestCount"
      namespace   = "AWS/ApplicationELB"
      period      = 120
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        LoadBalancer = "app/ECSLB-dev/163dea054ba60aae"
      }
    }
  }

  metric_query {
    id = "m2"

    metric {
      metric_name = "HTTPCode_ELB_5XX_Count"
      namespace   = "AWS/ApplicationELB"
      period      = 120
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        LoadBalancer = "app/ECSLB-dev/163dea054ba60aae"
      }
    }
  }
}