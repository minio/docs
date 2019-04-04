# 使用Certbot生成Let's Encrypt证书 [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)
[Let's Encrypt](https://letsencrypt.org/) 是一个新的免费的，自动的，开源的认证中心。

[Certbot](https://certbot.eff.org/)是Let's Encrypt的基于控制台的证书生成工具。

本文我们将使用Certbot生成Let's Encrypt证书。该证书将被部署在MinIO服务器中使用。

## 1. 前提条件
- 从[这里](https://docs.min.io/docs/minio-quickstart-guide)下载并安装MinIO Server。
- 从[这里](https://certbot.eff.org/)下载并安装Certbot。

## 2. 依赖
- 执行`certbot`时，需要打开443端口并确保可以访问。
- Certbot需要有root权限，因为只有root才允许绑定1024以下的端口。
- 本文我们将使用`myminio.com`这个域名，请在设置时改成你自己的域名。

## 3. 步骤

### 步骤1: 安装Certbot
参考[这里](https://certbot.eff.org/)安装Certbot。

### 步骤2: 生成Let's Encrypt证书
```sh
# certbot certonly --standalone -d myminio.com --staple-ocsp -m test@yourdomain.io --agree-tos
```

### 步骤3: 验证证书
列出`/etc/letsencrypt/live/myminio.com`里的证书。
```sh
$ ls -l /etc/letsencrypt/live/myminio.com
total 4
lrwxrwxrwx 1 root root  37 Aug  2 09:58 cert.pem -> ../../archive/myminio.com/cert4.pem
lrwxrwxrwx 1 root root  38 Aug  2 09:58 chain.pem -> ../../archive/myminio.com/chain4.pem
lrwxrwxrwx 1 root root  42 Aug  2 09:58 fullchain.pem -> ../../archive/myminio.com/fullchain4.pem
lrwxrwxrwx 1 root root  40 Aug  2 09:58 privkey.pem -> ../../archive/myminio.com/privkey4.pem
-rw-r--r-- 1 root root 543 May 10 22:07 README
```

### 步骤4: 使用证书给MinIO Server设置SSL。
Certbot生成的证书和key需要放到用户的home文件夹里。
```sh
$ cp /etc/letsencrypt/live/myminio.com/fullchain.pem /home/user/.minio/certs/public.crt
$ cp /etc/letsencrypt/live/myminio.com/privkey.pem /home/user/.minio/certs/private.key
```

### 步骤5: 修改证书的ownership。
```sh
$ sudo chown user:user /home/user/.minio/certs/private.key
$ sudo chown user:user /home/user/.minio/certs/public.crt
```

### 步骤6: 使用HTTPS启动MinIO Server。
启动MinIO Server,使用443端口。

```sh
$ sudo ./minio server --address ":443" /mnt/data
```

如果你用的是MinIO Docker版，则你需要
```sh
$ sudo docker run -p 443:443 -v /home/user/.minio:/root/.minio/ -v /home/user/data:/data minio/minio server --address ":443" /data
```

### 步骤7: 通过浏览器访问<https://myminio.com>。
![Letsencrypt](https://github.com/minio/cookbook/blob/master/docs/screenshots/letsencrypt-certbot-minio.jpg?raw=true)
