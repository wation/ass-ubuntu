server {
  server_name magixun.com;

  client_max_body_size 20m;

  # 静态文件直接服务，不经过 Next.js
  location /uploads/ {
    alias /opt/ass/public/uploads/;
    expires 30d;
    add_header Cache-Control "public, immutable";
    try_files $uri $uri/ =404;
  }

  # 已经是买家端路径：直接转发
  location ^~ /buyer/ {
    proxy_pass http://127.0.0.1:3000;
    proxy_http_version 1.1;

    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;

    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
  }

  # 根路径：跳到买家端首页
  location = / {
    return 302 /buyer;
  }

  # 规范化 /buyer/ -> /buyer，避免某些环境下尾斜杠导致循环跳转
  location = /buyer/ {
    return 308 /buyer;
  }

  # 其他路径：正常转发（不做全站 rewrite，避免重定向循环）
  location / {
    proxy_pass http://127.0.0.1:3000;
    proxy_http_version 1.1;

    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;

    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
  }

    listen 443 ssl; # managed by Certbot
    listen [::]:443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/magixun.com-0001/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/magixun.com-0001/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}
server {
    if ($host = magixun.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


  server_name magixun.com;
  listen 80;
  listen [::]:80;
    return 404; # managed by Certbot


}