# Store MongoDB Backups in Minio Server [![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/minio/minio?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

In this recipe we will learn how to store MongoDB backups in Minio Server.


## 1. Prerequisites

* Install mc from [here](https://docs.minio.io/docs/minio-client-quickstart-guide).
* Install Minio Server from [here](https://docs.minio.io/docs/minio ).
* MongoDB official [doc](https://docs.mongodb.com/). 
 

## 2. Configuration Steps

Minio server is running using alias ``m1``. Follow Minio client complete guide [here](https://docs.minio.io/docs/minio-client-complete-guid) for details. MongoDB backups are stored in ``mongobkp`` directory.

### Create a bucket.

```sh
$ mc mb m1/mongobkp
Bucket created successfully ‘m1/mongobkp’.
```

### Continuously mirror local backup to Minio server.

Continuously mirror ``mongobkp`` folder recursively to Minio. Read more on ``mc mirror`` [here](https://docs.minio.io/docs/minio-client-complete-guide#mirror) 

```sh
$ mc mirror --force --remove --watch  mongobkp/ m1/mongobkp
```

