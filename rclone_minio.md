# rclone with Minio Server

`rclone` is an open source command line program to sync files and
directories to and from cloud storage systems.  It aims to be "rsync
for cloud storage".

This recipe describes how to use rclone with Minio Server.

## 1. Prerequisites
First install Minio Server from [minio.io](https://minio.io/).

## 2. Installation
Next install rclone from [rclone.org](http://rclone.org).

## 3. Configuration
When it configures itself Minio will print something like this

```
AccessKey: WLGDGYAQYIGI833EV05A  SecretKey: BYvgJM101sHngl2uzjXS/OBF/aMxAN06JrJ3qJlF Region: us-east-1

Minio Object Storage:
     http://127.0.0.1:9000
     http://10.0.0.3:9000

Minio Browser:
     http://127.0.0.1:9000
     http://10.0.0.3:9000
```

You now need to configure those details into rclone.

Run `rclone config`, create a new remote called `minio` (or anything
else) of type `S3` and enter the details above something like this:

(Note that it is important to put the region in as stated above.)

```
env_auth> 1
access_key_id> WLGDGYAQYIGI833EV05A
secret_access_key> BYvgJM101sHngl2uzjXS/OBF/aMxAN06JrJ3qJlF   
region> us-east-1
endpoint> http://10.0.0.3:9000
location_constraint> 
server_side_encryption>
```

Which makes the config file look like this

```
[minio]
env_auth = false
access_key_id = WLGDGYAQYIGI833EV05A
secret_access_key = BYvgJM101sHngl2uzjXS/OBF/aMxAN06JrJ3qJlF
region = us-east-1
endpoint = http://10.0.0.3:9000
location_constraint = 
server_side_encryption = 
```

## 4. Commands

Minio doesn't support all the features of S3 yet.  In particular it
doesn't support MD5 checksums (ETags) or metadata.  This means rclone
can't check MD5SUMs or store the modified date.  However you can work
around this with the `--size-only` flag of rclone.

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

See the [rclone web site](http://rclone.org) for more examples and docs.
