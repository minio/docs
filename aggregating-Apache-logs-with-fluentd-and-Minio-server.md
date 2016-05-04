# Aggregating Apache logs with fluentd and Minio server

 How to use Minio as log aggregator for fluentd using `fluent-plugin-s3` plugin.

## Prerequisites
* You have minio client library installed, if not follow mc [install instructions](https://github.com/minio/mc/blob/master/README.md)
* You have a Minio server configured and running, if not follow Minio [install instructions](https://github.com/minio/minio/blob/master/README.md)
* You have fluentd and fluent-plugin-s3 plugin installed, if not please follow these links [fluentd Install](http://docs.fluentd.org/articles/install-by-deb) and [fluent-plugin-s3](http://docs.fluentd.org/articles/apache-to-s3#amazon-s3-output)
* You have `Apache` server installed and running.

## Steps
### Create a bucket :
This is the bucket where fluentd will aggregate semi-structured apache logs in real-time.

```
$ mc mb myminio/fluentd
Bucket created successfully ‘myminio/fluentd’.
```
### Modifying fluentd configuration to use Minio as backend:

We are replacing `/etc/td-agent/td-agent.conf` with:
```
<source>
  @type tail
  format apache2
  path /var/log/apache2/access.log
  pos_file /var/log/td-agent/apache2.access.log.pos
  tag s3.apache.access
</source>

<match>
  @type s3
   aws_key_id TFCZXGKLXCNLOYN303ME
   aws_sec_key gWmpTU4z68mrp2ZbMmvPG4qwEsSj1kMqglHOvPdM
   s3_bucket fluentd
   s3_endpoint http://127.0.0.1:9000
   path logs/
   force_path_style true
   buffer_path /var/log/td-agent/s3
   time_slice_format %Y%m%d%H%M
   time_slice_wait 10m
   utc
   buffer_chunk_limit 256m
</match>
```
After this please restart your `fluentd` server.  
```
$ sudo /etc/init.d/td-agent restart

```
Check the fluentd logfile to confirm everything is running fine.
```
$ tail -f /var/log/td-agent/td-agent.log
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
To test the configuration, just ping the Apache server. This example uses the ab (Apache Bench) program.

```
$ ab -n 100 -c 10 http://localhost/
```
checking your Minio server's fluent bucket will get you the aggregated logs stored.
```
$ mc ls myminio/fluentd/logs/
[2016-05-03 18:47:13 IST]   570B 201605031306_0.gz
[2016-05-03 18:58:14 IST]   501B 201605031317_0.gz
```

**Note**:
*  Please replace `aws_key_id`,`aws_sec_key`,`s3_bucket`, `s3_endpoint` with your local `Minio Server` setup.
* fleuntd should have access permission for your apache log file located at `/var/log/apache2/access.log`
