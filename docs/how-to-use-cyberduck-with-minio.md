# How to use Cyberduck with Minio [![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/minio/minio?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)


In this document you will learn how to carry out basic operations on Minio using Cyberduck. Cyberduck is an open source client for FTP and SFTP, WebDAV, OpenStack Swift, and Amazon S3, available for Mac OS X and Windows (as of version 4.0) licensed under the GPL. 

##Prerequisites
* Cyberduck is installed and running. If not please download Cyberduck from [here](https://cyberduck.io/). Since Minio is Amazon S3 API compaitble you will need to download [Generic S3 Profiles](https://trac.cyberduck.io/wiki/help/en/howto/s3#HTTP). We are downloading ``HTTP`` profile for this setup.

* Minio Server is running on localhost on port 9000 in ``HTTP``. 

_NOTE:_ You can also run Minio in ``HTTPS``, follow this [guide](https://docs.minio.io/docs/generate-let-s-encypt-certificate-using-concert-for-minio) along with Cyberduck HTTPS [Generic S3 Profiles](https://trac.cyberduck.io/wiki/help/en/howto/s3#HTTPS) 

###1. Add Minio authentication in cyberduck

Click open connection, select ``HTTP``

![I_IMAGE](https://github.com/minio/cookbook/blob/master/docs/screenshots/cyberduck/defaultdashboard.jpg?raw=true)


###2. Replace the existing ``AWS S3`` details with your local ``Minio`` credntials to:


![MINIO_DASH](https://github.com/minio/cookbook/blob/master/docs/screenshots/cyberduck/connecttominio.jpg?raw=true)

###3. Click on the ``connect`` tab to establish connection.
Once the connection is established you can explore operations listed below.

##### List Bucket

![B_LISTING](https://github.com/minio/cookbook/blob/master/docs/screenshots/cyberduck/allbuckets.jpg?raw=true)

##### Upload Object

![U_OBJECT](https://github.com/minio/cookbook/blob/master/docs/screenshots/cyberduck/uploadobject.jpg?raw=true)

##### Download Object

![D_OBJECT](https://github.com/minio/cookbook/blob/master/docs/screenshots/cyberduck/downloadobject.jpg?raw=true)

##### Delete Object

![D_OBJECT](https://github.com/minio/cookbook/blob/master/docs/screenshots/cyberduck/deleteobject.jpg?raw=true)

##### Download bucket

![D_BUCKET](https://github.com/minio/cookbook/blob/master/docs/screenshots/cyberduck/downloadbucket.jpg?raw=true)

##### Mirror Bucket

![M_BUCKET](https://github.com/minio/cookbook/blob/master/docs/screenshots/cyberduck/mirror.jpg?raw=true)

##### Delete Bucket

![D_BUCKET](https://github.com/minio/cookbook/blob/master/docs/screenshots/cyberduck/deletebucket.jpg?raw=true)

###3. Explore Further
* [Minio Client complete guide](https://docs.minio.io/docs/minio-client-complete-guide)
* [Cyberduck project homepage](https://cyberduck.io)


