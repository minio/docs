# 将MongoDB备份存储到Minio Server [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

在本文中，我们将学习如何将MongoDB备份存储到Minio Server。

## 1. 前提条件

* 从[这里](https://docs.minio.io/docs/minio-client-quickstart-guide)下载并安装mc。
* 从[这里](http://docs.minio.io/docs/minio-quickstart-guide)下载并安装Minio Server。
* MongoDB官方[文档](https://docs.mongodb.com/).

## 2. 配置步骤

Minio服务正在使用别名``minio1``运行。从Minio客户端完整指南[Minio客户端完全指南](https://docs.minio.io/docs/minio-client-complete-guide)了解详情。MongoDB备份存储在``mongobkp``目录下。

### 创建一个存储桶。

```sh
mc mb minio1/mongobkp
Bucket created successfully ‘minio1/mongobkp’.
```

### 将Mongodump存档流式传输到Minio服务器。

示例中包括w/ SSH tunneling和progress bar。

在一个可信/私有的网络中stream db 'blog-data' :

```sh
mongodump -h mongo-server1 -p 27017 -d blog-data --archive | mc pipe minio1/mongobkp/backups/mongo-blog-data-`date +%Y-%m-%d`.archive
```

使用`--archive`选项安全地stream **整个** mongodb server。加密备份，我们将`ssh user@minio-server.example.com`添加到上面的命令中。

```sh
mongodump -h mongo-server1 -p 27017 --archive | ssh user@minio-server.example.com mc pipe minio1/mongobkp/full-db-`date +%Y-%m-%d`.archive
```

#### 显示进度和速度信息

我们将添加一个管道到工具`pv`。（用`brew install pv`或`apt-get install -y pv`安装）

```sh
mongodump -h mongo-server1 -p 27017 --archive | pv -brat | ssh user@minio-server.example.com mc pipe minio1/mongobkp/full-db-`date +%Y-%m-%d`.archive
```

### 持续地将本地备份文件mirror到Minio server。

持续地将``mongobkp``文件夹中所有数据mirror到Minio。更多``mc mirror``信息，请参考 [这里](https://docs.minio.io/docs/minio-client-complete-guide#mirror) 。

```sh
mc mirror --force --remove --watch  mongobkp/ minio1/mongobkp
```

