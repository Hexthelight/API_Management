import boto3

def lambda_handler (event, context):
    payload = event['pathParameters']
    client = boto3.resource('dynamodb')

    table = client.Table("api-test-table")

    response = table.delete_item(Key = {
        'id': int(payload['id'])
    })

    return {
        "statusCode": 200,
        "isBase64Encoded": 'false',
        "headers": {"Content-Type": "application/json"},
        "body": "Item deleted"
        }