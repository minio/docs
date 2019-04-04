# 运行MinIO Prometheus Exporter [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

本文介绍了如何运行MinIO Prometheus exporter。


## 1. 前提条件

* 从[这里](https://docs.min.io/docs/minio-quickstart-guide)下载并安装MinIO Server。
* 从[这里](https://github.com/joe-pll/minio-exporter)下载并安装minio-exporter。

## 2. 运行exporter

有两种方式来运行exporter,通过build二进制文件或者使用docker image。

### 使用二进制文件运行exporter
```bash
make
./minio_exporter [flags]
```

| 参数 | 描述 | 默认值 |
| ---- | ------------| ------- |
| version | 输出版本信息。 | |
| web.listen-address | 要监听的端口。 | *:9290* |
| web.telemetry-path | 监听的url path。 | */metrics* |
| minio.server | MinIO Server的URL，如果MinIO仅支持安全连接的话，请使用HTTPS。 | *http://localhost:9000* |
| minio.access-key | MinIO Server的access key。 | "" |
| minio.access-secret | MinIO Server的secret key。 | "" |
| minio.bucket-stats | 收集存储桶及桶内对象的统计信息。它需要进行额外的计算，在大存储桶中请谨慎使用。 | false |

```bash
./minio_exporter -minio.server minio-host.example:9000 -minio.access-key "login_name" -minio.access-secret "login_password"
```

### 使用docker运行exporter

```bash
docker pull joepll/minio-exporter
docker run -p 9290:9290 joepll/minio-exporter -minio.server "minio.host:9000" -minio.access-key "login_name" -minio.access-secret "login_secret"
```

你也可以使用环境变量的方式
* **LISTEN_ADDRESS**: exporter的地址，对应*web.listen-address*。
* **METRIC_PATH**: telemetry路径， 对应*web.telemetry-path*。
* **MINIO_URL**: MinIO Server的URL, 对应*minio.server*。
* **MINIO_ACCESS_KEY**: access key ，对应*minio.access-key*。
* **MINIO_ACCESS_SECRET**: access secret，对应*minio.access-secret*。


```bash
docker run \
       -p 9290:9290 \
       -e "MINIO_URL=http://host.local:9000" \
       -e "MINIO_ACCESS_KEY=loginname" \
       -e "MINIO_ACCESS_SECRET=password" \
       joepll/minio-exporter
```

### 了解更多

你可以通过[official website](https://prometheus.io)和[github](https://github.com/prometheus)获得更多有关Prometheus的信息。
以下是一些有用的链接。  

* [Getting started with Prometheus server](https://prometheus.io/docs/prometheus/latest/getting_started/)
* [Prometheus exporters](https://prometheus.io/docs/instrumenting/exporters/)
