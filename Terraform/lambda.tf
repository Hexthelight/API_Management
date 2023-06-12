# Package Lambda scripts

data "archive_file" "zip_lambda_post" {
    type = "zip"
    source_file = "../Python Scripts/put_item.py"
    output_path = "${path.module}/lambda/put_item.zip"
}

data "archive_file" "zip_lambda_get_single" {
    type = "zip"
    source_file = "../Python Scripts/get_item.py"
    output_path = "${path.module}/lambda/get_item.zip"
}

data "archive_file" "zip_lambda_get_multiple" {
    type = "zip"
    source_file = "../Python Scripts/get_items.py"
    output_path = "${path.module}/lambda/get_items.zip"
}

data "archive_file" "zip_lambda_delete" {
    type = "zip"
    source_file = "../Python Scripts/delete_item.py"
    output_path = "${path.module}/lambda/delete_item.zip"
}

# Provision Lambda functions

resource "aws_lambda_function" "lambda_post" {
    filename = "${path.module}/lambda/put_item.zip"
    function_name = "post_item"
    role = aws_iam_role.lambda_role.arn

    handler = "put_item.lambda_handler"
    runtime = "python3.10"

    tags = var.tags
}

resource "aws_lambda_function" "lambda_get_single" {
    filename = "${path.module}/lambda/get_item.zip"
    function_name = "get_item"
    role = aws_iam_role.lambda_role.arn

    handler = "get_item.lambda_handler"
    runtime = "python3.10"

    tags = var.tags
}

resource "aws_lambda_function" "lambda_get_multiple" {
    filename = "${path.module}/lambda/get_items.zip"
    function_name = "get_items"
    role = aws_iam_role.lambda_role.arn

    handler = "get_items.lambda_handler"
    runtime = "python3.10"

    tags = var.tags
}

resource "aws_lambda_function" "lambda_delete" {
    filename = "${path.module}/lambda/delete_item.zip"
    function_name = "delete_item"
    role = aws_iam_role.lambda_role.arn

    handler = "delete_item.lambda_handler"
    runtime = "python3.10"

    tags = var.tags
}

# Add Permissions to allow API Gateway to access Lambda

resource "aws_lambda_permission" "apigw_lambda_put" {
  statement_id  = "AllowExecutionFromAPIGatewayPut"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_post.function_name
  principal     = "apigateway.amazonaws.com"

  # The /*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  source_arn = "${aws_apigatewayv2_api.gateway.execution_arn}/*"
}

resource "aws_lambda_permission" "apigw_lambda_get_single" {
    statement_id = "AllowExecutionFromAPIGatewayGetSingle"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.lambda_get_single.function_name
    principal = "apigateway.amazonaws.com"

    source_arn = "${aws_apigatewayv2_api.gateway.execution_arn}/*"
}

resource "aws_lambda_permission" "apigw_lambda_get_multiple" {
    statement_id = "AllowExecutionFromAPIGatewayGetMultiple"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.lambda_get_multiple.function_name
    principal = "apigateway.amazonaws.com"

    source_arn = "${aws_apigatewayv2_api.gateway.execution_arn}/*"
}

resource "aws_lambda_permission" "apigw_lambda_delete" {
    statement_id = "AllowExecutionFromAPIGatewayDelete"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.lambda_delete.function_name
    principal = "apigateway.amazonaws.com"

    source_arn = "${aws_apigatewayv2_api.gateway.execution_arn}/*"
}