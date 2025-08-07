# NAT Gateway 정보
output "nat_gateway_id" {
    description = "NAT Gateway ID"
    value = aws_nat_gateway.main.id
}

output "nat_gateway_private_ip" {
    description = "NAT Gateway Private IP"
    value = aws_nat_gateway.main.private_ip
}

output "nat_gateway_public_ip" {
  description = "NAT Gateway Public IP (Elastic IP)"
  value = aws_eip.nat.public_ip
}

# Elastic IP 정보
output "elastic_ip_id" {
    description = "Elastic IP Allocation ID"
    value = aws_eip.nat.id
}

output "elastic_ip_address" {
    description = "Elastic IP Address"
    value = aws_eip.nat.public_ip
}

# 참조한 리소스 정보 (확인용)
output "vpc_id" {
    description = "Referenced VPC ID"
    value = data.aws_vpc.main.id
}

output "private_subnet_id" {
    description = "Referenced Private Subnet ID"
    value = data.aws_subnet.private.id
}

output "private_route_table_id" {
    description = "Referenced Private Route Table ID"
    value = data.aws_route_table.private.id
}

# 다음 단계에서 사용할 종합 정보
output "nat_gateway_info" {
    description = "NAT Gateway 정보 요약"
    value = {
        nat_gateway_id = aws_nat_gateway.main.id
        elastic_ip = aws_eip.nat.public_ip
        vpc_id = data.aws_vpc.main.id
        public_subnet_id = data.aws_subnet.public.id
        private_subnet_id = data.aws_subnet.private.id
    }
}

# 네트워크 구성 요약 (확인용)
output "network_summary" {
  description = "네트워크 구성 요약"
  value = {
    vpc_cidr = data.aws_vpc.main.cidr_block
    public_subnet_cidr = data.aws_subnet.public.cidr_block
    private_subnet_cidr = data.aws_subnet.private.cidr_block
    nat_gateway_location = "Public Subnet"
    private_internet_route = "0.0.0.0/0 → NAT Gateway"
  }
}