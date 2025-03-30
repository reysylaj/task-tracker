# Output the Lambda function name
output "lambda_function_name" {
  description = "Deployed Lambda function name"
  value       = aws_lambda_function.task_lambda.function_name
}

# Output the API Gateway endpoint URL
output "api_gateway_url" {
  description = "The API Gateway endpoint URL"
  value       = aws_apigatewayv2_api.task_api.api_endpoint
}

# Output the DynamoDB table name
output "dynamodb_table_name" {
  description = "The DynamoDB table name"
  value       = aws_dynamodb_table.task_table.name
}
