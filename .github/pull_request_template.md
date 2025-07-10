<!--
✅ PR 제목 작성 가이드

- 규칙: [태그] Summary 형태로 작성
- 예시:
  - [Step 01] Implement VPC networking infrastructure
  - [feat] Add NAT Gateway and routing logic
  - [docs] Improve README with architecture diagrams
  - [refactor] Clean subnet module structure

태그 예시: Step xx, feat, fix, chore, refactor, docs, test, ci
-->

## 📋 Overview

<!-- 이 PR에서 무엇을 했는지 요약하세요 -->
<!-- 예: 구현한 인프라, 리팩토링한 모듈, 문서화한 내용 등 -->

## 🎯 Learning Objectives

<!-- 이 PR의 목표 또는 학습/개선 의도 -->
<!-- 예: VPC 구성 이해, 모듈화 실습, 보안 그룹 정책 개선 등 -->
<!--
README에 학습 목표를 작성했다면 해당 내용을 체크리스트 형태로 표시해도 좋습니다.
- [x] Understand AWS VPC networking fundamentals (CIDR, subnets, routing)
- [x] Learn Terraform resource dependencies and infrastructure as code
- [x] Practice network architecture design and implementation
- [x] Experience complete terraform workflow (init → plan → apply → destroy)
-->

## 🏗️ Infrastructure Implemented

<!-- 주요 리소스 변경 내용을 요약 -->
<!-- Terraform 리소스, AWS 구성 요소 등 -->
<!-- bullet list로 명확하게
- **VPC**: `10.0.0.0/16` with DNS hostnames and support enabled
- **Public Subnet**: `10.0.1.0/24` in `ap-northeast-2a` with auto-assign public IP
- **Private Subnet**: `10.0.2.0/24` in `ap-northeast-2a` for internal resources
- **Internet Gateway**: Enables public subnet internet connectivity
- **Route Tables**: Separate routing for public (IGW) and private (local-only) traffic
- **Route Table Associations**: Proper subnet-to-route-table bindings
-->

## 📚 Documentation Added

<!-- 작성하거나 수정한 문서 내용 (있는 경우) -->

<!--
- **AWS VPC Concepts**: Detailed explanation of networking components
- **Hands-on Lab Guide**: Step-by-step instructions for infrastructure setup
- **Architecture Diagrams**: Mermaid visualizations for better understanding
  - Network topology and component relationships
  - Traffic flow patterns and routing examples
  - Resource dependency graphs
  - Creation sequence visualization
-->

## 🔄 Terraform Workflow

```bash
terraform init    # Provider setup and dependency locking
terraform plan     # Review 8 resources to be created
terraform apply    # Deploy VPC infrastructure
terraform output   # Verify network configuration
terraform destroy  # Clean up resources
```
