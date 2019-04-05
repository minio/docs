# 使用AWS CLI结合MinIO Server [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

AWS CLI是管理AWS服务的统一工具。它通常是用于将数据传入和传出AWS S3的工具。它适用于任何S3兼容的云存储服务。

本文我们将学习如何设置和使用AWS CLI来管理MinIO Server上的数据。

## 1. 前提条件

从[这里](https://docs.min.io)下载并安装MinIO Server。

## 2. 安装

从<https://aws.amazon.com/cli/>下载安装AWS CLI。

## 3. 配置

要配置AWS CLI,输入`aws configure`并指定MinIO秘钥信息。

本示例中的访问凭据属于<https://play.min.io:9000>。这些凭据是公开的，你可以随心所欲的使用这个服务来进行测试和开发。在部署时请替换成你自己的MinIO秘钥，切记切记切记，重要的事情说三遍。

```sh
aws configure
AWS Access Key ID [None]: Q3AM3UQ867SPQQA43P2F
AWS Secret Access Key [None]: zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG
Default region name [None]: us-east-1
Default output format [None]: ENTER
```

另外为MinIO Server启用AWS Signature Version'4'。

```sh
aws configure set default.s3.signature_version s3v4
```

## 4. 命令

### 列举你的存储桶

```sh
aws --endpoint-url https://play.min.io:9000 s3 ls
2016-03-27 02:06:30 deebucket
2016-03-28 21:53:49 guestbucket
2016-03-29 13:34:34 mbtest
2016-03-26 22:01:36 mybucket
2016-03-26 15:37:02 testbucket
```

### 列举存储桶里的内容

```sh
aws --endpoint-url https://play.min.io:9000 s3 ls s3://mybucket
2016-03-30 00:26:53      69297 argparse-1.2.1.tar.gz
2016-03-30 00:35:37      67250 simplejson-3.3.0.tar.gz
```

### 创建一个存储桶

```sh
aws --endpoint-url https://play.min.io:9000 s3 mb s3://mybucket
make_bucket: s3://mybucket/
```

### 往存储桶里添加一个对象

```sh
aws --endpoint-url https://play.min.io:9000 s3 cp simplejson-3.3.0.tar.gz s3://mybucket
upload: ./simplejson-3.3.0.tar.gz to s3://mybucket/simplejson-3.3.0.tar.gz
```

### 从存储桶里删除一个对象

```sh
aws --endpoint-url https://play.min.io:9000 s3 rm s3://mybucket/argparse-1.2.1.tar.gz
delete: s3://mybucket/argparse-1.2.1.tar.gz
```

### 删除一个存储桶

```sh
aws --endpoint-url https://play.min.io:9000 s3 rb s3://mybucket
remove_bucket: s3://mybucket/
```
