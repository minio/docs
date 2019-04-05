# 将PostgreSQL备份存储到MinIO Server [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

在本文中，我们将学习如何将PostgreSQL备份存储到MinIO Server。

## 1. 前提条件

* 从[这里](https://docs.min.io/docs/minio-client-quickstart-guide)下载并安装mc。
* 从[这里](https://docs.min.io/docs/minio-quickstart-guide)下载并安装MinIO Server。
* PostgreSQL官方[文档](https://www.postgresql.org/docs/).

## 2. 配置步骤

MinIO服务正在使用别名``m1``运行。从MinIO客户端完整指南[MinIO客户端完全指南](https://docs.min.io/docs/minio-client-complete-guide)了解详情。PostgreSQL备份存储在``pgsqlbkp``目录下。

### 创建一个存储桶。

```sh
mc mb m1/pgsqlbkp
Bucket created successfully ‘m1/pgsqlbkp’.
```

### 持续地将本地备份文件mirror到MinIO Server。

持续地将``pgsqlbkp``文件夹中所有数据mirror到MinIO。更多``mc mirror``信息，请参考[这里](https://docs.min.io/docs/minio-client-complete-guide#mirror) 。

```sh
mc mirror --force --remove --watch  pgsqlbkp/ m1/pgsqlbkp
```
