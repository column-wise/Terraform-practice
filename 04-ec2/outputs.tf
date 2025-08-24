# EC2 인스턴스 정보
output "web_server_id" {
  description = "Web Server Instance ID"
  value       = aws_instance.web_server.id
}

output "web_server_public_ip" {
  description = "Web Server Public IP"
  value       = aws_instance.web_server.public_ip
}

output "web_server_private_ip" {
  description = "Web Server Private IP"
  value       = aws_instance.web_server.private_ip
}

output "app_server_id" {
  description = "App Server Instance ID"
  value       = aws_instance.app_server.id
}

output "app_server_private_ip" {
  description = "App Server Private IP"
  value       = aws_instance.app_server.private_ip
}

# SSH 접속 정보
output "ssh_commands" {
  description = "SSH 접속 명령어"
  value = {
    web_server = "ssh -i ~/.ssh/${var.key_pair_name} ec2-user@${aws_instance.web_server.public_ip}"
    app_server_via_web = "ssh -i ~/.ssh/${var.key_pair_name} -J ec2-user@${aws_instance.web_server.public_ip} ec2-user@${aws_instance.app_server.private_ip}"
  }
}

# 웹 서비스 접속 정보
output "web_service_urls" {
  description = "웹 서비스 접속 URL"
  value = {
    web_server_http = "http://${aws_instance.web_server.public_ip}"
    web_server_info = "http://${aws_instance.web_server.public_ip}/server-info.php"
    app_server_api = "http://${aws_instance.app_server.private_ip}:8080" # Private IP로만 접근 가능
  }
}

# 키 페어 정보
output "key_pair_name" {
  description = "SSH Key Pair Name"
  value       = aws_key_pair.main.key_name
}

# AMI 정보 (확인용)
output "ami_info" {
  description = "사용된 AMI 정보"
  value = {
    ami_id   = data.aws_ami.amazon_linux.id
    ami_name = data.aws_ami.amazon_linux.name
  }
}

# 참조한 리소스 정보 (확인용)
output "referenced_resources" {
  description = "참조한 리소스 정보"
  value = {
    vpc_id            = data.aws_vpc.main.id
    public_subnet_id  = data.aws_subnet.public.id
    private_subnet_id = data.aws_subnet.private.id
    web_sg_id        = data.aws_security_group.web.id
    app_sg_id        = data.aws_security_group.app.id
  }
}

# 종합 정보 (다음 단계 활용용)
output "ec2_instances_info" {
  description = "EC2 인스턴스 종합 정보"
  value = {
    web_server = {
      instance_id = aws_instance.web_server.id
      public_ip   = aws_instance.web_server.public_ip
      private_ip  = aws_instance.web_server.private_ip
      subnet_id   = data.aws_subnet.public.id
    }
    app_server = {
      instance_id = aws_instance.app_server.id
      private_ip  = aws_instance.app_server.private_ip
      subnet_id   = data.aws_subnet.private.id
    }
    key_pair = {
      name = aws_key_pair.main.key_name
    }
  }
}