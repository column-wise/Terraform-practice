variable "project_name" {
    description = "프로젝트 이름"
    type = string
    default = "terraform-practice"
}

variable "environment" {
    description = "환경 (dev, staging, prod)"
    type = string
    default = "dev"
}

variable "vpc_cidr" {
    description = "VPC CIDR 블록"
    type = string
    default = "10.0.0.0/16"
}

variable "availability_zone" {
    description = "가용 영역"
    type = string
    default = "ap-northeast-2a"
}

variable "public_subnet_cidr" {
    description = "Public Subnet CIDR 블록"
    type = string
    default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
    description = "Private Subnet CIDR 블록"
    type = string
    default = "10.0.2.0/24"
}