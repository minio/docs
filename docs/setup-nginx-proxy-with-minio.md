# Setup Nginx proxy with MinIO Server [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

Nginx is an open source Web server and a reverse proxy server.

In this recipe we will learn how to set up Nginx proxy with MinIO Server.

## 1. Prerequisites

Install MinIO Server from [here](https://docs.min.io/docs/minio-quickstart-guide).

## 2. Installation

Install Nginx from [here](http://nginx.org/en/download.html).

## 3. Configuration

### Proxy all requests
Add the following content as a file ``/etc/nginx/sites-enabled``, e.g. ``/etc/nginx/sites-enables/minio``  and also remove the existing ``default`` file in same directory.

```sh
server {
 listen 80;
 server_name example.com;
 # To allow special characters in headers
 ignore_invalid_headers off;
 # Allow any size file to be uploaded.
 # Set to a value such as 1000m; to restrict file size to a specific value
 client_max_body_size 0;
 # To disable buffering
 proxy_buffering off;

 location / {
   proxy_http_version 1.1;
   proxy_set_header Host $http_host;
   # proxy_ssl_session_reuse on; # enable this if you are internally connecting over SSL
   proxy_read_timeout 15m; # Default value is 60s which is not sufficient for MinIO.
   proxy_send_timeout 15m; # Default value is 60s which is not sufficient for MinIO.
   proxy_request_buffering off; # Disable any internal request bufferring.
   proxy_pass http://localhost:9000; # If you are using docker-compose this would be the hostname i.e. minio
   # Health Check endpoint might go here. See https://www.nginx.com/resources/wiki/modules/healthcheck/
   # /minio/health/ready;
 }
}
```

Note:

* Replace example.com with your own hostname.
* Replace ``http://localhost:9000``  with your own server name.
* Add ``client_max_body_size 1000m;`` in the ``http`` context in order to be able to upload large files — simply adjust the value accordingly. The default value is `1m` which is far too low for most scenarios. To disable checking of client request body size, set ``client_max_body_size`` to `0`.
* Nginx buffers responses by default. To disable Nginx from buffering MinIO response to temp file, set `proxy_buffering off;`. This will improve time-to-first-byte for client requests.
* Nginx disallows special characters by default.  Set ``ignore_invalid_headers off;`` to allow headers with special characters.

### Proxy requests based on the bucket
If you want to serve web-application and MinIO from the same nginx port then you can proxy the MinIO requests based on the bucket name using path based routing. For nginx this uses the `location` directive, which also supports object key pattern-match based proxy splitting.

```sh
 # Proxy requests to the bucket "photos" to MinIO server running on port 9000
 location /photos/ {
   proxy_http_version 1.1
   proxy_buffering off;
   # proxy_ssl_session_reuse on; # enable this if you are internally connecting over SSL
   proxy_read_timeout 15m; # Default value is 60s which is not sufficient for MinIO.
   proxy_send_timeout 15m; # Default value is 60s which is not sufficient for MinIO.
   proxy_request_buffering off; # Disable any internal request bufferring.
   proxy_set_header Host $http_host;
   proxy_pass http://localhost:9000;
 }
 # Proxy any other request to the application server running on port 9001
 location / {
   proxy_http_version 1.1
   proxy_buffering off;
   # proxy_ssl_session_reuse on; # enable this if you are internally connecting over SSL
   proxy_read_timeout 15m; # Default value is 60s which is too less for MinIO.
   proxy_send_timeout 15m; # Default value is 60s which is too less for MinIO.
   proxy_request_buffering off; # Disable any internal request bufferring.
   proxy_set_header Host $http_host;
   proxy_pass http://localhost:9001;
 }
```

## 4. Recipe Steps

### Step 1: Start MinIO server.

```sh
minio server /mydatadir
```

### Step 2: Restart Nginx server.

```sh
sudo service nginx restart
```

## Explore Further

Refer [this blog post](https://www.nginx.com/blog/enterprise-grade-cloud-storage-nginx-plus-minio/) for various MinIO and Nginx configuration options.
