#!/bin/bash

# 시스템 업데이트
yum update -y

# Apache HTTP Server, PHP 설치
yum install -y httpd
yum install -y php php-cli php-common
yum install -y php-curl

# 간단한 웹 페이지 생성
cat > /var/www/html/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>${hostname} Web Server</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            margin: 40px; 
            background-color: #f5f5f5;
        }
        .container {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .status { color: #28a745; }
        .info { background: #e7f3ff; padding: 10px; border-radius: 4px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🌐 ${hostname} Web Server</h1>
        <p class="status">✅ Apache HTTP Server is running!</p>
        
        <div class="info">
            <h3>Server Information:</h3>
            <p><strong>Hostname:</strong> <span id="hostname">Loading...</span></p>
            <p><strong>Instance ID:</strong> <span id="instance-id">Loading...</span></p>
            <p><strong>Local IP:</strong> <span id="local-ip">Loading...</span></p>
            <p><strong>Public IP:</strong> <span id="public-ip">Loading...</span></p>
            <p><strong>Region:</strong> <span id="region">Loading...</span></p>
        </div>
        
        <p><em>Deployed via Terraform with user_data</em></p>
    </div>

    <script>
        async function getMetadata() {
            try {
              const resp = await fetch('/server-info.php', { cache: 'no-store' });
              const data = await resp.json();
              document.getElementById('instance-id').textContent = data.instanceId || 'N/A';
              document.getElementById('local-ip').textContent   = data.localIp    || 'N/A';
              document.getElementById('public-ip').textContent  = data.publicIp   || 'N/A';
              document.getElementById('region').textContent     = data.region     || 'N/A';
              if (document.getElementById('hostname')) {
                document.getElementById('hostname').textContent = data.hostname || 'N/A';
                // 페이지 <title>과 H1도 동기화 (선택)
                document.title = (data.hostname || 'Web') + ' Web Server';
              }
            } catch (e) {
              console.error('server-info.php error', e);
            }
        }
        window.onload = getMetadata;
    </script>
</body>
</html>
EOF

cat > /var/www/html/server-info.php << 'EOF'
<?php
header('Content-Type: application/json'); header('Cache-Control: no-store');
$ch = curl_init('http://169.254.169.254/latest/api/token');
curl_setopt_array($ch, [
  CURLOPT_CUSTOMREQUEST => 'PUT',
  CURLOPT_HTTPHEADER    => ['X-aws-ec2-metadata-token-ttl-seconds: 21600'],
  CURLOPT_RETURNTRANSFER => true,
  CURLOPT_TIMEOUT       => 2
]);
$token = curl_exec($ch);
curl_close($ch);

function meta($path, $token) {
  $ch = curl_init('http://169.254.169.254/latest/'.$path);
  curl_setopt_array($ch, [
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_HTTPHEADER     => ['X-aws-ec2-metadata-token: '.$token],
    CURLOPT_TIMEOUT        => 2
  ]);
  $res = curl_exec($ch);
  curl_close($ch);
  return $res ?: null;
}

echo json_encode([
  'hostname'   => meta('meta-data/hostname', $token),
  'instanceId' => meta('meta-data/instance-id', $token),
  'localIp'    => meta('meta-data/local-ipv4', $token),
  'publicIp'   => @meta('meta-data/public-ipv4', $token),
  'region'     => meta('meta-data/placement/region', $token),
]);
EOF

# Apache 서비스 시작 및 자동 시작 설정
systemctl restart httpd

# Apache 서비스 시작 및 자동 시작 설정
systemctl start httpd
systemctl enable httpd

# 로그 확인을 위한 유용한 도구들 설치
yum install -y htop wget curl

# 설치 완료 로그
echo "$(date): Web server setup completed" >> /var/log/user_data.log