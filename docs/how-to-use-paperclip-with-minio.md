# How to use Paperclip with Minio Server [![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/minio/minio?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Paperclip is intended as an easy file attachment library for ActiveRecord. In this recipe we will learn how to configure  Minio as Object Storage backend for Paperclip.

Minio can be used to upload contents like images, music and docs with Paperclip as an object storage backend.

## 1. Prerequisites

Public Minio server for developers to use as a sandbox is at https://play.minio.io:9000. In this setup bucket ``mytestbucket``, access_key_id ``Q3AM3UQ867SPQQA43P2F``, secret_access_key ``zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG`` and ``play.minio.io:9000`` as  s3_host_name are used.

## 2. Installation 
 
Install Paperclip from [here](https://github.com/thoughtbot/paperclip)

## 3. Paperclip Configuration

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

