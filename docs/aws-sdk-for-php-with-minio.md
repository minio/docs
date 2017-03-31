# How to use AWS SDK for PHP with Minio Server [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

`aws-sdk-php` is the official AWS SDK for the PHP programming language. In this recipe we will learn how to use `aws-sdk-php` with Minio server.

## 1. Prerequisites

Install Minio Server from [here](http://docs.minio.io/docs/minio).

## 2. Installation

Install `aws-sdk-php` from AWS SDK for PHP official docs [here](https://docs.aws.amazon.com/aws-sdk-php/v3/guide/getting-started/installation.html)

## 3. Example

Please replace ``endpoint``,``key``, ``secret``, ``Bucket`` with your local setup in this ``example.php`` file.

Example below shows putObject and getObject operations on Minio server using aws-sdk-php.

```php
<?php

// Include the SDK using the Composer autoloader
date_default_timezone_set('America/Los_Angeles');
require 'vendor/autoload.php';

$s3 = new Aws\S3\S3Client([
        'version' => 'latest',
        'region'  => 'us-east-1',
        'endpoint' => 'http://localhost:9000',
        'credentials' => [
                'key'    => 'YOUR-ACCESSKEYID',
                'secret' => 'YOUR-SECRETACCESSKEY',
            ],
]);


// Send a PutObject request and get the result object.
$insert = $s3->putObject([
     'Bucket' => 'testbucket',
     'Key'    => 'testkey',
     'Body'   => 'Hello from Minio!!'
]);

// Download the contents of the object.
$retrive = $s3->getObject([
     'Bucket' => 'testbucket',
     'Key'    => 'testkey',
     'SaveAs' => 'testkey_local'
]);

// Print the body of the result by indexing into the result object.
echo $retrive['Body'];
```

## 4. Run the Program

```sh
php example.php
Hello from Minio!!
```

## 5.  Create a pre-signed URL

```php
<?php
// Get a command object from the client
$command = $s3->getCommand('GetObject', [
            'Bucket' => 'testbucket',
            'Key'    => 'testkey'
        ]);

// Create a pre-signed URL for a request with duration of 10 miniutes
$presignedRequest = $s3->createPresignedRequest($command, '+10 minutes');

// Get the actual presigned-url
$presignedUrl =  (string)  $presignedRequest->getUri();
```
