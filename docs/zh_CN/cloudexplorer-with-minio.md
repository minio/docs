# 如何使用Cloud Explorer操作MinIO [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

在本文中，我们将学习如何使用Cloud Explorer对MinIO进行基本操作。Cloud Explorer是一个开源的S3客户端，它适用于Windows，Linux和Mac。它为每个支持的操作系统提供图形和命令行界面。如果你有功能建议或发现错误，请提issue。

## 功能

* 搜索
* 性能测试
* 在S3帐户之间迁移存储桶
* 简单的文本编辑器
* 同步文件夹
* 创建存储桶的快照

## 前提条件

- 已经安装并运行[Cloud Explorer](https://github.com/rusher81572/cloudExplorer)。

- MinIO Server已经在本地运行，端口9000, 参考 [MinIO快速入门](https://docs.min.io/docs/minio-quickstart-guide)来安装MinIO。


## 步骤

- 添加你的MinIO账号到Cloud Explorer并点击保存。

![ACCOUNT](https://raw.githubusercontent.com/minio/cookbook/master/docs/screenshots/cloudexplorer/cloudexplorer-1.png)

- 点击MinIO帐户，然后点击"Load"按钮进行连接。以后再点击已保存的S3账户将自动加载账户并显示该账户下的存储桶。

![ACCOUNT](https://raw.githubusercontent.com/minio/cookbook/master/docs/screenshots/cloudexplorer/cloudexplorer-2.png)

- 创建存储桶

![B_LISTING](https://raw.githubusercontent.com/minio/cookbook/master/docs/screenshots/cloudexplorer/cloudexplorer-3.png)

- 上传一个文件到存储桶

![D_BUCKET](https://raw.githubusercontent.com/minio/cookbook/master/docs/screenshots/cloudexplorer/cloudexplorer-4.png)

- 点击放大镜图标，然后再点击"Refresh Bucket"来查看上传的文件。

![D_BUCKET](https://raw.githubusercontent.com/minio/cookbook/master/docs/screenshots/cloudexplorer/cloudexplorer-6.png)


## 了解更多

- [MinIO Client完全指南](https://docs.min.io/docs/minio-client-complete-guide)
- [Cloud Explorer主页](https://github.com/rusher81572/cloudExplorer)
- [Linux-toys.com](https://www.linux-toys.com/?page_id=211)
