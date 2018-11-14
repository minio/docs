# AWS CLI with Minio Server [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

`AWS CLI` is a tool to manage AWS services and transfer data to and from AWS S3. It works with any S3-compatible cloud storage service.

This guide describes how to configure and use AWS CLI to manage buckets with Minio Server. These are the steps you will follow:

1. [Install Minio Server](#installminioserver) 
2. [Install `AWS CLI`](#installawscli) 
3. [Configure `AWS CLI`](#configureawscli) 
4. [Examples of Typical `AWS CLI` Commands](#runawsclicommands)  

## <a name="installminioserver"></a>1. Install Minio Server

Install Minio Server using the instructions in the [Minio Quickstart Guide](https://docs.minio.io).

## <a name="installawscli"></a>2. Install `AWS CLI`

Install `AWS CLI` using these instructions: <https://aws.amazon.com/cli/>.

## <a name="configureawscli"></a>3. Configure `AWS CLI`

### 3.1 Configure the Endpoint
#### 3.1.1 Run `aws configure` to start the configuration process.
#### 3.1.2 Specify the Minio configuration information when prompted:

```sh
AWS Access Key ID [None]: Q3AM3UQ867SPQQA43P2F
AWS Secret Access Key [None]: zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG
Default region name [None]: us-east-1
Default output format [None]: ENTER
```

**Note**: The configuration information set in this example is for public testing and development on `https://play.minio.io:9000`. Modify this information as appropriate when developing for your own Minio Server.

### 3.2 Enable **AWS Signature Version 4** for Minio server

```sh
aws configure set default.s3.signature_version s3v4
```

## <a name="runawsclicommands"></a>4. Examples of Typical `AWS CLI` Commands
### List all Buckets

```sh
aws --endpoint-url https://play.minio.io:9000 s3 ls
```

You should see a response similar to this one:

```sh
2016-03-27 02:06:30 deebucket
2016-03-28 21:53:49 guestbucket
2016-03-29 13:34:34 mbtest
2016-03-26 22:01:36 mybucket
2016-03-26 15:37:02 testbucket
```

### List the Contents of a Bucket

```sh
aws --endpoint-url https://play.minio.io:9000 s3 ls s3://mybucket
```

You should see a response similar to this one:

```sh
2016-03-30 00:26:53      69297 argparse-1.2.1.tar.gz
2016-03-30 00:35:37      67250 simplejson-3.3.0.tar.gz
```


### Create a Bucket

```sh
aws --endpoint-url https://play.minio.io:9000 s3 mb s3://mybucket
```

You should see a response similar to this one:

```sh
make_bucket: s3://mybucket/
```

### Add an Object to a Bucket

```sh
aws --endpoint-url https://play.minio.io:9000 s3 cp simplejson-3.3.0.tar.gz s3://mybucket
```

You should see a response similar to this one:

```sh
upload: ./simplejson-3.3.0.tar.gz to s3://mybucket/simplejson-3.3.0.tar.gz
```

### Delete an Object from a Bucket

```sh
aws --endpoint-url https://play.minio.io:9000 s3 rm s3://mybucket/argparse-1.2.1.tar.gz
```

You should see a response similar to this one:

```sh
delete: s3://mybucket/argparse-1.2.1.tar.gz
```

### Delete a Bucket

```sh
aws --endpoint-url https://play.minio.io:9000 s3 rb s3://mybucket
```

You should see a response similar to this one:
```sh
remove_bucket: s3://mybucket/
```


