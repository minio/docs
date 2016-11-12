# Store MongoDB Backups in Minio Server [![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/minio/minio?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

In this recipe we will learn how to store MongoDB backups in Minio Server.


## 1. Prerequisites

* Install mc from [here](https://docs.minio.io/docs/minio-client-quickstart-guide).
* Install Minio Server from [here](https://docs.minio.io/docs/minio ).
* MongoDB official [doc](https://docs.mongodb.com/). 
 

## 2. Configuration Steps

Minio server is running using alias ``minio1``. Follow Minio client complete guide [here](https://docs.minio.io/docs/minio-client-complete-guid) for details. MongoDB backups are stored in ``mongobkp`` directory.

### Create a bucket.

```sh
$ mc mb minio1/mongobkp
Bucket created successfully ‘minio1/mongobkp’.
```

### Streaming Mongodump Archive to Minio server.

Examples included w/ SSH tunneling & progress.

```sh
# On a trusted/private network stream db 'blog-data' :
$ mongodump -h mongo-server1 -p 27017 -d blog-data --archive | mc pipe minio1/mongobkp/backups/mongo-blog-data-`date +%Y-%m-%d`.archive
```

```sh
# Securely stream **entire** mongodb server using `--archive` option. encrypted backup.
# We'll add `ssh s3ish@minio-server.example.com ` to the command from above.

$ mongodump -h mongo-server1 -p 27017 --archive | ssh s3ish@minio-server.example.com mc pipe minio1/mongobkp/full-db-`date +%Y-%m-%d`.archive


```

#### Show Progress & Speed Info

We'll add a pipe to the utility `pv`. (Install with either `brew install pv` or `apt-get install -y pv`)

```sh
mongodump -h mongo-server1 -p 27017 --archive | pv -brat | ssh s3ish@minio-server.example.com mc pipe minio1/mongobkp/full-db-`date +%Y-%m-%d`.archive


```

### Continuously mirror local backup to Minio server.

Continuously mirror ``mongobkp`` folder recursively to Minio. Read more on ``mc mirror`` [here](https://docs.minio.io/docs/minio-client-complete-guide#mirror) 

```sh
$ mc mirror --force --remove --watch  mongobkp/ minio1/mongobkp
```

