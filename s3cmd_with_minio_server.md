# s3cmd with Minio Server

`s3cmd` is a CLI client for managing data in AWS S3, Google Cloud Storage or any cloud storage service provider that uses the s3 protocol.  `s3cmd` is open source and is distributed under the GPLv2 license.

In this recipe we will learn how to configure and use s3cmd to manage data with Minio Server.

## 1. Prerequisites
Install Minio Server from [here](http://docs.minio.io/docs/minio).

## 2. Installation
Install `s3cmd` from http://s3tools.org/s3cmd.

## 3. Configuration
We will run `s3cmd` on https://play.minio.io:9000.

Access credentials shown in this example belong to https://play.minio.io:9000.
These credentials are open to public. Feel free to use this service for testing and development. Replace with your own Minio keys in deployment.

Edit the following fields in your s3cmd configuration file `~/.s3cfg`
```
# Setup endpoint
host_base = play.minio.io:9000
host_bucket = play.minio.io:9000
bucket_location = us-east-1
use_https = True

# Setup access keys
access_key =  Q3AM3UQ867SPQQA43P2F
secret_key = zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG

# Enable S3 v4 signature APIs
signature_v2 = False
```

## 4. Commands

### To make a bucket
```
$ s3cmd mb s3://mybucket
Bucket 's3://mybucket/' created
```

### To copy an object to bucket
```
$ s3cmd put newfile s3://testbucket
upload: 'newfile' -> 's3://testbucket/newfile'  
```

### To copy an object to local system
```
$ s3cmd get s3://testbucket/newfile
download: 's3://testbucket/newfile' -> './newfile'
```

### To sync local file/directory to a bucket
```
$ s3cmd sync newdemo s3://testbucket
upload: 'newdemo/newdemofile.txt' -> 's3://testbucket/newdemo/newdemofile.txt'
```

### To sync bucket or object with local filesystem
```
$ s3cmd sync  s3://testbucket otherlocalbucket
download: 's3://testbucket/cat.jpg' -> 'otherlocalbucket/cat.jpg'
```

### To list buckets
```
$ s3cmd ls s3://
2015-12-09 16:12  s3://testbbucket
```

### To list contents inside bucket
```
$ s3cmd ls s3://testbucket/
                                      DIR   s3://testbucket/test/
2015-12-09 16:05    138504   s3://testbucket/newfile
```

### To delete an object from bucket
```
$ s3cmd del s3://testbucket/newfile
delete: 's3://testbucket/newfile'
```

### To delete a bucket
```
$ s3cmd rb s3://mybucket
Bucket 's3://mybucket/' removed
```

NOTE:
The complete usage guide for `s3cmd` is available [here](http://s3tools.org/usage).
