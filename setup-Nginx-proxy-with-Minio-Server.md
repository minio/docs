# Setup Nginx proxy server with Minio

Nginx is an open source Web server and a reverse proxy server.  

In this recipe you will learn how to set up Nginx proxy with Minio Server.

## Install ``Nginx``
You can follow the [official Niginx page](http://nginx.org/en/download.html) for downloading and installing Nginx server.

All you have to do is to add  below content as a file ``/etc/nginx/sites-enabled``  and also remove the existing ``default`` file in same directory.
```
server {
 listen 80;
 server_name example.com;
 location / {
   proxy_set_header Host $host;
   proxy_set_header X-Real-IP $remote_addr;
   proxy_set_header X-Forwarded-Proto $scheme;
   proxy_pass http://localhost:9000;
 }
}
```
Note:
* example.com is example hostname, replace it with yours.
* My Minio server is running ``http://localhost:9000`` so you can change this according to yours.

## Start Minio server

```
$ minio server /mydatadir
```

## Restart Nginx server
```
$ sudo service nginx restart
```
