# 将PostgreSQL备份存储到Minio Server [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

在本文中，我们将学习如何将PostgreSQL备份存储到Minio Server。

## 1. 前提条件

* 从[这里](https://docs.minio.io/docs/minio-client-quickstart-guide)下载并安装mc。
* 从[这里](http://docs.minio.io/docs/minio-quickstart-guide)下载并安装Minio Server。
* PostgreSQL官方[文档](https://www.postgresql.org/docs/).

## 2. 配置步骤

Minio服务正在使用别名``m1``运行。从Minio客户端完整指南[Minio客户端完全指南](https://docs.minio.io/docs/minio-client-complete-guide)了解详情。PostgreSQL备份存储在``pgsqlbkp``目录下。

### 创建一个存储桶。

```sh
mc mb m1/pgsqlbkp
Bucket created successfully ‘m1/pgsqlbkp’.
```

### 持续地将本地备份文件mirror到Minio server。

持续地将``pgsqlbkp``文件夹中所有数据mirror到Minio。更多``mc mirror``信息，请参考[这里](https://docs.minio.io/docs/minio-client-complete-guide#mirror) 。

```sh
mc mirror --force --remove --watch  pgsqlbkp/ m1/pgsqlbkp
```
