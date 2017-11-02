# Store MySQL Backups in Minio Server [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

In this recipe we will learn how to store MySQL backups in Minio Server.

 
## 1. Prerequisites

* Install mc from [here](https://docs.minio.io/docs/minio-client-quickstart-guide).
* Install Minio Server from [here](https://docs.minio.io/docs/minio-quickstart-guide).
* MySQL official [doc](https://dev.mysql.com/doc/)

## 2. Configuration Steps

Minio server is running using alias ``m1``. Follow Minio client complete guide [here](https://docs.minio.io/docs/minio-client-complete-guide) for details. MySQL  backups are stored in ``mysqlbkp`` directory.


### Create a bucket.

```sh
mc mb m1/mysqlbkp
Bucket created successfully ‘m1/mysqlbkp’.
```

### Continuously mirror local backup to Minio server.

Continuously mirror ``mysqlbkp`` folder recursively to Minio. Read more on ``mc mirror`` [here](https://docs.minio.io/docs/minio-client-complete-guide#mirror) 

```sh
mc mirror --force --remove --watch mysqlbkp/ m1/mysqlbkp
```

