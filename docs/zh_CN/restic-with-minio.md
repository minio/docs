# restic结合MinIO Server [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

`restic`是一个快速，高性能，并且安全的备份工具。这是一个在``BSD 2-Clause License``下的开源项目。

在本文中，我们将学习如何使用`restic`将数据备份到MinIO Server中。

## 1. 前提条件

从[这里](https://docs.min.io/docs/minio-quickstart-guide)下载并安装MinIO。

## 2. 安装

从[这里](https://restic.github.io)下载并安装restic。

## 3. 配置

如下所示，在环境变量中设置MinIO认证信息。

```sh
export AWS_ACCESS_KEY_ID=<YOUR-ACCESS-KEY-ID>
export AWS_SECRET_ACCESS_KEY= <YOUR-SECRET-ACCESS-KEY>
```

## 4. 命令

启动`restic`，将指定用于备份的存储桶。

```sh
./restic -r s3:http://localhost:9000/resticbucket init
```

从本机拷贝需要备份的数据到MinIO Server的存储桶中。

```sh
./restic -r s3:http://localhost:9000/resticbucket backup /home/minio/workdir/Docs/
enter password for repository:
scan [/home/minio/workdir/Docs]
scanned 2 directories, 6 files in 0:00
[0:00] 100.00%  0B/s  8.045 KiB / 8.045 KiB  6 / 8 items  0 errors  ETA 0:00
duration: 0:00, 0.06MiB/s
snapshot 85a9731a saved
```
