# SNS Topic for email alerts
resource "aws_sns_topic" "alerts_topic" {
  name = "task-tracker-alerts"
}

# Email subscription to the SNS topic
resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.alerts_topic.arn
  protocol  = "email"
  endpoint  = var.alert_email # <-- Add this in variables.tf
}

# CloudWatch Alarm for Lambda Errors > 0
resource "aws_cloudwatch_metric_alarm" "lambda_error_alarm" {
  alarm_name          = "LambdaErrorAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 300
  statistic           = "Sum"
  threshold           = 0
  alarm_description   = "Triggered when Lambda returns more than 0 errors."
  alarm_actions       = [aws_sns_topic.alerts_topic.arn]

  dimensions = {
    FunctionName = var.lambda_function_name
  }
}

# CloudWatch Alarm for Lambda Duration > 1000ms
resource "aws_cloudwatch_metric_alarm" "lambda_duration_alarm" {
  alarm_name          = "LambdaDurationAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "Duration"
  namespace           = "AWS/Lambda"
  period              = 300
  statistic           = "Average"
  threshold           = 1000
  alarm_description   = "Triggered when average Lambda duration exceeds 1 second."
  alarm_actions       = [aws_sns_topic.alerts_topic.arn]

  dimensions = {
    FunctionName = var.lambda_function_name
  }
}
