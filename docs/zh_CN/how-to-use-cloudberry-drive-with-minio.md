# 如何使用CloudBerry Drive结合Minio [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

本文我们将学习如何将Minio挂载成一个windows操作系统的磁盘。这对多个用户共享文件很有用。

## 1. 前提条件

* [CloudBerry Drive](http://www.cloudberrylab.com/drive/)安装并运行。

* Minio Server已经在本地运行，采用``http``,端口9000, 参考 [Minio快速入门](https://docs.minio.io/docs/minio-quickstart-guide)来安装Minio。

_注意:_ 你也可以用``HTTPS``方式来运行Minio, 参考[这里](https://docs.minio.io/docs/generate-let-s-encypt-certificate-using-concert-for-minio)。

## 2. 步骤

### 在CloudBerry Drive加密Minio为存储账户

一旦安装了CloudBerry，你可以使用托盘中的配置设置（右下角，靠近clock按钮）来更改其图标。填写相应的字段（service point - 你的服务器IP与8000/9000端口取决于你的签名版本，access key和secret key可以从运行服务器控制台获得）。你可以激活SSL，但是你的服务器应该进行相应的配置。分段上传允许将文件拆分成多个块，并将其上传到多个线程中。它是默认启用的。

  ![CloudBerry Drive for S3 compatible](https://raw.githubusercontent.com/minio/cookbook/master/docs/screenshots/cloudberrylab/cloudberry-drive-storage-minio-configuration.jpg?raw=true)

### 添加磁盘

现在，当你设置了存储帐户时，你可以开始制作磁盘并将其映射到Windows计算机（甚至可以将其设置为网络共享并在整个企业网络中提供）。做相应的设置并点击确定启用磁盘。

  ![CloudBerry Drive options for mapped drive] (https://raw.githubusercontent.com/minio/cookbook/master/docs/screenshots/cloudberrylab/cloudberry-drive-mapped-drive-settings.jpg?raw=true)


### 检查你的映射磁盘，并开始管理你的文件

查看你的磁盘并开始管理文件。

  ![CloudBerry Drive for Minio, view content](https://raw.githubusercontent.com/minio/cookbook/master/docs/screenshots/cloudberrylab/cloudberry-drive-mapped-disk-show-content.jpg?raw=true)

## 3. 了解更多

* [Minio Client完全指南](https://docs.minio.io/docs/minio-client-complete-guide)
* [CloudBerry Explorer for Minio](http://www.cloudberrylab.com/explorer)
