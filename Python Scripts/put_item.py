import boto3
import json

def lambda_handler (event, context):
    payload = json.loads(event['body'])
    client = boto3.resource('dynamodb')

    table = client.Table("api-test-table")

    for i in payload['data']:
        table.put_item(Item = {
            "id": i['id'],
            "name": i['name']
        })

    return {
        "statusCode": 200,
        "isBase64Encoded": 'false',
        "headers": {"Content-Type": "application/json"},
        "body": "it worked!"
        }