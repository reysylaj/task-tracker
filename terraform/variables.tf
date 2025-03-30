# AWS region for deployment
variable "aws_region" {
  description = "The AWS region to deploy resources into"
  type        = string
  default     = "eu-west-3"
}

# Lambda function name
variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
  default     = "task-tracker-function"
}

# DynamoDB table name
variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table"
  type        = string
  default     = "TaskTable"
}
