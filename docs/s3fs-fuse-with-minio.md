# s3fs-fuse with Minio Server [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

s3fs allows Linux and Mac OS X to mount an S3 bucket via FUSE. Please note that you will not be able to create directories with s3fs because Minio does not support creating folders.

In this recipe we will learn how to configure and use s3fs to mount a bucket from the Minio Server and copy data to it. 
## 1. Prerequisites

Install Minio Server from [here](http://docs.minio.io/docs/minio).

## 2. Installation

Install `s3fs-fuse` from <https://github.com/s3fs-fuse/s3fs-fuse>.

Create a bucket on the Minio Server to use with this cookbook.

## 3. Configuration

Before you run s3fs, you will need to save your S3 credentials in a file that will be used later in this tutorial. In the command below, replace access_key and secret_key with your actual Minio credentials. 

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

use_path_request_style is required for s3fs to work with Minio. If you do not use it, you will not be able to see or copy files in the mounted directory. 


Check to see that the bucket is mounted with the mount command:

```
mount | grep s3fs

s3fs on <mount-point> type fuse.s3fs (rw,nosuid,nodev,relatime,user_id=0,group_id=0)
```

Copy a file to the mounted bucket:

```
cp /etc/resolv.conf <mount-point>
```

Verify that the file exists with the Minio command-line utility mc:

```
# mc ls <minio-server>/<bucket>
[2017-04-07 21:49:39 PDT]    49B resolv.conf
```

Now you are all set to enjoy using Minio with s3fs!
