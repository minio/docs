# How to monitor Minio server with Prometheus [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

[Prometheus](https://prometheus.io) is a cloud-native monitoring platform, built originally at SoundCloud. Prometheus offers a multi-dimensional data model with time series data identified by metric name and key/value pairs. The data collection happens via a pull model over HTTP. Targets to pull data are discovered via service discovery or static configuration.

Minio exports Prometheus compatible data as an unauthorized endpoint at `/minio/prometheus/metrics`. Users looking to monitor their Minio instances can point Prometheus configuration to scrape data from this endpoint.

This document explains how to setup Prometheus and configure it to scrape data from Minio servers.

## Prerequisites

Minio server release `RELEASE.2018-05-11T00-29-24Z` or later running. To get started with Minio, refer [Minio QuickStart Document](https://docs.minio.io/docs/minio-quickstart-guide). Follow below steps to get started with Minio monitoring using Prometheus.

### 1. Download Prometheus

[Download the latest release](https://prometheus.io/download) of Prometheus for your platform, then extract it

```sh
tar xvfz prometheus-*.tar.gz
cd prometheus-*
```

Prometheus server is a single binary called `prometheus` (or `prometheus.exe` on Microsoft Windows). Run the binary and pass `--help` flag to see available options

```sh
./prometheus --help
usage: prometheus [<flags>]

The Prometheus monitoring server

. . .

```

Refer [Prometheus documentation](https://prometheus.io/docs/introduction/first_steps/) for more details.

### 2. Prometheus configuration

Prometheus configuration is written in YAML. Add Minio server details to the config file under `scrape_configs` section

```yaml
scrape_configs:
  - job_name: minio
    metrics_path: /minio/prometheus/metrics
    static_configs:
      - targets: ['localhost:9000']
```

Note that `localhost:9000` is Minio server instance address, you need to change it to appropriate value in your configuration file.

### 3. Start Prometheus

Start Prometheus by running

```sh
./prometheus --config.file=prometheus.yml
```

Here `prometheus.yml` is the name of configuration file. You can now see Minio metrics in Prometheus dashboard. By default Prometheus dashboard is accessible at `http://localhost:9090`.

## List of Minio metric exposed

Minio server exposes the following metrics on `/minio/prometheus/metrics` endpoint. All of these can be accessed via Prometheus dashboard.

- standard go runtime metrics prefixed by `go_` 
-  level metrics prefixed with `process_`
- prometheus scrap metrics prefixed with `promhttp_`

- `minio_disk_storage_used_bytes` : Total byte count of disk storage used by current Minio server instance
- `minio_http_requests_duration_seconds_bucket` : Cumulative counters for all the request types (HEAD/GET/PUT/POST/DELETE) in different time brackets
- `minio_http_requests_duration_seconds_count` : Count of current number of observations i.e. total HTTP requests (HEAD/GET/PUT/POST/DELETE)
- `minio_http_requests_duration_seconds_sum` : Current aggregate time spent servicing all HTTP requests (HEAD/GET/PUT/POST/DELETE) in seconds
- `minio_network_received_bytes_total` : Total number of bytes received by current Minio server instance
- `minio_network_sent_bytes_total` : Total number of bytes sent by current Minio server instance
- `minio_offline_disks` : Total number of offline disks for current Minio server instance
- `minio_total_disks` : Total number of disks for current Minio server instance
- `process_start_time_seconds` : Start time of Minio server since unix epoch in seconds

If you're running Minio gateway, disk/storage information is not exposed. Only following metrics are available

- `minio_http_requests_duration_seconds_bucket` : Cumulative counters for all the request types (HEAD/GET/PUT/POST/DELETE) in different time brackets
- `minio_http_requests_duration_seconds_count` : Count of current number of observations i.e. total HTTP requests (HEAD/GET/PUT/POST/DELETE)
- `minio_http_requests_duration_seconds_sum` : Current aggregate time spent servicing all HTTP requests (HEAD/GET/PUT/POST/DELETE) in seconds
- `minio_network_received_bytes_total` : Total number of bytes received by current Minio server instance
- `minio_network_sent_bytes_total` : Total number of bytes sent by current Minio server instance
- `process_start_time_seconds` : Start time of Minio server since unix epoch in seconds

For Minio instances with [`caching`](https://github.com/minio/minio/tree/master/docs/disk-caching) enabled, these additional metrics are available.

- `minio_disk_cache_storage_bytes` : Total byte count of cache capacity available for current Minio server instance
- `minio_disk_cache_storage_free_bytes` : Total byte count of free cache available for current Minio server instance
