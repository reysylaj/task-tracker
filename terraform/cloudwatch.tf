resource "aws_cloudwatch_dashboard" "task_tracker_dashboard" {
  dashboard_name = "task-tracker-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric",
        x      = 0,
        y      = 0,
        width  = 12,
        height = 6,
        properties = {
          title  = "Lambda Invocations & Errors",
          view   = "timeSeries",
          region = var.aws_region,
          metrics = [
            ["AWS/Lambda", "Invocations", "FunctionName", var.lambda_function_name],
            [".", "Errors", ".", "."]
          ],
          stat   = "Sum",
          period = 300
        }
      },
      {
        type   = "metric",
        x      = 0,
        y      = 6,
        width  = 12,
        height = 6,
        properties = {
          title  = "Lambda Duration (ms)",
          view   = "timeSeries",
          region = var.aws_region,
          metrics = [
            ["AWS/Lambda", "Duration", "FunctionName", var.lambda_function_name]
          ],
          stat   = "Average",
          period = 300
        }
      },
      {
        type   = "metric",
        x      = 0,
        y      = 12,
        width  = 12,
        height = 6,
        properties = {
          title  = "Throttles & ConcurrentExecutions",
          view   = "timeSeries",
          region = var.aws_region,
          metrics = [
            ["AWS/Lambda", "Throttles", "FunctionName", var.lambda_function_name],
            [".", "ConcurrentExecutions", ".", "."]
          ],
          stat   = "Sum",
          period = 300
        }
      }
    ]
  })
}
