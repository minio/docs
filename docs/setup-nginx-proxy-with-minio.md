# Setup Nginx proxy with Minio Server [![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/minio/minio?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Nginx is an open source Web server and a reverse proxy server.  

In this recipe we will learn how to set up Nginx proxy with Minio Server. 

## 1. Prerequisites

Install Minio Server from [here](http://docs.minio.io/docs/minio).

## 2. Installation

Install Nginx from [here](http://nginx.org/en/download.html).  

## 3. Configuration

Add  below content as a file ``/etc/nginx/sites-enabled``  and also remove the existing ``default`` file in same directory.

```sh

server {
 listen 80;
 server_name example.com;
 location / {
   proxy_set_header Host $http_host;
   proxy_set_header X-Real-IP $remote_addr;
   proxy_set_header X-Forwarded-Proto $scheme;
   proxy_pass http://localhost:9000;
 }
}

```

Note: 

* Replace example.com with your own hostname.
* Replace ``http://localhost:9000``  with your own server name.

## 4. Recipe Steps

### Step 1: Start Minio server. 

```sh

$ minio server /mydatadir

```

### Step 2: Restart Nginx server.

```sh

$ sudo service nginx restart

```
