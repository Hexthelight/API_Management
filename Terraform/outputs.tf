output "API_Endpoint" {
    description = "The API Endpoint for API Gateway"
    value = aws_apigatewayv2_api.gateway.api_endpoint
}

output "Cognito_User_Pool_ID" {
    description = "The ID for the user pool client"
    value = aws_cognito_user_pool_client.pool_client.id
}