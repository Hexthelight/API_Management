resource "aws_dynamodb_table" "db" {
    name = "api-test-table"
    hash_key = "id"

    billing_mode = "PROVISIONED"
    read_capacity = "1"
    write_capacity = "1"

    attribute {
        name = "id"
        type = "N"
    }

    tags = var.tags
}