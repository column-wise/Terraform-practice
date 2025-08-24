terraform {
    required_version = ">=1.12.2"
    required_providers {
        aws = {
            source   = "hashicorp/aws"
            version  = "~> 5.0"
        }
    }
}

provider "aws" {
    region = "ap-northeast-2"
}

data "aws_vpc" "main" {
    filter {
        name     = "tag:Name"
        values   = ["${var.project_name}-vpc"]
    }
}

data "aws_subnet" "public" {
    filter {
        name = "tag:Name"
        values = ["${var.project_name}-public-subnet"]
    }
}

data "aws_subnet" "private" {
    filter {
        name     = "tag:Name"
        values   = ["${var.project_name}-private-subnet"]
    }
}

# 기존 Web Security Group 참조
data "aws_security_group" "web" {
  filter {
    name   = "tag:Type"
    values = ["Web"]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
}

# 기존 App Security Group 참조
data "aws_security_group" "app" {
  filter {
    name   = "tag:Type"
    values = ["Application"]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  # 이름 패턴(필수 아님이지만 유지)
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  # 아키텍처 고정
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  # HVM 가상화
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  # EBS 기반 루트 디스크
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  # 순수 머신 이미지(컨테이너/커스텀 변종 배제)
  filter {
    name   = "image-type"
    values = ["machine"]
  }

  # 퍼블릭 이미지(사설/마켓플레이스 배제)
  filter {
    name   = "is-public"
    values = ["true"]
  }
}

resource "aws_key_pair" "main" {
    key_name     = var.key_pair_name
    public_key   = file("~/.ssh/${var.key_pair_name}.pub")

    tags = {
        Name         = "${var.project_name}-keypair"
        Environment  = var.environment
    }
}

resource "aws_instance" "web_server" {
    ami                      = data.aws_ami.amazon_linux.id
    instance_type            = var.instance_type
    key_name                 = aws_key_pair.main.key_name
    subnet_id                = data.aws_subnet.public.id
    vpc_security_group_ids   = [data.aws_security_group.web.id]

    associate_public_ip_address = true

    user_data = base64encode(templatefile("${path.module}/user_data/web_server.sh", {
        hostname = "${var.project_name}-web"
    }))

    tags = {
        Name         = "${var.project_name}-web-server"
        Environment  = var.environment
        Type         = "Web"
    }
}

resource "aws_instance" "app_server" {
    ami                      = data.aws_ami.amazon_linux.id
    instance_type            = var.instance_type
    key_name                 = aws_key_pair.main.key_name
    subnet_id                = data.aws_subnet.private.id
    vpc_security_group_ids   = [data.aws_security_group.app.id]

    user_data = base64encode(templatefile("${path.module}/user_data/app_server.sh", {
        hostname = "${var.project_name}-app"
        port     = "8080"
    }))

    tags = {
        Name         = "${var.project_name}-app-server"
        Environment  = var.environment
        Type         = "Application"
    }
}