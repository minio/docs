# How to use Cyberduck with Minio [![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/minio/minio?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

In this document you will learn how to carry out basic operations on Minio using Cyberduck. Cyberduck is an open source client for FTP and SFTP, WebDAV, OpenStack Swift, and Amazon S3, available for Mac OS X and Windows. It is released  under the GPL license v2.0.  

## 1. Prerequisites

* [Cyberduck](https://cyberduck.io/) is installed and running.  Since Minio is Amazon S3 API compatible you will need to download [Generic S3 Profiles](https://trac.cyberduck.io/wiki/help/en/howto/s3#HTTP). We are downloading ``HTTP`` profile for this setup.

* Minio Server is running on localhost on port 9000 in ``HTTP``, follow [Minio quickstart guide](https://docs.minio.io/docs/minio-quickstart-guide) for installing Minio. 

_NOTE:_ You can also run Minio in ``HTTPS``, follow this [guide](https://docs.minio.io/docs/generate-let-s-encypt-certificate-using-concert-for-minio) along with Cyberduck HTTPS [Generic S3 Profiles](https://trac.cyberduck.io/wiki/help/en/howto/s3#HTTPS) 

## 2. Steps

###  Add Minio authentication in Cyberduck

Click open connection, select ``HTTP``

![I_IMAGE](https://github.com/minio/cookbook/blob/master/docs/screenshots/cyberduck/defaultdashboard.jpg?raw=true)

### Replace the existing AWS S3 details with your local Minio credentials

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

* [Minio Client complete guide](https://docs.minio.io/docs/minio-client-complete-guide)
* [Cyberduck project homepage](https://cyberduck.io)


