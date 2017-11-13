# Arq Backup结合Minio进行备份 [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io) 

Arq Backup软件可用于Mac和Windows。Arq以加密格式存储多个版本的文件。备份可以存储在各种云存储后端，包括Minio。本文档将引导你通过Minio进行Arq Backup配置。  

## 1. 前提条件

* 已经安装[Arq Backup](https://www.arqbackup.com/)。
* Minio Server运行在localhost:9000, 参考 [Minio快速入门](https://docs.minio.io/docs/minio-quickstart-guide)来安装Minio。

## 2. 步骤

点击Arq backup图标，从下拉框中选择你的备份目标``Other S3-Comptible service``，然后提供Minio server的配置信息。

![D_BUCKET](https://raw.githubusercontent.com/minio/cookbook/master/docs/screenshots/arqbackup.png?raw=true)

然后选择一个已经存在的存储桶做为备份目标，或者创建一个新的存储桶给Arq backup。

## 3. 了解更多

* [Minio Client完整指南](https://docs.minio.io/docs/minio-client-complete-guide)
* [Arq backup主页](https://www.arqbackup.com/)

