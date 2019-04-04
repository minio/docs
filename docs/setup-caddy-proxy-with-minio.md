# Setup Caddy proxy with MinIO Server  [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

Caddy is a web server like Apache, nginx, or lighttpd. The purpose of Caddy is to streamline  web development, deployment, and hosting workflows so that anyone can host their own web sites without requiring special technical knowledge.

In this recipe we will learn how to set up Caddy proxy with MinIO Server.

## 1. Prerequisites

Install MinIO Server from [here](http://docs.minio.io/docs/minio-quickstart-guide).

## 2. Installation

Install Caddy Server from [here](https://caddyserver.com/download).

## 3. Configuration

Create a caddy configuration file as below, change the ip addresses according to your local minio and DNS configuration.

```sh
your.public.com

proxy / localhost:9000 {
    header_upstream X-Forwarded-Proto {scheme}
    header_upstream X-Forwarded-Host {host}
    header_upstream Host {host}
    health_check /minio/health/ready
}
```

## 4. Recipe Steps

### Step 1: Start `minio` server.


```sh
./minio --address localhost:9000 server <your_export_dir>
```

### Step 2: Start `caddy` server.

```sh
./caddy
Activating privacy features... done.
your.public.com:443
your.public.com:80
```
