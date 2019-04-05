# Rclone结合MinIO Server [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

`Rclone`是一个开源的命令行程序，用来同步文件和目录进或者出云存储系统。它旨在成为"云存储的rsync"。

本文介绍了如何使用rclone来同步MinIO Server。

## 1. 前提条件

首先从[min.io](https://min.io/)下载并安装MinIO。

## 2. 安装

然后从[rclone.org](http://rclone.org)下载并安装Rclone。

## 3. 配置

当配置好后，MinIO会输出下面的信息

```sh
Endpoint:  http://10.0.0.3:9000  http://127.0.0.1:9000  http://172.17.0.1:9000
AccessKey: USWUXHGYZQYFYFFIT3RE
SecretKey: MOJRH0mkL1IPauahWITSVvyDrQbEEIwljvmxdq03
Region:    us-east-1

浏览器访问：
  http://10.0.0.3:9000  http://127.0.0.1:9000  http://172.17.0.1:9000

命令行访问： https://docs.min.io/docs/minio-client-quickstart-guide
  $ mc config host add myminio http://10.0.0.3:9000 USWUXHGYZQYFYFFIT3RE MOJRH0mkL1IPauahWITSVvyDrQbEEIwljvmxdq03

Object API (Amazon S3 compatible):
  Go:         https://docs.min.io/docs/golang-client-quickstart-guide
  Java:       https://docs.min.io/docs/java-client-quickstart-guide
  Python:     https://docs.min.io/docs/python-client-quickstart-guide
  JavaScript: https://docs.min.io/docs/javascript-client-quickstart-guide
```

你现在需要将这些信息配置到rclone。

运行`Rclone config`，创建一个新的`S3`类型的remote,叫`minio`(你也可以改成别的名字)，然后输入类似下面的信息：

(请注意，按照上面的说明，加入region参数，这很重要。)

```sh
env_auth> 1
access_key_id> USWUXHGYZQYFYFFIT3RE
secret_access_key> MOJRH0mkL1IPauahWITSVvyDrQbEEIwljvmxdq03  
region> us-east-1
endpoint> http://10.0.0.3:9000
location_constraint>
server_side_encryption>
```

配置文件看起来就像这样

```sh
[minio]
env_auth = false
access_key_id = USWUXHGYZQYFYFFIT3RE
secret_access_key = MOJRH0mkL1IPauahWITSVvyDrQbEEIwljvmxdq03F
region = us-east-1
endpoint = http://10.0.0.3:9000
location_constraint =
server_side_encryption =
```

## 4. 命令

MinIO目前并不支持所有的S3特性。特别是它不支持MD5校验（ETag）或者是元数据。这就表示Rclone不能通过MD5SUMs进行校验或者保存最后修改时间。不过你可以用Rclone的`--size-only` flag。

下面是一些示例命令

列举存储桶

    rclone lsd minio:

创建一个新的存储桶

    rclone mkdir minio:bucket

拷贝文件到存储桶

    rclone --size-only copy /path/to/files minio:bucket

从存储桶中拷贝文件

    rclone --size-only copy minio:bucket /tmp/bucket-copy

列举存储桶中的所有文件

    rclone ls minio:bucket

同步文件到存储桶 - 先试试`--dry-run`

    rclone --size-only --dry-run sync /path/to/files minio:bucket

然后再来真的

    rclone --size-only sync /path/to/files minio:bucket

更多示例以及文档，尽在[Rclone web site](http://rclone.org)，不要错过哦。
