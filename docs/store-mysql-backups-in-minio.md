# Store MySQL Backups in Minio Server [![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/minio/minio?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

In this recipe we will learn how to store MySQL backups in Minio Server.

 
## 1. Prerequisites

* Install mc from [here](https://docs.minio.io/docs/minio-client-quickstart-guide).
* Install Minio Server from [here](https://docs.minio.io/docs/minio ).
* MySQL official [doc](https://dev.mysql.com/doc/)

## 2. Configuration Steps

Minio server is running using alias ``m1``. Follow Minio client complete guide [here](https://docs.minio.io/docs/minio-client-complete-guid) for details. MySQL  backups are stored in ``mongobkp`` directory.


### Create a bucket.

```sh
$ mc mb m1/mysqlbkp
Bucket created successfully ‘m1/mysqlbkp’.
```

### Continuously mirror local backup to Minio server.

Continuously mirror ``mysqlbkp`` folder recursively to Minio. Read more on ``mc mirror`` [here](https://docs.minio.io/docs/minio-client-complete-guide#mirror) 

```sh
$ mc mirror --force --remove --watch mysqlbkp/ m1/mysqlbkp
```

