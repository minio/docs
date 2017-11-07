# 使用Minio来部署Alluxio [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

本文中，我们将学习如何将Minio设置为[Alluxio](http://alluxio.org)的持久存储层。 [这里](http://www.alluxio.org/docs/master/en/Configuring-Alluxio-with-Minio.html)是Minio与Alluxio如何结合的文档。

Alluxio为应用程序提供了内存级速度的虚拟分布式存储。通过使用Alluxio结合Minio,应用程序可以以内存级速度访问Minio的数据，并使用通常用于大数据工作负载的文件系统API。

## 1. 前提条件

* 从[这里](https://www.minio.io/)安装Minio Server。
* 从[这里](http://www.alluxio.org/download)安装Alluxio。

## 2. 安装

本节介绍如何设置Alluxio结合已经运行的Minio。从[Minio快速入门](https://docs.minio.io/docs/minio-quickstart-guide)了解如何设置Minio。

解压下载好的相应的发行版本的Alluxio二进制文件。如果Minio是Alluxio的唯一存储器，则发行版本无关紧要。

```sh
tar xvfz alluxio-<VERSION>-<DISTRIBUTION>-bin.tar.gz
cd alluxio-<VERSION>-<DISTRIBUTION>
```

拷贝下面的示例模板，创建Alluxio的配置文件。

```sh
cp conf/alluxio-site.properties.template conf/alluxio-site.properties
```

为您的部署适当地修改Alluxio配置文件。下面示例在本地运行Alluxio和Minio的示例配置。

假设Minio Server正在<MINIO_HOST:PORT>处运行。
假设你希望挂载到Alluxio的Minio存储桶是<MINIO_BUCKET>。
假设Minio的access key是<ACCESS_KEY>，secret key是<SECRET_KEY>。

```
alluxio.master.hostname=localhost
alluxio.underfs.address=s3a://<MINIO_BUCKET>/
alluxio.underfs.s3.endpoint=http://<MINIO_HOST:PORT>/
alluxio.underfs.s3.disable.dns.buckets=true
alluxio.underfs.s3a.inherit_acl=false
aws.accessKeyId=<ACCESS_KEY>
aws.secretKey=<SECRET_KEY>
```

在本地启动Alluxio服务。

```sh
bin/alluxio-start.sh local -f
```

## 3. 结合Minio使用Alluxio

已经在Minio存储桶中的文件可以通过Alluxio获取到，你可以通过[Alluxio UI](http://localhost:19999/browse)来查看这些文件。应用程序可以通过Alluxio namespace来读写这些数据。

你可以运行Alluxio内置的I/O测试来实际操作。

```sh
bin/alluxio runTests
```

测试运行后，你会看到数据以`THROUGH`模式写入到Minio。
