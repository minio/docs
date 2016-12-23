# Aggregate Apache Logs with fluentd plugin for Minio [![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/minio/minio?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

In this recipe, we will learn how to use Minio as log aggregator for fluentd using `fluent-plugin-s3` plugin.

## 1. Prerequisites

* Install Minio Server from [here](http://docs.minio.io/docs/minio).
* Install `mc` from [here](http://docs.minio.io/docs/minio-client-quickstart-guide)

## 2. Installation

* Install and run [Apache](https://httpd.apache.org) server.
* Install [fluentd](http://docs.fluentd.org/articles/install-by-deb) and [fluent-plugin-s3](http://docs.fluentd.org/articles/apache-to-s3#amazon-s3-output).


## 3. Recipe Steps

### Step 1: Create a bucket.

This is the bucket where fluentd will aggregate semi-structured apache logs in real-time.

```sh

mc mb myminio/fluentd
Bucket created successfully ‘myminio/fluentd’.

```

### Step 2: Modify the fluentd configuration to use Minio as backend.
Replace with your own values for `aws_key_id`, `aws_sec_key`, `s3_bucket`,  `s3_endpoint`.

Replace `/etc/td-agent/td-agent.conf` with:

```sh

<source>
  @type tail
  format apache2
  path /var/log/apache2/access.log
  pos_file /var/log/td-agent/apache2.access.log.pos
  tag s3.apache.access
</source>

<match>
  @type s3
   aws_key_id  `aws_key_id`
   aws_sec_key `aws_sec_key`
   s3_bucket `s3_bucket`
   s3_endpoint  `s3_endpoint`
   path logs/
   force_path_style true
   buffer_path /var/log/td-agent/s3
   time_slice_format %Y%m%d%H%M
   time_slice_wait 10m
   utc
   buffer_chunk_limit 256m
</match>

```

### Step 3: Restart `fluentd` server.  

```sh

sudo /etc/init.d/td-agent restart


```

### Step 4: Check the fluentd logfile to confirm if everything is running.


```sh

tail -f /var/log/td-agent/td-agent.log
    path logs/
    force_path_style true
    buffer_path /var/log/td-agent/s3
    time_slice_format %Y%m%d%H%M
    time_slice_wait 10m
    utc
    buffer_chunk_limit 256m
  </match>
</ROOT>
2016-05-03 18:44:44 +0530 [info]: following tail of /var/log/apache2/access.log

```

### Step 5: Test the configuration.

Ping the Apache server. This example uses the ab (Apache Bench) program.


```sh

ab -n 100 -c 10 http://localhost/

```

### Step 6: Verify Aggregated Logs.

Minio server's fluent bucket should show the aggregated logs.

```sh

mc ls myminio/fluentd/logs/
[2016-05-03 18:47:13 IST]   570B 201605031306_0.gz
[2016-05-03 18:58:14 IST]   501B 201605031317_0.gz

```

**Note**:

 fleuntd should have access permission for your apache log file located at `/var/log/apache2/access.log`.
