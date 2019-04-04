# 为MinIO Server设置Apache HTTP proxy [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

Apache HTTP是一个开源Web服务器和一个反向代理服务器。  

在本文中，我们将学习如何使用mod_proxy模块来设置Apache HTTP以连接到MinIO Server。我们将为example.com建立一个新的VirtualHost

## 1. 前提条件

从[这里](https://docs.min.io/docs/minio-quickstart-guide)下载并安装MinIO Server。 记住它的IP和端口。

## 2. 安装

从[这里](https://httpd.apache.org/#downloading)安装Apache HTTP server。通常，mod_proxy模块默认是启用的。
你也可以使用你的操作系统repositories（例如yum，apt-get）。

## 3. 步骤

### 第一步:配置反向代理。

在Apache配置目录下创建一个文件，例如``/etc/httpd/conf.d/minio-vhost.conf``

```sh
<VirtualHost *:80>
    ServerName example.com
    ErrorLog /var/log/httpd/example.com-error.log
    CustomLog /var/log/httpd/example.com-access.log combined

    ProxyRequests Off
    ProxyVia Block
    ProxyPreserveHost On

    <Proxy *>
         Require all granted
    </Proxy>

    ProxyPass / http://localhost:9000/
    ProxyPassReverse / http://localhost:9000/
</VirtualHost>
```

注意: 

* 用你自己的主机名替换example.com。
* 用你自己的服务器名称替换``http://localhost:9000``。


### 第二步:启动MinIO。 

```sh
minio server /mydatadir
```

### 第三步: 重启Apache HTTP server。

```sh
sudo service httpd restart
```
