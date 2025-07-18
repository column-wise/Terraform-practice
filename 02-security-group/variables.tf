variable "project_name" {
  description = "프로젝트 이름"
  type        = string
  default     = "terraform-practice"
}

variable "environment" {
  description = "환경 (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "admin_ip" {
  description = "관리자 IP (SSH 접근용)"
  type        = string
  default     = "0.0.0.0/0" # 실습용, 실제로는 본인 IP 입력
}
