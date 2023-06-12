# Boilerplate

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "eu-west-3"
}

resource "aws_organizations_account" "account" {
    name = "02 - API Gateway"
    email = "wes.white+02apigateway@hexthelight.co.uk"

    close_on_deletion = true

    tags = var.tags
}
