terraform {
    required_version = ">=1.12.2"
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

provider "aws" {
    region = "ap-northeast-2"
}

# 기존 VPC 정보 참조
data "aws_vpc" "main" {
    filter {
        name = "tag:Name"
        values = ["${var.project_name}-vpc"]
    }
}

# 기존 Public Subnet 정보 참조
data "aws_subnet" "public" {
    filter {
        name = "tag:Name"
        values = ["${var.project_name}-public-subnet"]
    }
}

# 기존 Private Subnet 정보 참조
data "aws_subnet" "private" {
    filter {
        name = "tag:Name"
        values = ["${var.project_name}-private-subnet"]
    }
}

# 기존 Private Route Table 정보 참조
data "aws_route_table" "private" {
    filter {
        name = "tag:Name"
        values = ["${var.project_name}-private-rt"]
    }
}

# 1. Elastic IP 생성 (NAT Gateway용)
resource "aws_eip" "nat" {
    domain = "vpc"

    tags = {
        Name = "${var.project_name}-nat-eip"
        Environment = var.environment
        Purpose = "NAT Gateway"
    }
}

# 2. NAT Gateway 생성
resource "aws_nat_gateway" "main" {
    allocation_id = aws_eip.nat.id
    subnet_id = data.aws_subnet.public.id

    tags = {
        Name = "${var.project_name}-nat-gateway"
        Environment = var.environment
    }

    # Internet Gateway가 먼저 생성되어야 함
    depends_on = [aws_eip.nat]
}

# 3. Private Route Table에 NAT Gateway로의 라우트 추가
resource "aws_route" "private_nat" {
    route_table_id = data.aws_route_table.private.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
}