# 使用s3fs-fuse操作MinIO Server [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

s3fs允许Linux和Mac OS X通过FUSE安装S3存储桶。请注意，你将无法使用s3fs创建目录，因为MinIO不支持创建文件夹。

在本文中，我们将学习如何配置和使用s3fs从MinIO服务器挂载一个存储桶并将数据复制到它。 

## 1. 前提条件

从[这里](https://docs.min.io/docs/minio-quickstart-guide)下载并安装MinIO Server。

## 2. 安装

从<https://github.com/s3fs-fuse/s3fs-fuse>下载并安装`s3fs-fuse`。

参考[MinIO Client快速入门](https://docs.min.io/docs/minio-client-quickstart-guide)创建一个存储桶。

## 3. 配置

在运行s3fs之前，你需要将MinIO认证信息保存在本教程后面将要使用的文件中。在下面的命令中，将access_key和secret_key替换为你的实际MinIO认证信息。

```
echo "access_key:secret_key" > /etc/s3cred
```

现在创建一个目录，挂载到存储桶中。这时我们使用/s3。

```
mkdir /s3
```

运行`s3fs`挂载存储桶，使用之前命令中的MinIO认证信息。

```
s3fs <bucket> /s3 -o passwd_file=/etc/s3cred,use_path_request_style,url=http://minio-server:9000

```

s3fs与MinIO一起使用时需要`use_path_request_style`。如果您不使用它，则无法在挂载的目录中查看或复制文件。

检查存储桶是否使用mount命令挂载成功：

```
mount | grep s3fs

s3fs on /s3 type fuse.s3fs (rw,nosuid,nodev,relatime,user_id=0,group_id=0)
```

拷贝一个文件到挂载的存储桶中：

```
cp /etc/resolv.conf /s3
```

使用mc来检查文件是否存在：

```
# mc ls <minio-server>/<bucket>
[2017-04-07 21:49:39 PDT]    49B resolv.conf
```

恭喜你，万事大吉，你可以尽情享受s3fs和MinIO。
