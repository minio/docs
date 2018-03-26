# Setup Nginx proxy with Minio Server [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

Nginx is an open source Web server and a reverse proxy server.  

In this recipe we will learn how to set up Nginx proxy with Minio Server.

## 1. Prerequisites

Install Minio Server from [here](http://docs.minio.io/docs/minio-quickstart-guide).

## 2. Installation

Install Nginx from [here](http://nginx.org/en/download.html).  

## 3. Configuration

### Proxy all requests
Add  below content as a file ``/etc/nginx/sites-enabled``  and also remove the existing ``default`` file in same directory.

```sh
server {
 listen 80;
 server_name example.com;
 location / {
   proxy_set_header Host $http_host;
   proxy_pass http://localhost:9000;
   health_check uri=/minio/health/ready;
 }
}
```

Note:

* Replace example.com with your own hostname.
* Replace ``http://localhost:9000``  with your own server name.
* Add ``client_max_body_size 1000m;`` in the ``http`` context in order to be able to upload large files — simply adjust the value accordingly. The default value is `1m` which is far too low for most scenarios.
* Nginx buffers responses by default. To disable Nginx from buffering Minio response to temp file, set `proxy_buffering off;`. This will improve time-to-first-byte for client requests.

### Proxy requests based on the bucket
If you want to serve web-application and Minio from the same nginx port then you can proxy the Minio requests based on the bucket name

```sh
 # Proxy requests to the bucket "photos" to Minio server running on port 9000
 location /photos/ {
   proxy_buffering off;
   proxy_set_header Host $http_host;
   proxy_pass http://localhost:9000;
 }
 # Proxy any other request to the application server running on port 9001
 location / {
   proxy_buffering off;
   proxy_set_header Host $http_host;
   proxy_pass http://localhost:9001;
 }
```

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
