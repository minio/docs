# Setup Nginx proxy with Minio Server [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

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
   proxy_pass http://localhost:9000;
 }
}

```

Note: 

* Replace example.com with your own hostname.
* Replace ``http://localhost:9000``  with your own server name.
* Add ``client_max_body_size 1000m;`` in the ``http`` context in order to be able to upload large files — simply adjust the value accordingly. The default value is `1m` which is far too low for most scenarios.

## 4. Recipe Steps

### Step 1: Start Minio server. 

```sh

minio server /mydatadir

```

### Step 2: Restart Nginx server.

```sh

sudo service nginx restart

```

## Explore Further 

Refer [this blog post](https://www.nginx.com/blog/enterprise-grade-cloud-storage-nginx-plus-minio/) for various Minio and Nginx configuration options. 
