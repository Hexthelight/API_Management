# Allow Lambda to assume roles

data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Lambda Role Access

resource "aws_iam_role" "lambda_role" {
    name = "lambda-role"
    assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json

    tags = var.tags
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
    role = aws_iam_role.lambda_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}