# S3cmd with Minio Server [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

`s3fs allows Linux and Mac OS X to mount an S3 bucket via FUSE

In this recipe we will learn how to configure and use s3fs to mount a bucket from the Minio Server and copy data to it. 
## 1. Prerequisites

Install Minio Server from [here](http://docs.minio.io/docs/minio).

## 2. Installation

Install `s3fs-fuse` from <https://github.com/s3fs-fuse/s3fs-fuse>.

## 3. Configuration

Create a bucket on the Minio Server.

Before you run s3fs, you will need to save your S3 credentials in a file that will be used later in this tutorial. In the command below replace access_key and secret_key with your actual Minio credentials. 

```
echo "access_key:secret_key" > /etc/s3cred
```

Now create a directory to mount the bucket.

```
mkdir /s3
```


Run `s3fs` to mount the bucket from the Minio server using the S3 credentials from the previous command.

```
s3fs <bucket> <mount-point> -o passwd_file=/etc/s3cred,use_path_request_style,url=http://minio-server:8000

```

