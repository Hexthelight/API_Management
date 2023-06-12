# Create API Gateway

resource "aws_apigatewayv2_api" "gateway" {
    name = "example-http-api"
    protocol_type = "HTTP"

    tags = var.tags
}

resource "aws_apigatewayv2_stage" "stage" {
    api_id = aws_apigatewayv2_api.gateway.id
    name = "$default"

    access_log_settings {
        destination_arn = aws_cloudwatch_log_group.api_log_group.arn
        format = "{'requestId':$context.requestId,'integrationErrorMessage': $context.integrationErrorMessage}"
    }
}

resource "aws_apigatewayv2_deployment" "deployment" {
    api_id = aws_apigatewayv2_api.gateway.id

    depends_on = [aws_apigatewayv2_route.route_PUT_items]
}

# API Authentication

resource "aws_apigatewayv2_authorizer" "auth" {
    api_id = aws_apigatewayv2_api.gateway.id
    authorizer_type = "JWT"
    identity_sources = ["$request.header.Authorization"]
    name = "cognito-authorizer"

    jwt_configuration {
      audience = [aws_cognito_user_pool_client.pool_client.id]
      issuer = "https://${aws_cognito_user_pool.pool.endpoint}"
    }
}

# Link API Gateway to Lambda Functions

resource "aws_apigatewayv2_integration" "PUT_int" {
    api_id = aws_apigatewayv2_api.gateway.id
    integration_type = "AWS_PROXY"

    integration_method = "POST"
    integration_uri = aws_lambda_function.lambda_post.invoke_arn
}

resource "aws_apigatewayv2_integration" "GET_single_int" {
    api_id = aws_apigatewayv2_api.gateway.id
    integration_type = "AWS_PROXY"

    integration_method = "POST"
    integration_uri = aws_lambda_function.lambda_get_single.invoke_arn
}

resource "aws_apigatewayv2_integration" "GET_multiple_int" {
    api_id = aws_apigatewayv2_api.gateway.id
    integration_type = "AWS_PROXY"

    integration_method = "POST"
    integration_uri = aws_lambda_function.lambda_get_multiple.invoke_arn
}

resource "aws_apigatewayv2_integration" "DELETE_int" {
    api_id = aws_apigatewayv2_api.gateway.id
    integration_type = "AWS_PROXY"

    integration_method = "POST"
    integration_uri = aws_lambda_function.lambda_delete.invoke_arn
}


# API Gateway Routes

resource "aws_apigatewayv2_route" "route_PUT_items" {
    api_id = aws_apigatewayv2_api.gateway.id
    route_key = "PUT /items"

    target = "integrations/${aws_apigatewayv2_integration.PUT_int.id}"
    authorization_type = "JWT"
    authorizer_id = aws_apigatewayv2_authorizer.auth.id
}

resource "aws_apigatewayv2_route" "route_GET_single" {
    api_id = aws_apigatewayv2_api.gateway.id
    route_key = "GET /items/{id}"

    target = "integrations/${aws_apigatewayv2_integration.GET_single_int.id}"
    authorization_type = "JWT"
    authorizer_id = aws_apigatewayv2_authorizer.auth.id
}

resource "aws_apigatewayv2_route" "route_GET_multiple" {
    api_id = aws_apigatewayv2_api.gateway.id
    route_key = "GET /items"

    target = "integrations/${aws_apigatewayv2_integration.GET_multiple_int.id}"
    authorization_type = "JWT"
    authorizer_id = aws_apigatewayv2_authorizer.auth.id
}

resource "aws_apigatewayv2_route" "route_DELETE_items" {
    api_id = aws_apigatewayv2_api.gateway.id
    route_key = "DELETE /items/{id}"

    target = "integrations/${aws_apigatewayv2_integration.DELETE_int.id}"
    authorization_type = "JWT"
    authorizer_id = aws_apigatewayv2_authorizer.auth.id
}