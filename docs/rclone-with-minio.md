# Rclone with Minio Server [![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/minio/minio?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

`Rclone` is an open source command line program to sync files and
directories to and from cloud storage systems.  It aims to be "rsync
for cloud storage".

This recipe describes how to use rclone with Minio Server.

## 1. Prerequisites

First install Minio Server from [minio.io](https://minio.io/).

## 2. Installation

Next install Rclone from [rclone.org](http://rclone.org).

## 3. Configuration

When it configures itself Minio will print something like this

```

Endpoint:  http://10.0.0.3:9000  http://127.0.0.1:9000  http://172.17.0.1:9000
AccessKey: USWUXHGYZQYFYFFIT3RE
SecretKey: MOJRH0mkL1IPauahWITSVvyDrQbEEIwljvmxdq03
Region:    us-east-1

Browser Access:
  http://10.0.0.3:9000  http://127.0.0.1:9000  http://172.17.0.1:9000

Command-line Access: https://docs.minio.io/docs/minio-client-quickstart-guide
  $ mc config host add myminio http://10.0.0.3:9000 USWUXHGYZQYFYFFIT3RE MOJRH0mkL1IPauahWITSVvyDrQbEEIwljvmxdq03

Object API (Amazon S3 compatible):
  Go:         https://docs.minio.io/docs/golang-client-quickstart-guide
  Java:       https://docs.minio.io/docs/java-client-quickstart-guide
  Python:     https://docs.minio.io/docs/python-client-quickstart-guide
  JavaScript: https://docs.minio.io/docs/javascript-client-quickstart-guide


```

You now need to configure those details into rclone.

Run `Rclone config`, create a new remote called `minio` (or anything
else) of type `S3` and enter the details above something like this:

(Note that it is important to put the region in as stated above.)

```

env_auth> 1
access_key_id> USWUXHGYZQYFYFFIT3RE
secret_access_key> MOJRH0mkL1IPauahWITSVvyDrQbEEIwljvmxdq03  
region> us-east-1
endpoint> http://10.0.0.3:9000
location_constraint> 
server_side_encryption>

```

Which makes the config file look like this

```

[minio]
env_auth = false
access_key_id = USWUXHGYZQYFYFFIT3RE
secret_access_key = MOJRH0mkL1IPauahWITSVvyDrQbEEIwljvmxdq03F
region = us-east-1
endpoint = http://10.0.0.3:9000
location_constraint = 
server_side_encryption = 

```

## 4. Commands

Minio doesn't support all the features of S3 yet.  In particular it
doesn't support MD5 checksums (ETags) or metadata.  This means Rclone
can't check MD5SUMs or store the modified date.  However you can work
around this with the `--size-only` flag of Rclone.

Here are some example commands

List buckets

    rclone lsd minio:

Make a new bucket

    rclone mkdir minio:bucket

Copy files into that bucket

    rclone --size-only copy /path/to/files minio:bucket

Copy files back from that bucket

    rclone --size-only copy minio:bucket /tmp/bucket-copy

List all the files in the bucket

    rclone ls minio:bucket

Sync files into that bucket - try with `--dry-run` first

    rclone --size-only --dry-run sync /path/to/files minio:bucket

Then sync for real

    rclone --size-only sync /path/to/files minio:bucket

See the [Rclone web site](http://rclone.org) for more examples and docs.
