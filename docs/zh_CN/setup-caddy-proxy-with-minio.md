# 为MinIO Server设置Caddy proxy  [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

Caddy是一个类似于Apache，nginx或者lighttpd的web服务器。Caddy的目的是简化Web开发，部署和托管工作流程，以便任何人都可以托管自己的网站而不需要特殊的技术知识。

在本文中，我们将学习如何给MinIO Server设置Caddy代理。

## 1. 前提条件

从[这里](https://docs.min.io/docs/minio-quickstart-guide)下载并安装MinIO Server。

## 2. 安装

从[这里](https://caddyserver.com/download)下载并安装Caddy Server。

## 3. 配置

如下创建Caddy配置文件，根据你的本地minio和DNS配置更改IP地址。

```sh
your.public.com

proxy / localhost:9000 {
    header_upstream X-Forwarded-Proto {scheme}
    header_upstream X-Forwarded-Host {host}
    header_upstream Host {host}
}
```

## 4. 步骤

### 第一步: 启动`minio`服务。


```sh
./minio --address localhost:9000 server <your_export_dir>
```

### 第二步: 启动`caddy`服务。

```sh
./caddy
Activating privacy features... done.
your.public.com:443
your.public.com:80
```
