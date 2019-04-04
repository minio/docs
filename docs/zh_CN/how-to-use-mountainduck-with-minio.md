# 如何使用Mountain Duck结合MinIO [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

在本文中，你将学习如何使用Mountain Duck（中文名是山鸭，不是山鸡）在MinIO上进行基本操作。Mountain Duck可让你将服务器和云存储装载为Mac上的Finder.app和Windows上的文件资源管理器中的本地磁盘。它是在GPL许可证v2.0下发布的。

## 1. 前提条件

* [Mountain Duck](https://mountainduck.io/)已经安装并运行。 由于MinIO与Amazon S3兼容,请从[这里](https://trac.cyberduck.io/wiki/help/en/howto/s3#HTTP)下载一个通用的``HTTP`` S3配置文件。

* MinIO Server已经在本地运行，采用``http``,端口9000, 参考 [MinIO快速入门](https://docs.min.io/docs/minio-quickstart-guide)来安装MinIO。

_注意:_ 你也可以用``HTTPS``方式来运行MinIO, 参考[这里](https://docs.min.io/docs/generate-let-s-encypt-certificate-using-concert-for-minio)，以及[这里](https://trac.cyberduck.io/wiki/help/en/howto/s3#HTTPS)描述的Mountain Duck通用``HTTPS`` S3配置文件。

## 2. 步骤

### 在Mountain Duck添加MinIO认证信息

点击Mountain Duck图标，通过导航菜单打开应用程序。点击打开连接，选择``S3(HTTP)``

![I_IMAGE](https://github.com/minio/cookbook/blob/master/docs/screenshots/mountainduck/defaultdashboard.jpg?raw=true)

### 修改已有AWS S3信息为你本地的MinIO凭证

![MINIO_DASH](https://github.com/minio/cookbook/blob/master/docs/screenshots/mountainduck/connecttominio.jpg?raw=true)

![MINIO_DASH2](https://github.com/minio/cookbook/blob/master/docs/screenshots/mountainduck/connecttominio1.jpg?raw=true)


### 点击connect页签建立连接

你将被要求连接通过不安全的连接，因为我们使用HTTP而不是HTTPS，接受它。建立连接后，你可以进一步探索，下面列出了一些操作。

#### 列举存储桶

![B_LISTING](https://github.com/minio/cookbook/blob/master/docs/screenshots/mountainduck/listbuckets.jpg?raw=true)

#### 复制存储桶到本地文件系统

![D_BUCKET](https://github.com/minio/cookbook/blob/master/docs/screenshots/mountainduck/copybucket.jpg?raw=true)

#### 删除存储桶

![D_BUCKET](https://github.com/minio/cookbook/blob/master/docs/screenshots/mountainduck/deletebucket.jpg?raw=true)

## 3. 了解更多

* [MinIO Client完全指南](https://docs.min.io/docs/minio-client-complete-guide)
* [Mountain Duck project homepage](https://mountainduck.io)

