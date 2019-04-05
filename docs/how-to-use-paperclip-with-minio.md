# How to use Paperclip with MinIO Server [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

[Paperclip](https://github.com/thoughtbot/paperclip) is intended as an easy file attachment library for ActiveRecord. In this recipe you will learn how to configure  MinIO as an object storage backend for Paperclip.

## 1. Prerequisites

MinIO Server is installed and running. Please follow [MinIO Quickstart](https://docs.min.io/docs/minio-quickstart-guide) guide to install.

This recipe uses <https://play.min.io:9000>. Play(demo Version) is a hosted MinIO server for testing and development purpose only. Play uses access_key_id ``Q3AM3UQ867SPQQA43P2F``, secret_access_key ``zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG``.

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
    s3_host_name: 'play.min.io:9000',
    s3_options: {
      endpoint: "https://play.min.io:9000",
      force_path_style: true
    },
    url: ':s3_path_url',
    path: "/:class/:id.:style.:extension"
  }
```

## 4. Explore Further
 [MinIO Paperclip Application](https://github.com/sadysnaat/minio-paperclip)
