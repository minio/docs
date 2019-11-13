# Running MinIO Prometheus Exporter [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

This recipe explains how to run a MinIO Prometheus exporter.


## 1. Prerequisites

* Install MinIO Server from [here](https://docs.min.io/docs/minio-quickstart-guide).
* Get the minio-exporter from [here](https://github.com/joe-pll/minio-exporter).

## 2. Running the exporter

Once the MinIO server starts there are two ways to run the exporter, via building the binaries or using the docker image.

### Run the exporter using the binaries
```bash
make
./minio_exporter [flags]
```

| Flag | Description | Default |
| ---- | ------------| ------- |
| version | Print version number and leave | |
| web.listen-address | The address to listen on to expose metrics. | *:9290* |
| web.telemetry-path | The listening path for metrics. | */metrics* |
| minio.server | The URL of the minio server. Use HTTPS if MinIO accepts secure connections only. | *http://localhost:9000* |
| minio.access-key | The value of the MinIO access key. It is required in order to connect to the server | "" |
| minio.access-secret | The calue of the MinIO access secret. It is required in order to connect to the server | "" |
| minio.bucket-stats | Collect statistics about the buckets and files in buckets. It requires more computation, use it carefully in case of large buckets. | false |

```bash
./minio_exporter -minio.server minio-host.example:9000 -minio.access-key "login_name" -minio.access-secret "login_password"
```

### Running the exporter using docker

```bash
docker pull joepll/minio-exporter
docker run -p 9290:9290 joepll/minio-exporter -minio.server "minio.host:9000" -minio.access-key "login_name" -minio.access-secret "login_secret"
```

The same result can be achieved with Environment variables.
* **LISTEN_ADDRESS**: is the exporter address, as the option *web.listen-address*
* **METRIC_PATH**: the telemetry path. It corresponds to *web.telemetry-path*
* **MINIO_URL**: the URL of the MinIO server, as *minio.server*
* **MINIO_ACCESS_KEY**: the MinIO access key (*minio.access-key*)
* **MINIO_ACCESS_SECRET**: the MinIO access secret (*minio.access-secret*)


```bash
docker run \
       -p 9290:9290 \
       -e "MINIO_URL=http://host.local:9000" \
       -e "MINIO_ACCESS_KEY=loginname" \
       -e "MINIO_ACCESS_SECRET=password" \
       joepll/minio-exporter
```

### Prometheus resources

You can find more information about Prometheus on the [official website](https://prometheus.io) and on [github](https://github.com/prometheus).  
Here below some useful links.

* [Getting started with Prometheus server](https://prometheus.io/docs/prometheus/latest/getting_started/)
* [Prometheus exporters](https://prometheus.io/docs/instrumenting/exporters/)
