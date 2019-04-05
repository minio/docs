# 如何使用AWS SDK for Python操作MinIO Server [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

`aws-sdk-python`是Python语言版本的官方AWS SDK。本文我们将学习如何使用`aws-sdk-python`来操作MinIO Server。

## 1. 前提条件

从[这里](https://docs.min.io/docs/minio-quickstart-guide)下载并安装MinIO Server。

## 2. 安装

从[AWS SDK for Python官方文档](https://aws.amazon.com/sdk-for-python/)下载将安装`aws-sdk-python`。

## 3. 示例

修改``example.py``文件中的``endpoint_url``,``aws_access_key_id``, ``aws_secret_access_key``，``Bucket``以及``Object``配置成你的本地配置。

下面的示例讲的是如何使用`aws-sdk-python`从MinIO Server上进行上传和下载。

```python
#!/usr/bin/env/python
import boto3
from botocore.client import Config


s3 = boto3.resource('s3',
                    endpoint_url='http://localhost:9000',
                    aws_access_key_id='YOUR-ACCESSKEYID',
                    aws_secret_access_key='YOUR-SECRETACCESSKEY',
                    config=Config(signature_version='s3v4'),
                    region_name='us-east-1')



# 上传本地文件'/home/john/piano.mp3'到存储桶'songs'，以'piano.mp3'做为object name。
s3.Bucket('songs').upload_file('/home/john/piano.mp3','piano.mp3')

# 从存储桶'songs'里下载文件'piano.mp3'，并保存成本地文件/tmp/classical.mp3
s3.Bucket('songs').download_file('piano.mp3', '/tmp/classical.mp3')

print "Downloaded 'piano.mp3' as  'classical.mp3'. "
```

## 4. 运行程序

```sh
python example.py
Downloaded 'piano.mp3' as  'classical.mp3'.
```
## 5. 了解更多

* [MinIO Python Library for Amazon S3](https://docs.min.io/docs/python-client-quickstart-guide)
