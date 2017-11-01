# Setup Nginx proxy with Minio Server [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

Nginx is an open source Web server and a reverse proxy server.  

In this recipe we will learn how to set up Nginx proxy with Minio Server.

## 1. Prerequisites

Install Minio Server from [here](http://docs.minio.io/docs/minio-quickstart-guide).

## 2. Installation

Install Nginx from [here](http://nginx.org/en/download.html).  

## 3. Configuration

### Standard Root Configuration
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

### Non Root Configuration
When a non root configuration is needed adjust the location definition as follows:

```sh
 location ~^/files {
   proxy_buffering off;
   proxy_set_header Host $http_host;
   proxy_pass http://localhost:9000;
 }
```

Note:

* Replace `http://localhost:9000` with your own server name.
* Replace `files` with the desired path. This cannot be `~^/minio` since `minio` is a reserved word in minio. 
* The path used (in this case `files`) will, by convension, be the name of the bucket used by minio.
* Other buckets can be accessed by adding more location definitions similar to the one defined above.

### Non Root Configuration With Rewrite
The following location configuration allows for access to any bucket however only through unsigned urls and therefore publically accessible buckets.

```sh
 location ~^/files {
   proxy_buffering off;
   proxy_set_header Host $http_host;
   rewrite ^/files/(.*)$ /$1 break;
   proxy_pass http://localhost:9000;
 }
```

Note:

* Replace `http://localhost:9000` with your own server name.
* Replace `files` with the desired path.
* The buckets used must be publicly available, typically for both reading and writing.
* The url used must be unsigned since nginx will change the url and invalidate the signature in the process.

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
