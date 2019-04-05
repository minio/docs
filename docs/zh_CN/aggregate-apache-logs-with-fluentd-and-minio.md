# 使用fluentd插件聚合Apache日志[![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

在本文中，我们将学习如何使用`fluent-plugin-s3`插件结合MinIO做为日志聚合器。

## 1. 前提提件

* 从[这里](https://docs.min.io/docs/minio-quickstart-guide)下载MinIO Server。
* 从[这里](https://docs.min.io/docs/minio-client-quickstart-guide)下载`mc`。

## 2. 安装

* 安装并运行[Apache server](https://httpd.apache.org) 。
* 安装[fluentd](http://docs.fluentd.org/articles/install-by-deb) 和 [fluent-plugin-s3](http://docs.fluentd.org/articles/apache-to-s3#amazon-s3-output)。


## 3. 步骤

### 第一步：创建存储桶。


fluentd将会实时聚合半结构化apache日志到这个存储桶。

```sh
mc mb myminio/fluentd
Bucket created successfully ‘myminio/fluentd’.
```

### 第二步：修改fluentd配置以使用MinIO作为存储后端。
将`aws_key_id`, `aws_sec_key`, `s3_bucket`,  `s3_endpoint`替换为你自己的值。

将 `/etc/td-agent/td-agent.conf` 替换为:

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

### 第三步: 重启 `fluentd` server.  

```sh
sudo /etc/init.d/td-agent restart
```

### 第四步: 检查fluentd的日志以确认是否一切正在运行。

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

### 第五步: 验证你的配置。

Ping Apache server。该示例采用ab(Apache Bench)程序。


```sh
ab -n 100 -c 10 http://localhost/
```

### 第六步: 验证聚合的日志。

MinIO Server的fluent存储桶应该显示聚合后的日志。

```sh
mc ls myminio/fluentd/logs/
[2016-05-03 18:47:13 IST]   570B 201605031306_0.gz
[2016-05-03 18:58:14 IST]   501B 201605031317_0.gz
```

**注意事项**:

 fleuntd需要有访问`/var/log/apache2/access.log`的权限。
