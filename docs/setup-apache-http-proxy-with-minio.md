# Setup Apache HTTP proxy with Minio Server [![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/minio/minio?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Apache HTTP is an open source web server and a reverse proxy server.  

In this recipe we will learn how to set up Apache HTTP with mod_proxy module for connecting to Minio Server. We are goint to set up a new VirtualHost for example.com

## 1. Prerequisites

Install Minio Server from [here](http://docs.minio.io/docs/minio). Remember the address and port.

## 2. Installation

Install Apache HTTP server from [here](https://httpd.apache.org/#downloading). Usually, mod_proxy module is enabled by default.
You can also use your OS repositories (e.g. yum, apt-get).

## 3. Recipe steps

### Step 1: Configure the reverse proxy.

Create a file under the Apache configuration directory, e.g., ``/etc/httpd/conf.d/minio-vhost.conf``

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

    RemoteIPHeader X-Forwarded-For
</VirtualHost>
```

Note: 

* Replace example.com with your own hostname.
* Replace ``http://localhost:9000``  with your own server name.

Step 1: Configure the proxy.

### Step 2: Start Minio server. 

```sh
$ minio server /mydatadir
```

### Step 3: Restart Apache HTTP server.

```sh
$ sudo service httpd restart
```
