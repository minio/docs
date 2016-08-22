# How to use AWS SDK for Ruby with Minio Server [![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/minio/minio?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

`aws-sdk` is the official AWS SDK for the Ruby programming language. In this recipe we will learn how to use `aws-sdk` for Ruby with Minio server.

## 1. Prerequisites

Install Minio Server from [here](http://docs.minio.io/docs/minio).
 
## 2. Installation

Install `aws-sdk` for Ruby from the official AWS Ruby SDK docs [here](https://aws.amazon.com/sdk-for-ruby/) 

## 3. Example

Please replace ``endpoint``,``access_key_id``, ``secret_access_key``, ``Bucket`` and ``Object`` with your local setup in this ``example.rb`` file.

Example below shows put_object() and get_object() operations on Minio server using `aws-sdk Ruby`.

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

# put_object operation

rubys3_client.put_object(
        key: 'testobject',
        body: 'Hello from Minio!!',
        bucket: 'testbucket',
        content_type: 'text/plain'
)

# get_object operation

rubys3_client.get_object(
         bucket: 'testbucket',
         key: 'testobject',
         response_target: 'download_testobject'
)

print "Downloaded 'testobject' as  'download_testobject'. "

```

## 4. Run the Program

```sh
$ ruby example.rb
Downloaded 'testobject' as  'download_testobject'.
```
## 5. Explore Further

* [RoR Resume Uploader App](https://docs.minio.io/docs/ror-resume-uploader-app)
