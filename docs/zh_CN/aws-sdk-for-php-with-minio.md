# 如何使用AWS SDK for PHP操作MinIO Server [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

`aws-sdk-php`是PHP语言版本的官方AWS SDK。本文我们将学习如何使用`aws-sdk-php`来操作MinIO Server。

## 1. 前提条件

从[这里](https://docs.min.io/docs/minio-quickstart-guide)下载并安装MinIO Server。

## 2. 安装

从[AWS SDK for PHP官方文档](https://docs.aws.amazon.com/aws-sdk-php/v3/guide/getting-started/installation.html)下载将安装`aws-sdk-php`。

## 3. 使用GetObject和PutObject

下面示例描述的是如何使用aws-sdk-php对MinIO Server进行putObject和getObject操作。请将``example.php``文件中的``endpoint``,``key``, ``secret``, ``Bucket``修改为你的本地配置。注意，我们将`use_path_style_endpoint`设置为`true`以使用AWS SDK for PHP来操作MinIO。了解更多，请参考[AWS SDK for PHP](http://docs.aws.amazon.com/aws-sdk-php/v3/api/class-Aws.S3.S3Client.html#___construct)。


```php
<?php

// 使用Composer autoloader引入SDK
date_default_timezone_set('America/Los_Angeles');
require 'vendor/autoload.php';

$s3 = new Aws\S3\S3Client([
        'version' => 'latest',
        'region'  => 'us-east-1',
        'endpoint' => 'http://localhost:9000',
        'use_path_style_endpoint' => true,
        'credentials' => [
                'key'    => 'YOUR-ACCESSKEYID',
                'secret' => 'YOUR-SECRETACCESSKEY',
            ],
]);


// 发送PutObject请求并获得result对象
$insert = $s3->putObject([
     'Bucket' => 'testbucket',
     'Key'    => 'testkey',
     'Body'   => 'Hello from MinIO!!'
]);

// 下载文件的内容
$retrive = $s3->getObject([
     'Bucket' => 'testbucket',
     'Key'    => 'testkey',
     'SaveAs' => 'testkey_local'
]);

// 通过索引到结果对象来打印结果的body。
echo $retrive['Body'];
```

修改之后，运行程序

```sh
php example.php
Hello from MinIO!!
```

## 4. 生成pre-signed URL

```php
<?php
// 从client中获得一个commad对象
$command = $s3->getCommand('GetObject', [
            'Bucket' => 'testbucket',
            'Key'    => 'testkey'
        ]);

// 获得一个10分钟有效期的pre-signed URL
$presignedRequest = $s3->createPresignedRequest($command, '+10 minutes');

// 获得presigned-url
$presignedUrl =  (string)  $presignedRequest->getUri();
```

## 5. 获取plain URL 

获取一个plain URL,你需要将你的object/bucket权限设为public。注意，你不会获得带有后面这些信息的URL，`X-Amz-Algorithm=[...]&X-Amz-Credential=[...]&X-Amz-Date=[...]&X-Amz-Expires=[...]&X-Amz-SignedHeaders=[...]&X-Amz-Signature=[...]`

```php
<?php
$plainUrl = $s3->getObjectUrl('testbucket', 'testkey');
```

## 6. 设置存储桶策略

```php
<?php
$bucket = 'testbucket';
// 该策略设置存储桶为只读
$policyReadOnly = '{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetBucketLocation",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "*"
        ]
      },
      "Resource": [
        "arn:aws:s3:::%s"
      ],
      "Sid": ""
    },
    {
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "*"
        ]
      },
      "Resource": [
        "arn:aws:s3:::%s/*"
      ],
      "Sid": ""
    }
  ]
}
';
// 如果你想将文件放到指定目录，你只需要修改'arn:aws:s3:::%s/*'为'arn:aws:s3:::%s/folder/*'

// 创建一个存储桶
$result = $s3->createBucket([
    'Bucket' => $bucket,
]);

// 配置策略
$s3->putBucketPolicy([
    'Bucket' => $bucket,
    'Policy' => sprintf($policyReadOnly, $bucket, $bucket),
]);
```
