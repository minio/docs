# How to run multiple Minio servers with Nginx inside docker container [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

Nginx is an open source Web server and a reverse proxy server.

This cookbook will explain how you
can setup multiple Minio instances and Nginx via Docker compose, which you can access through Nginx.

This tutorial will be helpful in case when you need to test that your Minio production setup will work.

## 1. Prerequisites

You have Docker installed and running, if not follow [install instructions](https://docs.docker.com/engine/installation/ubuntulinux/).

## 2. Steps

### Fetch Minio configuration for Docker Compose

To deploy distributed Minio on Docker Compose, please download [docker-compose.yaml](https://github.com/minio/minio/blob/master/docs/orchestration/docker-compose/docker-compose.yaml?raw=true) to your current working directory. Note that Docker Compose pulls the Minio Docker image, so there is no need to explicitly download Minio binary.

### Add nginx service's settings into Docker Compose configuration

You will need to add configuration, that it can proxy incoming requests on multiple minio services.

Add nginx service's configuration in `docker-compose.yml`.

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

Note: we will store other nginx settings in separated folder `conf/nginx`. Also we will configure nginx build in `conf/nginx/Dockerfile` That's why we wrote `build: ./conf/nginx/` in `nginx` service config.

Beside the configuration we should create nginx conf boilerplate, inside your current working dir run:

Create folders

```
$ mkdir -p conf/nginx/sites-available
```

Modify nginx build setup:

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

Modify nginx server config
##### NOTE: here is defualt nginx config, with 2 differences:
Nginx will load `sites-enabled/minio_conf` our custom config instead default `conf.d/*.conf`

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

Say nginx to send request on one of your docker's minio service:

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

`up` all minio instances and nginx:

```
$ docker-compose up
```

Now you can reach all the launched Minio instances:

```
$ curl http://localhost:8081
```
