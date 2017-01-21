# How to use Mountain Duck with Minio [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

In this recipe you will learn how to carry out basic operations on Minio using Mountain Duck. Mountain Duck lets you mount server and cloud storage as a local disk in the Finder.app on Mac and the File Explorer on Windows. It is released under the GPL license v2.0. 

## 1. Prerequisites

* [Mountain Duck](https://mountainduck.io/) is installed and running. Since Minio is Amazon S3 compatible, download a generic ``HTTP`` S3 profile from [here](https://trac.cyberduck.io/wiki/help/en/howto/s3#HTTP).

* Minio Server is running on localhost on port 9000 in ``HTTP``, follow [Minio quickstart guide](https://docs.minio.io/docs/minio-quickstart-guide) to install Minio. 

_NOTE:_ You can also run Minio in ``HTTPS``, follow this [guide](https://docs.minio.io/docs/generate-let-s-encypt-certificate-using-concert-for-minio) along with Mountain Duck generic ``HTTPS`` S3 profile from [here](https://trac.cyberduck.io/wiki/help/en/howto/s3#HTTPS). 

## 2. Steps

### Add Minio authentication in Mountain Duck

Click on Mountain Duck icon and open the application via navigation menu. Click open connection, select ``S3(HTTP)``

![I_IMAGE](https://github.com/minio/cookbook/blob/master/docs/screenshots/mountainduck/defaultdashboard.jpg?raw=true)

### Replace the existing AWS S3 details with your local Minio credentials 

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

* [Minio Client complete guide](https://docs.minio.io/docs/minio-client-complete-guide)
* [Mountain Duck project homepage](https://mountainduck.io)

