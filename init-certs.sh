#!/bin/bash

# 检查并安装 certbot
if ! command -v certbot &> /dev/null; then
    apt-get update
    apt-get install -y certbot
fi

# 申请证书
certbot certonly --standalone --non-interactive --agree-tos -m helloyang9@gmail.com -d www.helloweb3.online
certbot certonly --standalone --non-interactive --agree-tos -m helloyang9@gmail.com -d tr.helloweb3.online
certbot certonly --standalone --non-interactive --agree-tos -m helloyang9@gmail.com -d dev.helloweb3.online

# 创建证书目录
mkdir -p ./certs/www.helloweb3.online
mkdir -p ./certs/tr.helloweb3.online
mkdir -p ./certs/dev.helloweb3.online

# 复制实际的证书文件（使用 -L 选项跟随软链接）
cp -L /etc/letsencrypt/live/www.helloweb3.online/fullchain.pem ./certs/www.helloweb3.online/
cp -L /etc/letsencrypt/live/www.helloweb3.online/privkey.pem ./certs/www.helloweb3.online/
cp -L /etc/letsencrypt/live/tr.helloweb3.online/fullchain.pem ./certs/tr.helloweb3.online/
cp -L /etc/letsencrypt/live/tr.helloweb3.online/privkey.pem ./certs/tr.helloweb3.online/
cp -L /etc/letsencrypt/live/dev.helloweb3.online/fullchain.pem ./certs/dev.helloweb3.online/
cp -L /etc/letsencrypt/live/dev.helloweb3.online/privkey.pem ./certs/dev.helloweb3.online/

# 设置权限
chmod 644 ./certs/*/*.pem

# 设置自动续期和复制
(crontab -l 2>/dev/null; echo "0 0 1 * * certbot renew --quiet && $(pwd)/init-certs.sh") | crontab -