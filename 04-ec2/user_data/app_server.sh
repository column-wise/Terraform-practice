#!/bin/bash

# 시스템 업데이트
yum update -y

# 개발 도구 설치
yum groupinstall -y "Development Tools"
yum install -y git wget curl htop tree

# Node.js 설치 (애플리케이션 서버)
curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs

# 애플리케이션 디렉토리 생성
mkdir -p /opt/app
cd /opt/app

# package.json 생성
cat > package.json << 'EOF'
{
  "name": "${hostname}-app",
  "version": "1.0.0",
  "description": "Simple Express app for Terraform practice",
  "main": "app.js",
  "scripts": {
    "start": "node app.js"
  },
  "dependencies": {
    "express": "^4.18.0"
  }
}
EOF

# Express 애플리케이션 생성
cat > app.js << 'EOF'
const express = require('express');
const os = require('os');
const app = express();
const port = ${port};

app.get('/', (req, res) => {
  res.json({
    message: '${hostname} Application Server',
    hostname: os.hostname(),
    uptime: os.uptime(),
    memory: {
      total: os.totalmem(),
      free: os.freemem()
    },
    platform: os.platform(),
    timestamp: new Date().toISOString()
  });
});

app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    service: '${hostname}',
    timestamp: new Date().toISOString()
  });
});

app.listen(port, '0.0.0.0', () => {
  console.log(`${hostname} app listening at http://0.0.0.0:${port}`);
});
EOF

# NPM 패키지 설치
npm install

# 백그라운드에서 Node.js 앱 실행
nohup node app.js > /var/log/nodejs-app.log 2>&1 &

# 네트워크 테스트 도구 설치
yum install -y telnet nc bind-utils

# NAT Gateway 테스트 스크립트 생성
cat > /home/ec2-user/test_nat_gateway.sh << 'EOF'
#!/bin/bash
echo "=== NAT Gateway 연결 테스트 ==="
echo "1. 외부 IP 확인 (NAT Gateway IP가 나와야 함):"
curl -s http://checkip.amazonaws.com || echo "외부 IP 조회 실패"

echo -e "\n2. DNS 해상도 테스트:"
nslookup google.com || echo "DNS 해상도 실패"

echo -e "\n3. 패키지 저장소 접근 테스트:"
curl -s -o /dev/null -w "HTTP Status: %%{http_code}\n" \
  https://cdn.amazonlinux.com/al2023/core/latest/x86_64/mirror.list

echo -e "\n4. 일반 웹사이트 접근 테스트:"
curl -s -o /dev/null -w "HTTP Status: %%{http_code}\n" https://www.google.com

echo -e "\n5. Node.js 애플리케이션 상태:"
curl -s localhost:${port}/health | head -n 1

echo -e "\n=== 테스트 완료 ==="
EOF

chmod +x /home/ec2-user/test_nat_gateway.sh
chown ec2-user:ec2-user /home/ec2-user/test_nat_gateway.sh

# 설치 완료 로그
echo "$(date): App server setup completed" >> /var/log/user_data.log