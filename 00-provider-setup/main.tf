terraform {
  required_version = ">=1.12.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

# 간단한 S3 버킷 생성 (실습용)
resource "aws_s3_bucket" "terraform_practice" {
  bucket = "terraform-practice-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# 출력값 정의
output "bucket_name" {
  value = aws_s3_bucket.terraform_practice.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.terraform_practice.arn
}
