# Store PostgreSQL Backups in Minio Server [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

In this recipe you will learn how to store PostgreSQL backups in Minio Server.

## 1. Prerequisites

* Install mc from [here](https://docs.minio.io/docs/minio-client-quickstart-guide).
* Install Minio Server from [here](https://docs.minio.io/docs/minio ).
* PostgreSQL official [doc](https://www.postgresql.org/docs/).

## 2. Configuration Steps

Minio server is running using alias ``m1``. Follow Minio client complete guide [here](https://docs.minio.io/docs/minio-client-complete-guide) for details. PostgreSQL  backups are stored in ``pgsqlbkp`` directory.

### Create a bucket.

```sh
mc mb m1/pgsqlbkp
Bucket created successfully ‘m1/pgsqlbkp’.
```

### Continuously mirror local backup to Minio server.

Continuously mirror ``pgsqlbkp`` folder recursively to Minio. Read more on ``mc mirror`` [here](https://docs.minio.io/docs/minio-client-complete-guide#mirror)

```sh
mc mirror --force --remove --watch  pgsqlbkp/ m1/pgsqlbkp
```
