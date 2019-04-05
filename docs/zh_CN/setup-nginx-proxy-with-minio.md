# 为MinIO Server设置Nginx代理 [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

Nginx是一个开源的Web服务器和反向代理服务器。  

在本文中，我们将学习如何给MinIO Server设置Nginx代理。

## 1. 前提条件

从[这里](https://docs.min.io/docs/minio-quickstart-guide)下载并安装MinIO Server。

## 2. 安装

从[这里](http://nginx.org/en/download.html)安装Nginx。

## 3. 配置

### 标准的Root配置
在文件``/etc/nginx/sites-enabled``中添加下面的内容，同时删除同一个目录中现有的``default``文件。

```sh
server {
 listen 80;
 server_name example.com;
 location / {
   proxy_set_header Host $http_host;
   proxy_pass http://localhost:9000;
 }
}
```

注意:

* 用你自己的主机名替换example.com。
* 用你自己的服务名替换``http://localhost:9000``。
* 为了能够上传大文件，在``http``上下文中添加``client_max_body_size 1000m;``，只需按你的需求调整该值。默认值是`1m`，对大多数场景来说太低了。

### 非Root配置
当需要非root配置时，按如下方式修改location：

```sh
 location ~^/files {
   proxy_buffering off;
   proxy_set_header Host $http_host;
   proxy_pass http://localhost:9000;
 }
```

注意:

* 用你自己的服务名替换`http://localhost:9000`。
* 用所需的路径替换`files`。这不能是`~^/minio`，因为`minio`是minio中的保留字。
* 所使用的路径（在本例中为`files`）按照惯例，应设置为minio所使用的存储桶的名称。
* 可以通过添加更多类似于上面定义的location定义来访问其他存储桶。

### 使用Rewrite的非Root配置
以下location配置允许访问任何存储桶，但只能通过未签名的URL，因此只能访问公开的存储桶。

```sh
 location ~^/files {
   proxy_buffering off;
   proxy_set_header Host $http_host;
   rewrite ^/files/(.*)$ /$1 break;
   proxy_pass http://localhost:9000;
 }
```

注意:

* 用你自己的服务名替换`http://localhost:9000`。
* 用所需的路径替换`files`。
* 使用的存储桶必须是公开的，通常情况是可公开读和公开写。
* 使用的网址必须是无符号的，因为nginx会更改网址并使签名无效。

## 4. 步骤

### 第一步: 启动MinIO Server。

```sh
minio server /mydatadir
```

### 第二步: 重启Nginx server。

```sh
sudo service nginx restart
```

## 了解更多

参考[这里](https://www.nginx.com/blog/enterprise-grade-cloud-storage-nginx-plus-minio/)了解更多MinIO和Nginx的配置选项。
