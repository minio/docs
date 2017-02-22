# How to use Paperclip with Minio Server [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

[Paperclip](https://github.com/thoughtbot/paperclip) is intended as an easy file attachment library for ActiveRecord. In this recipe you will learn how to configure  Minio as an object storage backend for Paperclip.

## 1. Prerequisites

Minio Server is installed and running. Please follow [Minio Quickstart](https://docs.minio.io/docs/minio-quickstart-guide) guide to install.

This recipe uses <https://play.minio.io:9000>. Play(demo Version) is a hosted Minio server for testing and development purpose only. Play uses access_key_id ``Q3AM3UQ867SPQQA43P2F``, secret_access_key ``zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG``. 

## 2. Installation 
 
Install Paperclip from [here](https://github.com/thoughtbot/paperclip)

## 3. Paperclip Storage Configuration

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
## 4. Explore Further
 [Minio Paperclip Application](https://github.com/sadysnaat/minio-paperclip) 

