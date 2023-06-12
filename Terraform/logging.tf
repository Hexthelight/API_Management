# Assume role Policy

data "aws_iam_policy_document" "assume_role" {
    statement {
        sid = ""        
        effect = "Allow"

        principals {
            type = "Service"
            identifiers = ["apigateway.amazonaws.com"]
        }

        actions = ["sts:AssumeRole"]
    }
}

# Create Cloudwatch log group and assign to API gateway

resource "aws_cloudwatch_log_group" "api_log_group" {
    name = "api_log_group"

    tags = var.tags
}

resource "aws_iam_role" "api_log_group" {
    name = "api_log_group"
    assume_role_policy = data.aws_iam_policy_document.assume_role.json

    tags = var.tags
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
    role = aws_iam_role.api_log_group.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}