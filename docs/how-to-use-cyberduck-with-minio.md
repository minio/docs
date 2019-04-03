# How to use Cyberduck with MinIO [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

In this document you will learn how to carry out basic operations on MinIO using Cyberduck. Cyberduck is an open source client for FTP and SFTP, WebDAV, OpenStack Swift, and Amazon S3, available for MacOS and Windows. It is released under the GPL license v2.0.  

## 1. Prerequisites

* [Cyberduck](https://cyberduck.io/) is installed and running.  Since MinIO is Amazon S3 compatible, download a generic ``HTTP`` S3 profile from [here](https://trac.cyberduck.io/wiki/help/en/howto/s3#HTTP).

* MinIO Server is running on localhost on port 9000 in ``HTTP``, follow [MinIO quickstart guide](https://docs.minio.io/docs/minio-quickstart-guide) for installing MinIO. 

_NOTE:_ You can also run MinIO in ``HTTPS``, follow this [guide](https://docs.minio.io/docs/generate-let-s-encypt-certificate-using-concert-for-minio) along with Cyberduck generic ``HTTPS`` S3 profile from [here](https://trac.cyberduck.io/wiki/help/en/howto/s3#HTTPS) 

## 2. Steps

### Add MinIO authentication in Cyberduck

Click open connection, select ``HTTP``

![I_IMAGE](https://github.com/minio/cookbook/blob/master/docs/screenshots/cyberduck/defaultdashboard.jpg?raw=true)

### Replace the existing AWS S3 details with your local MinIO credentials

![MINIO_DASH](https://github.com/minio/cookbook/blob/master/docs/screenshots/cyberduck/connecttominio.jpg?raw=true)

### Click on the connect tab to establish connection

Once the connection is established you can explore further, some of the operations are listed below.

#### List Bucket

![B_LISTING](https://github.com/minio/cookbook/blob/master/docs/screenshots/cyberduck/allbuckets.jpg?raw=true)

#### Download bucket

![D_BUCKET](https://github.com/minio/cookbook/blob/master/docs/screenshots/cyberduck/downloadbucket.jpg?raw=true)

#### Mirror Bucket

![M_BUCKET](https://github.com/minio/cookbook/blob/master/docs/screenshots/cyberduck/mirror.jpg?raw=true)

#### Delete Bucket

![D_BUCKET](https://github.com/minio/cookbook/blob/master/docs/screenshots/cyberduck/deletebucket.jpg?raw=true)

## 3. Explore Further

* [MinIO Client complete guide](https://docs.minio.io/docs/minio-client-complete-guide)
* [Cyberduck project homepage](https://cyberduck.io)


