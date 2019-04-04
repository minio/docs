# How to use Mountain Duck with MinIO [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

In this recipe you will learn how to carry out basic operations on MinIO using Mountain Duck. Mountain Duck lets you mount server and cloud storage as a local disk in the Finder.app on Mac and the File Explorer on Windows. It is released under the GPL license v2.0. 

## 1. Prerequisites

* [Mountain Duck](https://mountainduck.io/) is installed and running. Since MinIO is Amazon S3 compatible, download a generic ``HTTP`` S3 profile from [here](https://trac.cyberduck.io/wiki/help/en/howto/s3#HTTP).

* MinIO Server is running on localhost on port 9000 in ``HTTP``, follow [MinIO quickstart guide](https://docs.min.io/docs/minio-quickstart-guide) to install MinIO. 

_NOTE:_ You can also run MinIO in ``HTTPS``, follow this [guide](https://docs.min.io/docs/generate-let-s-encypt-certificate-using-concert-for-minio) along with Mountain Duck generic ``HTTPS`` S3 profile from [here](https://trac.cyberduck.io/wiki/help/en/howto/s3#HTTPS). 

## 2. Steps

### Add MinIO authentication in Mountain Duck

Click on Mountain Duck icon and open the application via navigation menu. Click open connection, select ``S3(HTTP)``

![I_IMAGE](https://github.com/minio/cookbook/blob/master/docs/screenshots/mountainduck/defaultdashboard.jpg?raw=true)

### Replace the existing AWS S3 details with your local MinIO credentials 

![MINIO_DASH](https://github.com/minio/cookbook/blob/master/docs/screenshots/mountainduck/connecttominio.jpg?raw=true)

![MINIO_DASH2](https://github.com/minio/cookbook/blob/master/docs/screenshots/mountainduck/connecttominio1.jpg?raw=true)


### Click on the connect tab to establish connection.

You will be asked to connect via insecure connection since we are using HTTP instead of HTTPS, accept it. Once the connection is established you can explore further, some operations are listed below. 

#### List Bucket

![B_LISTING](https://github.com/minio/cookbook/blob/master/docs/screenshots/mountainduck/listbuckets.jpg?raw=true)

#### Copy bucket to local file system

![D_BUCKET](https://github.com/minio/cookbook/blob/master/docs/screenshots/mountainduck/copybucket.jpg?raw=true)

#### Delete Bucket

![D_BUCKET](https://github.com/minio/cookbook/blob/master/docs/screenshots/mountainduck/deletebucket.jpg?raw=true)

## 3. Explore Further

* [MinIO Client complete guide](https://docs.min.io/docs/minio-client-complete-guide)
* [Mountain Duck project homepage](https://mountainduck.io)

