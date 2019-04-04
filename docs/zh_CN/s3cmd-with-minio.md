# 使用S3cmd操作MinIO Server [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

`S3cmd`是用于管理AWS S3，Google云存储或任何使用s3协议的云存储服务提供商的数据的CLI客户端。`S3cmd`是开源的，在GPLv2许可下分发。

在本文中，我们将学习如何配置和使用S3cmd来管理MinIO Server的数据。

## 1. 前提条件

从[这里](https://docs.min.io/docs/minio-quickstart-guide)下载并安装MinIO Server。

## 2. 安装

从<http://s3tools.org/s3cmd>下载并安装`S3cmd`。

## 3. 配置

我们将在<https://play.min.io:9000>上运行`S3cmd`。

本示例中的访问凭输入<https://play.min.io:9000>。这些凭据是公开的，你可以随心所欲的使用这个服务来进行测试和开发。在部署时请替换成你自己的MinIO秘钥。

编辑你的s3cmd配置文件`~/.s3cfg`中的以下字段

```sh
# 设置endpoint
host_base = play.min.io:9000
host_bucket = play.min.io:9000
bucket_location = us-east-1
use_https = True

# 设置access key和secret key
access_key =  Q3AM3UQ867SPQQA43P2F
secret_key = zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG

# 启用S3 v4版本签名API
signature_v2 = False
```

## 4. 命令

### 创建存储桶

```sh
s3cmd mb s3://mybucket
Bucket 's3://mybucket/' created
```

### 拷贝一个文件到存储桶

```sh
s3cmd put newfile s3://testbucket
upload: 'newfile' -> 's3://testbucket/newfile'  
```

### 拷贝一个文件到本地文件系统

```sh
s3cmd get s3://testbucket/newfile
download: 's3://testbucket/newfile' -> './newfile'
```

### 同步本地文件/文件夹到存储桶

```sh
s3cmd sync newdemo s3://testbucket
upload: 'newdemo/newdemofile.txt' -> 's3://testbucket/newdemo/newdemofile.txt'
```

### 将存储桶或者文件对象同步到本地文件系统

```sh
s3cmd sync  s3://testbucket otherlocalbucket
download: 's3://testbucket/cat.jpg' -> 'otherlocalbucket/cat.jpg'
```

### 列举存储桶

```sh
s3cmd ls s3://
2015-12-09 16:12  s3://testbbucket
```

### 列举存储桶里的内容

```sh
s3cmd ls s3://testbucket/
                                      DIR   s3://testbucket/test/
2015-12-09 16:05    138504   s3://testbucket/newfile
```

### 从存储桶里删除一个文件

```sh
s3cmd del s3://testbucket/newfile
delete: 's3://testbucket/newfile'
```

### 删除一个存储桶

```sh
s3cmd rb s3://mybucket
Bucket 's3://mybucket/' removed
```

注意:
完整的 `S3cmd`使用指南可以在[这里](http://s3tools.org/usage)找到。
