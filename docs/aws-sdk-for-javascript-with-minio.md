# How to use AWS SDK for Javascript with Minio Server [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

In this recipe we will learn how to use `aws-sdk` for Javascript with Minio server. `aws-sdk` is the official AWS SDK for the Javascript programming language.

## 1. Prerequisites

Install Minio Server from [here](http://docs.minio.io/docs/minio).

## 2. Installation

Install `aws-sdk` for Javascript from the official AWS Javascript SDK docs [here](http://docs.aws.amazon.com/AWSJavaScriptSDK/guide/)

## 3. Example

Replace ``endpoint``,``accessKeyId``, ``secretAccessKey``, ``Bucket`` and ``Object`` with your local setup in this ``example.js`` file.

The example below shows putObject and getObject operations on Minio server using `aws-sdk `.

```javascript
var AWS = require('aws-sdk');

var s3  = new AWS.S3({
          accessKeyId: 'YOUR-ACCESSKEYID' ,
          secretAccessKey: 'YOUR-SECRETACCESSKEY' ,
          endpoint: 'http://127.0.0.1:9000' ,
          s3ForcePathStyle: true, // needed with minio?
          signatureVersion: 'v4'
});

// putObject operation.

var params = {Bucket: 'testbucket', Key: 'testobject', Body: 'Hello from Minio!!'};

s3.putObject(params, function(err, data) {
      if (err)
       console.log(err)
      else   
       console.log("Successfully uploaded data to testbucket/testobject");
});

// getObject operation.

var params = {Bucket: 'testbucket', Key: 'testobject'};

var file = require('fs').createWriteStream('/tmp/mykey');

s3.getObject(params).
on('httpData', function(chunk) { file.write(chunk); }).
on('httpDone', function() { file.end(); }).
send();
```

## 4. Run the Program

```sh
node example.js
Successfully uploaded data to testbucket/testobject
```
## 5. Explore Further

* [Javascript Shopping App](https://docs.minio.io/docs/javascript-shopping-app)
