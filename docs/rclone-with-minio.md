# Rclone with MinIO Server [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

`Rclone` is an open source command line program to sync files and
directories to and from cloud storage systems.  It aims to be "rsync
for cloud storage".

This recipe describes how to use rclone with MinIO Server.

## 1. Prerequisites

First install MinIO Server from [min.io](https://min.io/).

## 2. Installation

Next install Rclone from [rclone.org](http://rclone.org).

## 3. Configuration

When it configures itself MinIO will print something like this

```sh
Endpoint:  http://10.0.0.3:9000  http://127.0.0.1:9000  http://172.17.0.1:9000
AccessKey: USWUXHGYZQYFYFFIT3RE
SecretKey: MOJRH0mkL1IPauahWITSVvyDrQbEEIwljvmxdq03
Region:    us-east-1

Browser Access:
  http://10.0.0.3:9000  http://127.0.0.1:9000  http://172.17.0.1:9000

Command-line Access: https://docs.min.io/docs/minio-client-quickstart-guide
  $ mc config host add myminio http://10.0.0.3:9000 USWUXHGYZQYFYFFIT3RE MOJRH0mkL1IPauahWITSVvyDrQbEEIwljvmxdq03

Object API (Amazon S3 compatible):
  Go:         https://docs.min.io/docs/golang-client-quickstart-guide
  Java:       https://docs.min.io/docs/java-client-quickstart-guide
  Python:     https://docs.min.io/docs/python-client-quickstart-guide
  JavaScript: https://docs.min.io/docs/javascript-client-quickstart-guide
```

You now need to configure those details into rclone.

Run `Rclone config`, create a new remote called `minio` (or anything
else) of type `S3` and enter the details above something like this:

(Note that it is important to put the region in as stated above.)

```sh
env_auth> 1
access_key_id> USWUXHGYZQYFYFFIT3RE
secret_access_key> MOJRH0mkL1IPauahWITSVvyDrQbEEIwljvmxdq03  
region> us-east-1
endpoint> http://10.0.0.3:9000
location_constraint>
server_side_encryption>
```

Which makes the config file look like this

```sh
[minio]
type = s3
env_auth = false
access_key_id = USWUXHGYZQYFYFFIT3RE
secret_access_key = MOJRH0mkL1IPauahWITSVvyDrQbEEIwljvmxdq03F
region = us-east-1
endpoint = http://10.0.0.3:9000
location_constraint =
server_side_encryption =
```

## 4. Commands

Here are some example commands

List buckets

    rclone lsd minio:

Make a new bucket

    rclone mkdir minio:bucket

Copy files into that bucket

    rclone copy /path/to/files minio:bucket

Copy files back from that bucket

    rclone copy minio:bucket /tmp/bucket-copy

List all the files in the bucket

    rclone ls minio:bucket

Sync files into that bucket - try with `--dry-run` first

    rclone --dry-run sync /path/to/files minio:bucket

Then sync for real

    rclone sync /path/to/files minio:bucket

See the [Rclone web site](https://rclone.org/s3/#minio) for more examples and docs.
