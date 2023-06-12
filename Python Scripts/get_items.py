import boto3

def lambda_handler (event, context):
    client = boto3.resource('dynamodb')

    table = client.Table("api-test-table")

    response = table.scan()

    return {
        "statusCode": 200,
        "isBase64Encoded": 'false',
        "headers": {"Content-Type": "application/json"},
        "body": str(response['Items'])
        }