# Set Up an nginx Proxy with Minio Server [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

nginx is an open source web and reverse proxy server.  

This guide describes how to set up an nginx proxy with Minio Server.

1. [Install Minio Server](#installserver) 
2. [Install nginx](#installnginx) 
3. [Configure the Endpoint](#configureendpoint) 
4. [Run nginx](#runnginx)


## <a name="installserver"></a>1. Install Minio Server

Install Minio Server using the instructions in the [Minio Quickstart Guide](http://docs.minio.io/docs/minio-quickstart-guide).

## <a name="installnginx"></a>2. Install nginx

Install nginx using these instructions: [http://nginx.org/en/download.html](http://nginx.org/en/download.html).  

## <a name="configureendpoint"></a>3. Configure the Endpoint

### 3.1 Configure nginx to Proxy all Requests

#### 3.1.1 Navigate to **/etc/nginx/sites-enabled**.
#### 3.1.2 Remove the existing configuration file named **Default** from that directory.
#### 3.1.3 Create a new configuration file in that directory using a descriptive name (e.g. **minio**) and add the following content:

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
   proxy_set_header Host $http_host;
   proxy_pass http://localhost:9000;
   health_check uri=/minio/health/ready;
 }
}
```

#### 3.1.4 Modify the host settings in the configuration file:
* `example.com`: Specifies the host name. Replace this with the name of the development host.
* `http://localhost:9000`: Specifies the server name. Replace this with the name of the development server.

#### 3.1.5 (Optional) Review additional settings in the configuration file:
* `client_max_body_size`: Specifies the maximum size of the client request body. Set this value to `1000m` in the `http` context to enable large file uploads. This overrides the default value of `1m` which is too low for most scenarios. Set this value to `0` to disable checking the size of the client request body.
* `proxy_buffering`: Enables or disables buffering responses to a temporary file. Set this value to `off` to disable buffering and improve time-to-first-byte for client requests. This setting is enabled by default.
* `ignore_invalid_headers`: Allows or disallows special characters. Set this value to `off` to allow headers with special characters. nginx disallows special characters by default.

### 3.2 Proxy Requests Based on the Bucket
To serve both a web application and Minio Server from the same nginx port, add the following content to the configuration file to proxy the Minio requests based on the bucket name:

```sh
 # Proxy requests to the "photos" bucket on the Minio server running on port 9000
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

## <a name="runnginx"></a>4. Run nginx

### Start Minio Server

```sh
minio server /data
```

### Restart the nginx Server

```sh
systemctl restart nginx.service
```

## <a name="explorerfurther"></a>Explore Further

See [Enterprise-Grade Cloud Storage with NGINX Plus and Minio](https://www.nginx.com/blog/enterprise-grade-cloud-storage-nginx-plus-minio/) for additional information about Minio and nginx configuration options.
