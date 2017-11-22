# 如何使用Paperclip操作Minio Server [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

[Paperclip](https://github.com/thoughtbot/paperclip)旨在作为一个简单的ActiveRecord文件附件库。在本文中，你将学习如何将Minio配置为Paperclip的对象存储后端。

## 1. 前提条件

Minio Server已经安装并运行。参考[这里](https://docs.minio.io/docs/minio-quickstart-guide)下载并安装Minio Server。

本文使用<https://play.minio.io:9000>。Play(demo Version)做为托管Minio Server,仅用于进行测试和开发。
Play使用access_key_id ``Q3AM3UQ867SPQQA43P2F``, secret_access_key ``zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG``。

## 2. 安装

从[这里](https://github.com/thoughtbot/paperclip)安装Paperclip

## 3. Paperclip存储配置

```ruby
config.paperclip_defaults = {
    storage: :s3,
    s3_protocol: ':https',
    s3_permissions: 'public',
    s3_region: 'us-east-1',     
    s3_credentials: {
      bucket: 'mytestbucket',
      access_key_id: 'Q3AM3UQ867SPQQA43P2F',
      secret_access_key: 'zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG',
    },
    s3_host_name: 'play.minio.io:9000',
    s3_options: {
      endpoint: "https://play.minio.io:9000",
      force_path_style: true
    },
    url: ':s3_path_url',
    path: "/:class/:id.:style.:extension"
  }
```

## 4. 了解更多
 [Minio Paperclip Application](https://github.com/sadysnaat/minio-paperclip)
