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

# 1. VPC 생성
resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = "${var.project_name}-vpc"
        Environment = var.environment
    }
}

# 2. Internet Gateway 생성
resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "${var.project_name}-igw"
        Environment = var.environment
    }
}

# 3. Public Subnet 생성
resource "aws_subnet" "public" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnet_cidr
    availability_zone = var.availability_zone
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.project_name}-public-subnet"
        Environment = var.environment
        Type = "Public"
    }
}

# 4. Private Subnet 생성
resource "aws_subnet" "private" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnet_cidr
    availability_zone = var.availability_zone

    tags = {
        Name = "${var.project_name}-private-subnet"
        Environment = var.environment
        Type = "Private"
    }
}

#5. Public Route Table 생성
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    # Internet Gateway로 향하는 라우트
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }

    tags = {
        Name = "${var.project_name}-public-rt"
        Environment = var.environment
        Type = "Public"
    }
}

# 6. Private Route Table 생성
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id

    # 로컬 라우트만(기본값)

    tags = {
        Name = "${var.project_name}-private-rt"
        Environment = var.environment
        Type = "Private"
    }
}

# 7. Public Subnet과 Public Route Table 연결
resource "aws_route_table_association" "public" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.public.id
}

# 8.Private Subnet과 Private Route Table 연결
resource "aws_route_table_association" "private" {
    subnet_id = aws_subnet.private.id
    route_table_id = aws_route_table.private.id
}