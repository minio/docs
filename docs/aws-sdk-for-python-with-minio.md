# How to use AWS SDK for Python with MinIO Server [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

`aws-sdk-python` is the official AWS SDK for the Python programming language. In this recipe we will learn how to use `aws-sdk-python` with MinIO server.

## 1. Prerequisites

Install MinIO Server from [here](http://docs.minio.io/docs/minio-quickstart-guide).

## 2. Installation

Install `aws-sdk-python` from AWS SDK for Python official docs [here](https://aws.amazon.com/sdk-for-python/)

## 3. Example

Please replace ``endpoint_url``,``aws_access_key_id``, ``aws_secret_access_key``, ``Bucket`` and ``Object`` with your local setup in this ``example.py`` file.

Example below shows upload and download object operations on MinIO server using aws-sdk-python.

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
s3.Bucket('songs').upload_file('/home/john/piano.mp3','piano.mp3')

# download the object 'piano.mp3' from the bucket 'songs' and save it to local FS as /tmp/classical.mp3
s3.Bucket('songs').download_file('piano.mp3', '/tmp/classical.mp3')

print "Downloaded 'piano.mp3' as  'classical.mp3'. "
```

## 4. Run the Program

```sh
python example.py
Downloaded 'piano.mp3' as  'classical.mp3'.
```
## 5. Explore Further

* [MinIO Python Library for Amazon S3](https://docs.minio.io/docs/python-client-quickstart-guide)
