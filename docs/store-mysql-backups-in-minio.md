# Store MySQL Backups in MinIO Server [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

In this recipe we will learn how to store MySQL backups in MinIO Server.

 
## 1. Prerequisites

* Install mc from [here](https://docs.min.io/docs/minio-client-quickstart-guide).
* Install MinIO Server from [here](https://docs.min.io/docs/minio-quickstart-guide).
* MySQL official [doc](https://dev.mysql.com/doc/)

## 2. Configuration Steps

MinIO server is running using alias ``m1``. Follow MinIO client complete guide [here](https://docs.min.io/docs/minio-client-complete-guide) for details. MySQL  backups are stored in ``mysqlbkp`` directory.


### Create a bucket.

```sh
mc mb m1/mysqlbkp
Bucket created successfully ‘m1/mysqlbkp’.
```

### Continuously mirror local backup to MinIO server.

Continuously mirror ``mysqlbkp`` folder recursively to MinIO. Read more on ``mc mirror`` [here](https://docs.min.io/docs/minio-client-complete-guide#mirror) 

```sh
mc mirror --force --remove --watch mysqlbkp/ m1/mysqlbkp
```

