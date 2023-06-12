resource "aws_cognito_user_pool" "pool" {
    name = "api_pool"
    
    tags = var.tags
}

resource "aws_cognito_user_pool_client" "pool_client" {
    name = "api_gateway_cognito_client"
    user_pool_id = aws_cognito_user_pool.pool.id

    explicit_auth_flows = [
        "ALLOW_USER_PASSWORD_AUTH",
        "ALLOW_USER_SRP_AUTH",
        "ALLOW_REFRESH_TOKEN_AUTH"
    ]
}

resource "aws_cognito_user" "test_user" {
    user_pool_id = aws_cognito_user_pool.pool.id
    username = "test_user"

    password = "L3tm31n!"
}