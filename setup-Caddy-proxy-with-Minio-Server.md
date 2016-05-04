# Setup Caddy proxy server with Minio

Caddy is a web server like Apache, nginx, or lighttpd. The purpose of Caddy is to streamline an authentic web development, deployment, and hosting workflow so that anyone can host their own web sites without requiring special technical knowledge.

In this recipe you will learn how to set up Caddy proxy with Minio Server.

## Install `caddy`.
Please download [Caddy Server](https://caddyserver.com/download) and create a caddy configuration file as below, change the ip addresses according to your local minio and DNS configuration.
```
your.public.com {
    proxy / localhost:9000 {
        proxy_header Host {host}
        proxy_header X-Real-IP {remote}
        proxy_header X-Forwarded-Proto {scheme}
    }
}
```
## Start `minio` server.
```
$ minio --address localhost:9000 server <your_export_dir>
```
## Star `caddy` server
```
$ ./caddy
Activating privacy features... done.
your.public.com:443
your.public.com:80
```
