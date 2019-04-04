# Deploy Alluxio with MinIO [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

In this recipe we will learn how to setup MinIO as a persistent storage layer for [Alluxio](http://alluxio.org). The Alluxio documentation for using Alluxio with MinIO can be found [here](http://www.alluxio.org/docs/master/en/Configuring-Alluxio-with-MinIO.html).

Alluxio provides memory-speed virtual distributed storage for applications. By using Alluxio with MinIO, applications can access MinIO data at memory speed and with file system APIs commonly used for big data workloads.

## 1. Prerequisites

* Install MinIO Server from [here](https://www.minio.io/).
* Install Alluxio from [here](http://www.alluxio.org/download)

## 2. Setup

This section describes how to set up Alluxio with MinIO assumed to be already running. See the [MinIO quick start guide](https://docs.minio.io/docs/minio-quickstart-guide) for how to set up MinIO.

Extract the downloaded Alluxio binary, using the appropriate version and distribution. If MinIO is the only storage you are using with Alluxio, the distribution is irrelevant.

```sh
tar xvfz alluxio-<VERSION>-<DISTRIBUTION>-bin.tar.gz
cd alluxio-<VERSION>-<DISTRIBUTION>
```

Create a configuration file for Alluxio by copying the template.

```sh
cp conf/alluxio-site.properties.template conf/alluxio-site.properties
```

Modify the Alluxio configuration file appropriately for your deployment. This is an example configuration of running Alluxio locally with MinIO.

Assume the MinIO server is running at <MINIO_HOST:PORT>.
Assume the MinIO bucket you wish to mount in Alluxio is <MINIO_BUCKET>.
Assume the MinIO access key is <ACCESS_KEY> and secret key is <SECRET_KEY>.

```
alluxio.master.hostname=localhost
alluxio.underfs.address=s3a://<MINIO_BUCKET>/
alluxio.underfs.s3.endpoint=http://<MINIO_HOST:PORT>/
alluxio.underfs.s3.disable.dns.buckets=true
alluxio.underfs.s3a.inherit_acl=false
aws.accessKeyId=<ACCESS_KEY>
aws.secretKey=<SECRET_KEY>
```

Start the Alluxio server locally.

```sh
bin/alluxio-start.sh local -f
```

## 3. Using Alluxio with MinIO

Files which already reside in the MinIO bucket will be available thorugh Alluxio. One way to view them is the [Alluxio UI](http://localhost:19999/browse). Applications can access and write data in MinIO through the Alluxio namespace.

You can run Alluxio's built in I/O tests to see this in action.

```sh
bin/alluxio runTests
```

After the tests have run, you will see data which has been written in `THROUGH` modes in MinIO.
