# How to use AWS S3 CLI with Minio Server? [![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/minio/minio?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## This document assumes following.

* Minio server is installed and running, if not [follow this](https://github.com/minio/minio/blob/master/README.md).
* AWS S3 client installed, if not [follow this](http://docs.aws.amazon.com/cli/latest/userguide/installing.html).
* In this example ``minio`` is running locally on port 9000.

## Testing AWS CLI operations
### Create a Bucket
```
$ aws --endpoint-url http://localhost:9000 s3 mb s3://mybucket
make_bucket: s3://mybucket/
```
### Copy local file to a remote bucket.
```
$ aws --endpoint-url http://localhost:9000 s3 cp share/hello.txt s3://mybucket/hello.txt
upload: share/hello.txt to s3://mybucket/hello.txt
```
### List all contents of a bucket.
```
$ aws --endpoint-url http://localhost:9000 s3 ls s3://mybucket
2016-01-11 21:23:36         14 hello.txt
```
### Sync local directory contents to a remote bucket.
```
$ aws --endpoint-url http://localhost:9000 s3 sync . s3://mybucket
upload: sharegain/door.jpg to s3://mybucket/sharegain/door.jpg
upload: sharegain/filter-coffee.jpg to s3://mybucket/sharegain/filter-coffee.jpg
```
### Move local content to a remote bucket.
```
$ aws --endpoint-url http://localhost:9000 s3 mv test.txt s3://mybucket/test2.txt
move: ./test.txt to s3://mybucket/test2.txt
```
### Remove object or objects from a bucket.
#### Remove a single object.
```
$ aws --endpoint-url http://localhost:9000 s3 rm s3://mybucket/test.xyz
delete: s3://mybucket/test.xyz
```
#### Remove all objects in a bucket recursively.
```
$ aws --endpoint-url http://localhost:9000 s3 rm s3://mybucket --recursive
delete: s3://mybucket/door.jpg
delete: s3://mybucket/fu/hey.txt              
delete: s3://mybucket/sharegain/door.jpg           
delete: s3://mybucket/sharegain/filter-coffee.jpg
delete: s3://mybucket/hello.txt                  
delete: s3://mybucket/test2.txt  
```

### Remove a bucket.
```
$ aws --endpoint-url http://localhost:9000 s3 rb s3://mybucket
remove_bucket: s3://mybucket/
```
