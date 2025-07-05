# terraform-practice

# 테라폼이란?

<details><summary>자세히 보기</summary>

Terraform은 하시코프(HashiCorp)사에서 만든 오픈 소스 IaC 도구  
클라우드 및 온프레이스 리소스를 코드로 빌드, 변경, 버전 관리할 수 있도록 만든다.

### IaC는 뭐냐

IaC는 Infra as Code의 줄임말로, 수동 프로세스가 아닌 코드를 통해 인프라를 관리하고 프로비저닝 하는 것을 말한다.

개발자는 애플리케이션 개발, 테스트 및 배포를 위해 인프라를 생성, 설정, 관리해줘야 하는데  
수동 인프라 관리(사람이 직접 클릭하거나 명령어로 설정)는 시간이 많이 걸리고 오류가 발생하기 쉽다.

IaC는 이런 인프라 관리를 자동화하고, 버전 관리와 재현 가능성을 높여준다.

#### IaC의 이점

1. 환경 복제 용이

   동일한 코드로 다른 지역/서버에 동일한 환경을 빠르게 복제할 수 있다.

2. 구성 오류 감소

   수동 설정의 실수를 줄이고, 변경 사항을 코드로 관리함으로써 일관성을 유지할 수 있다.  
   문제가 생기면 이전 코드 상태로 쉽게 롤백도 가능하다.

3. 모범 사례 반복 가능

   Git 등의 버전 관리 시스템과 연계해 다양한 실험 환경(branch)를 쉽게 만들 수 있으며,  
   성능이 다른 인스턴스, 다른 리전에 배포하기도 쉽다.

## 테라폼 작동 방식

Terraform은 API를 이용해 클라우드 플랫폼 및 기타 서비스의 리소스를 생성하고 관리한다.  
이 과정에서 Provider가 해당 플랫폼의 API와 Terraform을 연결해주는 역할을 한다.

![intro-terraform-apis](https://web-unified-docs-hashicorp.vercel.app/api/assets/terraform/latest/img/docs/intro-terraform-apis.png)

HashiCorp와 커뮤니티가 수천 개의 provider를 이미 만들어 두었으며,  
AWS, GCP, Azure, Kubernetes, GitHub, Datadog 등 대부분의 플랫폼을 지원한다.  
공식 레지스트리: https://registry.terraform.io/

## 테라폼 작업 흐름

![intro-terraform-workflow](https://web-unified-docs-hashicorp.vercel.app/api/assets/terraform/latest/img/docs/intro-terraform-workflow.png)

### 1. Write

'.tf' 파일로 원하는 인프라 리소스를 정의한다.  
 ex) VPC, EC2 인스턴스, 보안 그룹, 로드밸런서 등

### 2. Plan

현재 상태와 비교해 어떤 리소스를 만들고, 변경하고, 삭제할지 실행 계획을 출력한다.

### 3. Apply

사용자가 승인하면, Terraform이 의존 관계를 고려하여 리소스를 실제로 생성/변경/삭제한다.  
ex) VPC를 먼저 만든 후 인스턴스를 생성하는 등 순서를 자동으로 맞춤

## 왜 테라폼을 써야 할까????

Terraform은 복잡한 인프라를 코드로 안전하게 정의하고, 추적하며, 자동화하고, 협업할 수 있도록 도와준다.

### 어떤 인프라도 관리 가능

- Terraform은 AWS, GCP, Azure, Github, Kubernetes 등 대부분의 플랫폼에 대한 provider를 지원
- 직접 custom provider도 작성 가능
- 인프라를 '불변' 상태로 다뤄 변경이나 업그레이드 과정에서의 복잡도를 줄여준다.

<details>
<summary>※ 인프라를 '불변(Immutable)'으로 다룬다는 것?</summary>
한 번 배포된 인프라는 설정 변경을 하지 않음.

기존 인프라에 수정이 필요하면, 수정 사항이 반영된 새 리소스를 만들어 교체함.

#### 불변 인프라의 장점

- 안정성: 문제가 생겨도 서비스 영향 없이 롤백 가능
- 예측가능성: 리소스를 매번 새로 생성하므로, 변경 결과가 항상 동일하고 일관됨
- 구성 편차(drift) 감소: 수동 변경이나 외부 변경이 끼어들 여지를 줄임

---

</details>

### 인프라 상태 추적

- 변경 전 'plan' 명령어로 변경 내역을 확인하고 승인할 수 있음.
- 실제 인프라의 상태는 '.tfstate' 파일로 관리, 현실과 코드 간 싱크를 유지함.
- 이 상태 파일을 기준으로 Terraform이 어떤 변경을 수행할지 결정

### 변경 자동화

- Terraform은 선언형 언어(HCL) 를 사용함
- 최종 상태만 선언하면, Terraform이 무엇을 어떻게 해야 할지 내부적으로 판단해서 실행함
- 리소스 간 의존성을 분석해 병렬로 생성하거나 변경 → 빠르고 효율적

### 구성 표준화

- 자주 쓰는 인프라 조합은 모듈(Module) 로 추상화 가능
- 반복되는 코드를 줄이고 베스트 프랙티스를 재사용
- Terraform Registry에서 공개된 모듈도 활용 가능

### 협업에 강함

- `.tf` 파일은 코드로 작성되므로\*Git 등 버전 관리 시스템과 궁합이 좋음
- HCP Terraform을 활용하면 팀 간 협업도 가능:
  - 공유 상태 관리
  - 민감 정보(secret) 보호
  - 권한 분리(RBAC)
  - 사설 모듈/프로바이더 공유 등

## 참고

- https://developer.hashicorp.com/terraform/intro
- https://aws.amazon.com/ko/what-is/iac/
- https://btcd.tistory.com/262
- https://velog.io/@borab/terraform-이란
- https://sonit.tistory.com/13
- https://velog.io/@seunghyeon/불변-인프라-Immutable-Infrastructure
- https://canaryrelease.tistory.com/66
</details>

<br>

# 실습 repo 구조

| 디렉토리                  | 설명                                                                                             |
| ------------------------- | ------------------------------------------------------------------------------------------------ |
| **00-provider-setup/**    | Terraform 설치 및 설정, HCL 문법, `init`·`plan`·`apply` 워크플로우, 상태 파일 개념               |
| **01-vpc/**               | VPC, Public/Private Subnet, 인터넷 게이트웨이, 라우팅 테이블 구성                                |
| **02-security-group/**    | 인바운드/아웃바운드 보안 그룹 규칙 설계 및 실습                                                  |
| **03-nat-gateway/**       | NAT 게이트웨이 구성, 프라이빗 서브넷 인터넷 접근 실습                                            |
| **04-ec2/**               | EC2 인스턴스 프로비저닝, user_data를 이용한 초기화 스크립트 실습                                 |
| **05-auto-scaling/**      | Auto Scaling Group 생성, Launch Configuration/Template, Scaling Policy 구성                      |
| **06-load-balancer/**     | ALB/NLB 생성 및 리스너·타겟 그룹 설정, 헬스체크 실습                                             |
| **07-rds/**               | RDS(MySQL 등) 생성, 파라미터 그룹·백업 설정, 멀티 AZ 구성 실습                                   |
| **08-s3/**                | S3 버킷 생성, 버전 관리, 접근 정책, 정적 웹호스팅                                                |
| **09-secrets-manager/**   | AWS Secrets Manager (및 SSM Parameter Store) 연동, 민감 정보 관리                                |
| **10-acm-ssl/**           | ACM을 이용한 SSL/TLS 인증서 발급·갱신, ELB 및 CloudFront 연동                                    |
| **11-cloudfront/**        | CloudFront 배포, 오리진 설정, 캐싱 정책, OAI 실습                                                |
| **12-lambda/**            | Lambda 함수 생성·배포, IAM 역할 연결, 환경 변수 관리                                             |
| **13-api-gateway/**       | API Gateway 설정, Lambda/HTTP 통합, 스테이지·도메인 설정                                         |
| **14-ecr-and-ecs/**       | ECR에 Docker 이미지 푸시, ECS Fargate 서비스 배포                                                |
| **15-cloudwatch/**        | 로그 수집(CW Logs), 메트릭, 대시보드, 알람 설정                                                  |
| **16-iam/**               | IAM 사용자·역할·정책, 정책 문법, 권한 위임 패턴                                                  |
| **17-route53/**           | Route 53 레코드 관리, ALIAS 레코드, 헬스체크 연동                                                |
| **18-waf/**               | WAF 웹 ACL 생성, 리전·Global 배포, 규칙 관리                                                     |
| **19-bastion-host/**      | Bastion Host 구성, Session Manager 연동, SSH 접근 통제                                           |
| **20-backup-strategy/**   | EBS 스냅샷, RDS 백업 정책, S3 버전 관리, 수명 주기 설정                                          |
| **21-modules/**           | 공통 리소스 모듈화, 입력·출력 변수 설계, Terratest 모듈 테스트                                   |
| **22-remote-backend/**    | S3 + DynamoDB를 이용한 상태 파일 원격 저장소 구성                                                |
| **23-ci-cd-pipeline/**    | GitHub Actions / Terraform Cloud / Atlantis, PR→Plan/Apply 자동화                                |
| **24-cost-optimization/** | Reserved Instances, Savings Plans, `terraform cost-estimation`, 예산 알람                        |
| **25-disaster-recovery/** | 멀티 리전 백업, RTO/RPO 설계, 자동 복구 워크플로우                                               |
| **26-optional-advanced/** | VPC Peering/Transit Gateway, ElastiCache, SQS/SNS, EventBridge, CloudFormation vs Terraform 비교 |
| **99-examples/**          | 종합 예제: 전체 인프라 구성 (VPC + EC2 + RDS + S3 + ALB + Autoscaling 등)                        |

<br>

# 설치 및 실행 방법

## 1. Terraform 설치

- https://developer.hashicorp.com/terraform/install 참고
- 또는 `tfenv`, `tfswitch`를 이용해 원하는 버전 설치
- 저는 [tfswitch](https://tfswitch.warrensbox.com/)를 이용했습니다.

## 2. AWS 인증 정보 설정 (`~/.aws/credentials` 파일에 인증 정보 저장)

[AWS CLI](https://docs.aws.amazon.com/ko_kr/cli/latest/userguide/getting-started-install.html)를 먼저 설치하고 아래 명령어로 설정:

```bash
aws configure
```

입력 항목:

```bash
AWS Access Key ID [None]: your_access_key
AWS Secret Access Key [None]: your_secret_key
Default region name [None]: ap-northeast-2
Default output format [None]: json
```

파일은

```bash
~/.aws/credentials
~/.aws/config
```

여기에 저장되고, Terraform은 자동으로 이 파일들을 인식

## 3. 실습 디렉토리로 이동 후 초기화 & 실행

```bash
cd 01-vpc
terraform init
terraform plan
terraform apply
```

<br>

# 실습 환경

- Terraform 1.12+
- AWS (VPC, EC2, RDS, S3, ALB, IAM 등)
- Git & GitHub
- GitHub Actions (CI/CD 파트)
- Terraform Registry 모듈

<br>

# 실습 목표

- IaC를 통한 클라우드 인프라 구성 및 자동화 경험
- 모듈화된 인프라 설계 학습
- 멱등성, 불변 인프라, 상태 추적 개념 이해
- Terraform의 Plan → Apply → Destroy 흐름 익히기
- Terraform 상태 관리, 원격 백엔드 구성
