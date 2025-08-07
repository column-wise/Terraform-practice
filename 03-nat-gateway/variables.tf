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

variable "availability_zone" {
    description = "가용 영역"
    type = string
    default = "ap-northeast-2a"
}