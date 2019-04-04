# How to use fog aws for Ruby with MinIO Server [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

`fog-aws` is the module for 'fog' gem to support Amazon Web Services <http://aws.amazon.com/>.
In this recipe we will learn how to use `fog-aws` for Ruby with MinIO server.

## 1. Prerequisites

Install MinIO Server from [here](http://docs.minio.io/docs/minio-quickstart-guide).

## 2. Installation

Install `fog-aws` for Ruby from  [here](https://github.com/fog/fog-aws)

## 3. Example

Please replace ``host``, ``endpoint``, ``access_key_id``, ``secret_access_key``, ``Bucket`` and ``Object`` with your local setup in this ``example.rb`` file.

Example below shows put_object() and get_object() operations on MinIO server using `fog-aws Ruby`.

```ruby
require 'fog/aws'

connection = Fog::Storage.new({
    provider:              'AWS',                        # required
    aws_access_key_id:     'YOUR-ACCESSKEYID',
    aws_secret_access_key: 'YOUR-SECRETACCESSKEY',
    region:                'us-east-1',                  # optional, defaults to 'us-east-1',
                                                         # Please mention other regions if you have changed
                                                         # minio configuration
    host:                  'localhost',              # Provide your host name here, otherwise fog-aws defaults to
                                                         # s3.amazonaws.com
    endpoint:              'http://localhost:9000', # Required, otherwise defauls to nil
    path_style:         	true,                        # Required
})


# put_object operation

connection.put_object(
        'testbucket',
        'testobject',
        'Hello from MinIO!!',
        content_type: 'text/plain'
)

# get_object operation

download_testobject = connection.get_object(
         'testbucket',
         'testobject'
).body

print "Downloaded 'testobject' as  #{download_testobject}."
```

## 4. Run the Program

```sh
ruby example.rb
Downloaded 'testobject' as  Hello from MinIO!!.
```
