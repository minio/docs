# 如何使用AWS SDK for Javascript操作MinIO Server [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

本文我们将学习如何使用`aws-sdk` for Javascript操作MinIO Server。`aws-sdk` for Javascript是Javascript语言版本的官方AWS SDK。

## 1. 前提条件

从[这里](https://docs.min.io/docs/minio-quickstart-guide)下载并安装MinIO Server。

## 2. 安装

从[ AWS Javascript SDK官方文档](https://aws.amazon.com/sdk-for-go/)下载将安装`aws-sdk` for Javascript。

## 3. 示例

修改``example.js``文件中的``endpoint``,``accessKeyId``, ``secretAccessKey``，``Bucket``以及``Object``配置成你的本地配置。

下面的示例讲的是如何使用`aws-sdk` for Javascript从MinIO Server上putObject和getObject。

```javascript
var AWS = require('aws-sdk');

var s3  = new AWS.S3({
          accessKeyId: 'YOUR-ACCESSKEYID' ,
          secretAccessKey: 'YOUR-SECRETACCESSKEY' ,
          endpoint: 'http://127.0.0.1:9000' ,
          s3ForcePathStyle: true,
          signatureVersion: 'v4'
});

// putObject操作

var params = {Bucket: 'testbucket', Key: 'testobject', Body: 'Hello from MinIO!!'};

s3.putObject(params, function(err, data) {
      if (err)
       console.log(err)
      else   
       console.log("Successfully uploaded data to testbucket/testobject");
});

// getObject操作

var params = {Bucket: 'testbucket', Key: 'testobject'};

var file = require('fs').createWriteStream('/tmp/mykey');

s3.getObject(params).
on('httpData', function(chunk) { file.write(chunk); }).
on('httpDone', function() { file.end(); }).
send();
```

## 4. 运行程序

```sh
node example.js
Successfully uploaded data to testbucket/testobject
```
## 5. 了解更多

* [Javascript Shopping App](https://github.com/minio/minio-js-store-app)
