# 如何在docker container中运行多个使用Nginx的MinIO Server [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

Nginx是一个开源的Web服务器和反向代理服务器。

在本文中，我们将学习如何使用Docker compose搭建一个Nginx和多个MinIO实例。

如果您想测试一下你的MinIO生产环境设置能否与nginx使用，并且你希望在docker容器中安装nginx而不是本地安装，那么本教程将对您有所帮助。

## 1. 前提条件

你需要有一个可运行的docker环境，如果没有，请参考[docker安装手册](https://docs.docker.com/engine/installation/ubuntulinux/).

## 2. 步骤

### 获取用于Docker Compose的MinIO设置

下载[docker-compose.yaml](https://github.com/minio/minio/blob/master/docs/orchestration/docker-compose/docker-compose.yaml?raw=true) 到你的当前工作目录。Docker Compose会自动拉取MinIO Docker镜像，所以不需要手动下载MinIO的安装文件。

### 在Docker Compose配置文件中加入nginx的配置

在`docker-compose.yml`中增加nginx服务配置：

```
nginx:
  build: ./conf/nginx/
  links:
    - minio1
    - minio2
    - minio3
    - minio4
  ports:
    - "8081:80"
  command: [nginx-debug, '-g', 'daemon off;']
```

注意：我们将会把其它nginx设置信息保存到文件夹`conf/nginx`中。另外，我们将在`conf/nginx/Dockerfile`中配置nginx build。这就是为什么我们在`nginx`服务配置中编写`build：./conf/nginx/`。

除了配置之外，我们还应该在当前的工作目录中创建nginx conf样板文件：

创建文件夹

```
$ mkdir -p conf/nginx/sites-available
```

修改nginx build设置：

```
$ echo "FROM nginx:alpine
RUN \\
  rm -f \\
    /etc/nginx/sites-available/minio_conf \\
    /etc/nginx/sites-enabled/minio_conf \\
    /etc/nginx/sites-enabled/default
ADD sites-available/ /etc/nginx/sites-available
COPY nginx.conf /etc/nginx/nginx.conf
RUN \\
  mkdir -p /etc/nginx/sites-enabled && \\
  ln -s /etc/nginx/sites-available/minio_conf /etc/nginx/sites-enabled/minio_conf
" > conf/nginx/Dockerfile
```

修改nginx server配置：
##### 注意: 这是默认的nginx配置，做了两处修改：
Nginx会加载我们的自定义设置`sites-enabled/minio_conf`，而不是默认的`conf.d/*.conf`

```
$ echo "user  nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '\$remote_addr - \$remote_user [\$time_local] \"\$request\" '
                      '\$status \$body_bytes_sent \"\$http_referer\" '
                      '\"\$http_user_agent\" \"\$http_x_forwarded_for\"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;
    #include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/minio_conf;
}
" > conf/nginx/nginx.conf
```

设置nginx将请求发送给你的docker上的minio服务：

```
$ echo "upstream minio_servers {
  server minio1:9000;
  server minio2:9000;
  server minio3:9000;
  server minio4:9000;
}

server {
  listen 80;
  location / {
    proxy_pass http://minio_servers;
    proxy_set_header Host \$http_host;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-NginX-Proxy true;
    proxy_ssl_session_reuse off;
    proxy_redirect off;
  }
}
" >  conf/nginx/sites-available/minio_conf
```

`up`所有的minio实例和nginx:

```
$ docker-compose up
```

现在你可以访问所有启动的minio实例：

```
$ curl http://localhost:8081
```
