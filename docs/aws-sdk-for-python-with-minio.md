# How to use AWS SDK for Python with Minio Server [![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/minio/minio?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

`aws-sdk-php` is the official AWS SDK for the PHP programming language. In this recipe we will learn how to use `aws-sdk-php` with Minio server.

## 1. Prerequisites

Install Minio Server from [here](http://docs.minio.io/docs/minio).
 
## 2. Installation

Install `aws-sdk-python` from AWS SDK for Python official docs [here](https://aws.amazon.com/sdk-for-python/) 

## 3. Example

Please replace ``endpoint_url``,``aws_access_key_id``, ``aws_secret_access_key``, ``Bucket`` and ``Object`` with your local setup in this ``example.py`` file.

Example below shows upload and download object operations on Minio server using aws-sdk-python.

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




# upload a file from local file system '/home/john/piano.mp3' to bucket 'songs' with 'piano.mp3' as the object name.
s3.Bucket('songs').upload_file('piano.mp3', '/home/john/piano.mp3')

# download the object 'piano.mp3' from the bucket 'songs' and save it to local FS as /tmp/classical.mp3
s3.Bucket('songs').download_file('piano.mp3', '/tmp/classical.mp3')

print "Downloaded 'piano.mp3' as  'classical.mp3'. "

```

## 4. Run the Program

```sh
$ python example.py
Downloaded 'piano.mp3' as  'classical.mp3'.
```
## 5. Explore Further

* [Minio Python Library for Amazon S3](https://docs.minio.io/docs/python-client-quickstart-guide)
