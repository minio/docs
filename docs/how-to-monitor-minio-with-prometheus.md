# How to monitor MinIO server with Prometheus [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

[Prometheus](https://prometheus.io) is a cloud-native monitoring platform, built originally at SoundCloud. Prometheus offers a multi-dimensional data model with time series data identified by metric name and key/value pairs. The data collection happens via a pull model over HTTP/HTTPS. Targets to pull data from are discovered via service discovery or static configuration.

MinIO exports Prometheus compatible data as an authorized endpoint at `/minio/prometheus/metrics`. Users looking to monitor their MinIO instances can point Prometheus configuration to scrape data from this endpoint.

This document explains how to setup Prometheus and configure it to scrape data from MinIO servers.

## Prerequisites

MinIO server release `RELEASE.2018-05-11T00-29-24Z` or later running. To get started with MinIO, refer [MinIO QuickStart Document](https://docs.min.io/docs/minio-quickstart-guide). Follow below steps to get started with MinIO monitoring using Prometheus.

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

### 2. Generate the Prometheus Config with mc

The Prometheus endpoint in MinIO requires authorization. For secured access using a bearer token approach, override the default Prometheus config with the one generated using mc.
To generate a Prometheus config for an alias, use [mc](https://docs.min.io/docs/minio-client-quickstart-guide) as follows `mc admin prometheus generate <alias>`.

The command will generate the `scrape_configs` section of the prometheus.yml as follows:

```yaml
scrape_configs:
- job_name: minio-job
  bearer_token: <secret>
  metrics_path: /minio/prometheus/metrics
  scheme: http
  static_configs:
  - targets: ['localhost:9000']
```


### 3. Update `scrape_configs` section in prometheus.yml

To authorize every scrape request, copy and paste the generated `scrape_configs` section in the prometheus.yml and restart the Prometheus service.

### 4. Start Prometheus

Start (or) Restart Prometheus service by running

```sh
./prometheus --config.file=prometheus.yml
```
Here `prometheus.yml` is the name of configuration file. You can now see MinIO metrics in Prometheus dashboard. By default Prometheus dashboard is accessible at `http://localhost:9090`.

## List of MinIO metric exposed

MinIO server exposes the following metrics on `/minio/prometheus/metrics` endpoint. All of these can be accessed via Prometheus dashboard. The full list of exposed metrics along with their definition is available in the demo server at https://play.min.io:9000/minio/prometheus/metrics

- standard go runtime metrics prefixed by `go_`
- process level metrics prefixed with `process_`
- prometheus scrap metrics prefixed with `promhttp_`

- `minio_disk_storage_used_bytes` : Total byte count of disk storage used by current MinIO server instance
- `minio_http_requests_duration_seconds_bucket` : Cumulative counters for all the request types (HEAD/GET/PUT/POST/DELETE) in different time brackets
- `minio_http_requests_duration_seconds_count` : Count of current number of observations i.e. total HTTP requests (HEAD/GET/PUT/POST/DELETE)
- `minio_http_requests_duration_seconds_sum` : Current aggregate time spent servicing all HTTP requests (HEAD/GET/PUT/POST/DELETE) in seconds
- `minio_network_received_bytes_total` : Total number of bytes received by current MinIO server instance
- `minio_network_sent_bytes_total` : Total number of bytes sent by current MinIO server instance
- `minio_offline_disks` : Total number of offline disks for current MinIO server instance
- `minio_total_disks` : Total number of disks for current MinIO server instance
- `minio_disk_storage_available_bytes` : Current storage space available to MinIO server in bytes
- `minio_disk_storage_total_bytes` : Total storage space available to MinIO server in bytes
- `process_start_time_seconds` : Start time of MinIO server since unix epoch in seconds

If you're running MinIO gateway, disk/storage information is not exposed. Only following metrics are available

- `minio_http_requests_duration_seconds_bucket` : Cumulative counters for all the request types (HEAD/GET/PUT/POST/DELETE) in different time brackets
- `minio_http_requests_duration_seconds_count` : Count of current number of observations i.e. total HTTP requests (HEAD/GET/PUT/POST/DELETE)
- `minio_http_requests_duration_seconds_sum` : Current aggregate time spent servicing all HTTP requests (HEAD/GET/PUT/POST/DELETE) in seconds
- `minio_network_received_bytes_total` : Total number of bytes received by current MinIO server instance
- `minio_network_sent_bytes_total` : Total number of bytes sent by current MinIO server instance
- `process_start_time_seconds` : Start time of MinIO server since unix epoch in seconds

For MinIO instances with [`caching`](https://github.com/minio/minio/tree/master/docs/disk-caching) enabled, these additional metrics are available.

- `minio_disk_cache_storage_bytes` : Total byte count of cache capacity available for current MinIO server instance
- `minio_disk_cache_storage_free_bytes` : Total byte count of free cache available for current MinIO server instance
