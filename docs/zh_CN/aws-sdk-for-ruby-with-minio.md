# 如何使用AWS SDK for Ruby操作MinIO Server [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

`aws-sdk` for Ruby是Ruby语言版本的官方AWS SDK。本文我们将学习如何使用`aws-sdk` for Ruby来操作MinIO Server。

## 1. 前提条件

从[这里](https://docs.min.io/docs/minio-quickstart-guide)下载并安装MinIO Server。

## 2. 安装

从[AWS SDK for Ruby官方文档](https://aws.amazon.com/sdk-for-ruby/)下载将安装`aws-sdk` for Ruby。

## 3. 示例

修改``example.rb``文件中的``endpoint``,``access_key_id``, ``secret_access_key``，``Bucket``以及``Object``配置成你的本地配置。

下面示例描述的是如何使用`aws-sdk` for Ruby从MinIO Server上执行put_object()和get_object()。

```ruby
require 'aws-sdk'

Aws.config.update(
        endpoint: 'http://localhost:9000',
        access_key_id: 'YOUR-ACCESSKEYID',
        secret_access_key: 'YOUR-SECRETACCESSKEY',
        force_path_style: true,
        region: 'us-east-1'
)

rubys3_client = Aws::S3::Client.new

# put_object操作

rubys3_client.put_object(
        key: 'testobject',
        body: 'Hello from MinIO!!',
        bucket: 'testbucket',
        content_type: 'text/plain'
)

# get_object操作

rubys3_client.get_object(
         bucket: 'testbucket',
         key: 'testobject',
         response_target: 'download_testobject'
)

print "Downloaded 'testobject' as  'download_testobject'. "
```

## 4. 运行程序

```sh
ruby example.rb
Downloaded 'testobject' as  'download_testobject'.
```
