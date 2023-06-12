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

  assume_role {
    role_arn = "arn:aws:iam::567145450285:role/OrganizationAccountAccessRole"
  }
}