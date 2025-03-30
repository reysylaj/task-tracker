import json
import uuid
import boto3
import os

# Get DynamoDB table name from environment variable
dynamodb = boto3.resource('dynamodb')
table_name = os.environ.get("TASKS_TABLE_NAME")
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    http_method = event.get("httpMethod")
    path = event.get("path")
    response = {}

    if http_method == "POST" and path == "/tasks":
        data = json.loads(event.get("body", "{}"))
        task_id = str(uuid.uuid4())
        task = {
            "task_id": task_id,
            "title": data.get("title"),
            "description": data.get("description"),
            "status": data.get("status", "pending")
        }
        table.put_item(Item=task)
        response = {
            "statusCode": 201,
            "body": json.dumps({"message": "Task created", "task_id": task_id})
        }

    elif http_method == "GET" and path == "/tasks":
        result = table.scan()
        tasks = result.get("Items", [])
        response = {
            "statusCode": 200,
            "body": json.dumps(tasks)
        }

    elif http_method == "PUT" and path.startswith("/tasks/"):
        task_id = path.split("/tasks/")[1]
        data = json.loads(event.get("body", "{}"))
        update_expression = "SET "
        expression_values = {}
        updates = []

        if "title" in data:
            updates.append("title = :t")
            expression_values[":t"] = data["title"]
        if "description" in data:
            updates.append("description = :d")
            expression_values[":d"] = data["description"]
        if "status" in data:
            updates.append("status = :s")
            expression_values[":s"] = data["status"]

        if updates:
            update_expression += ", ".join(updates)
            table.update_item(
                Key={"task_id": task_id},
                UpdateExpression=update_expression,
                ExpressionAttributeValues=expression_values
            )
            response = {
                "statusCode": 200,
                "body": json.dumps({"message": "Task updated"})
            }
        else:
            response = {
                "statusCode": 400,
                "body": json.dumps({"message": "No valid fields to update"})
            }

    elif http_method == "DELETE" and path.startswith("/tasks/"):
        task_id = path.split("/tasks/")[1]
        table.delete_item(Key={"task_id": task_id})
        response = {
            "statusCode": 200,
            "body": json.dumps({"message": "Task deleted if it existed"})
        }

    else:
        response = {
            "statusCode": 404,
            "body": json.dumps({"message": "Not found"})
        }

    response["headers"] = {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*"
    }

    return response
