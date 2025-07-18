# outputs.tf

# Security Group IDs (다음 단계에서 참조용)
output "web_security_group_id" {
  description = "Web Security Group ID"
  value       = aws_security_group.web.id
}

output "app_security_group_id" {
  description = "App Security Group ID"
  value       = aws_security_group.app.id
}

output "db_security_group_id" {
  description = "DB Security Group ID"
  value       = aws_security_group.db.id
}

# Security Group Names
output "web_security_group_name" {
  description = "Web Security Group Name"
  value       = aws_security_group.web.name
}

output "app_security_group_name" {
  description = "App Security Group Name"
  value       = aws_security_group.app.name
}

output "db_security_group_name" {
  description = "DB Security Group Name"
  value       = aws_security_group.db.name
}

# VPC 정보 (참조한 VPC 확인용)
output "vpc_id" {
  description = "Referenced VPC ID"
  value       = data.aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "Referenced VPC CIDR block"
  value       = data.aws_vpc.main.cidr_block
}

# 다음 단계에서 사용할 종합 정보
output "security_groups_info" {
  description = "Security Groups 정보 요약"
  value = {
    vpc_id    = data.aws_vpc.main.id
    web_sg_id = aws_security_group.web.id
    app_sg_id = aws_security_group.app.id
    db_sg_id  = aws_security_group.db.id
    admin_ip  = var.admin_ip
  }
}

# 보안 그룹 규칙 요약 (확인용)
output "security_rules_summary" {
  description = "보안 그룹 규칙 요약"
  value = {
    web_inbound = [
      "HTTP(80) from 0.0.0.0/0",
      "HTTPS(443) from 0.0.0.0/0",
      "SSH(22) from ${var.admin_ip}"
    ]
    app_inbound = [
      "HTTP(8080) from Web SG",
      "SSH(22) from ${var.admin_ip}"
    ]
    db_inbound = [
      "MySQL(3306) from App SG",
      "SSH(22) from ${var.admin_ip}"
    ]
    all_outbound = "All traffic allowed"
  }
}
