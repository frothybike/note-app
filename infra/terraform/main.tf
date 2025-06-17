terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.0"
}

provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket-20250618"
  acl    = "private"

  tags = {
    Name        = "example-bucket-20250618"
  }
}