# 如何使用fog aws for Ruby操作MinIO Server [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

`fog-aws`是一个'fog' gem的模块，支持亚马逊Web Services <http://aws.amazon.com/>。本文我们将学习如何使用`fog-aws` for Ruby操作MinIO Server。

## 1. 前提条件

从[这里](https://docs.min.io/docs/minio-quickstart-guide)下载并安装MinIO Server。

## 2. 安装

从[这里](https://github.com/fog/fog-aws)下载并安装`fog-aws` for Ruby。

## 3. 示例

修改``example.rb``文件中的``host``,``endpoint``, ``access_key_id``，``secret_access_key``，``Bucket``以及``Object``配置成你的本地配置。

下面的示例讲的是如何使用`fog-aws Ruby`对MinIO Server执行put_object()和get_object()。

```ruby
require 'fog/aws'

connection = Fog::Storage.new({
    provider:              'AWS',                        # 必须
    aws_access_key_id:     'YOUR-ACCESSKEYID',
    aws_secret_access_key: 'YOUR-SECRETACCESSKEY',
    region:                'us-east-1',                  # 可选，默认为 'us-east-1'
    host:                  'localhost',              # 配置你的host,不然fog-asw默认为s3.amazonaws.com
    endpoint:              'http://localhost:9000', # 必须，不然默认为nil
    path_style:         	true,                        # 必须
})


# put_object操作

connection.put_object(
        'testbucket',
        'testobject',
        'Hello from MinIO!!',
        content_type: 'text/plain'
)

# get_object操作

download_testobject = connection.get_object(
         'testbucket',
         'testobject'
).body

print "Downloaded 'testobject' as  #{download_testobject}."
```

## 4. 运行程序

```sh
ruby example.rb
Downloaded 'testobject' as  Hello from MinIO!!.
```
