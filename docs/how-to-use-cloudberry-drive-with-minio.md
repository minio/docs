# How to use CloudBerry Drive with Minio [![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/Cloudberry-lab/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

In this short article you will learn how to mount your Minio object storage as disk in Windows Operating system. This is useful to share files between people.

## 1. Prerequisites

* [CloudBerry Drive](http://www.cloudberrylab.com/drive/) is installed and running.

* Minio Server is running on localhost on port 9000 in ``HTTP``, follow [Minio quickstart guide](https://docs.minio.io/docs/minio-quickstart-guide) to install Minio.

_NOTE:_ You can also run Minio in ``HTTPS``, follow this [guide](https://docs.minio.io/docs/generate-let-s-encypt-certificate-using-concert-for-minio) along with CloudBerry Drive.

## 2. Steps

### Add Minio as storage account in CloudBerry Drive

Once CloudBerry Drive installed you can fine out its icon with configuration settings in your tray (right bottom corner, near clock). Fill up the fields accordingly (service point - your server IP with 8000 / 9000 port depends your signature version, access and secret keys can be obtain from running server console). You can activate SSL, but your server should be configured accordingly. Multipart upload allows to split files into multiple chunks and upload them in multiple threads. It is enabled by default.

  ![CloudBerry Drive for S3 compatible](https://raw.githubusercontent.com/minio/cookbook/master/docs/screenshots/cloudberrylab/cloudberry-drive-storage-minio-configuration.jpg?raw=true)

### Add drive

Now, when you have storage account set you can start making drives and map them to your Windows computer (even more you can set it as network share and making available across your corporate network). Pickup your settings accordingly and hit ok to enable drive.

  ![CloudBerry Drive options for mapped drive] (https://raw.githubusercontent.com/minio/cookbook/master/docs/screenshots/cloudberrylab/cloudberry-drive-mapped-drive-settings.jpg?raw=true)


### Check your mapped drive and start manage your files

View your drive and start manage files.

  ![CloudBerry Drive for Minio, view content](https://raw.githubusercontent.com/minio/cookbook/master/docs/screenshots/cloudberrylab/cloudberry-drive-mapped-disk-show-content.jpg?raw=true)

## 3. Explore Further

* [Minio Client complete guide](https://docs.minio.io/docs/minio-client-complete-guide)
* [CloudBerry Explorer for Minio](http://www.cloudberrylab.com/explorer)
