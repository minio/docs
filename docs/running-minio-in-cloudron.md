# How to run Minio in Cloudron [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

[Cloudron](https://cloudron.io) is a platform that makes it easy to run and maintain web apps on your server.

In this recipe, we will learn how to run Minio in Cloudron.

## 1. Prerequisites

* You have Cloudron installed and running, if not follow [install instructions](https://cloudron.io/get.html#selfhost).
* If you don't have a Cloudron, you can play with the [demo instance](https://my-demo.cloudron.me). The username and
  password for the demo instance is `cloudron`.

## 2. Installation Steps

### Install from Cloudron App Store

Go to the Cloudron App Store page and search for 'Minio'.

  ![Minio in Cloudron App Store](screenshots/cloudron/appstore.png?raw=true "Search for Minio on Cloudron App Store")


### Install Minio

The install dialog lets you enter any subdomain on which you want Minio installed. Here we choose the subdomain `s3`.

  ![Install Cloudron](screenshots/cloudron/install.png?raw=true "Install Minio on any subdomain")

### Accessing minio

Click the Minio app icon in the installed apps list to access Minio.

  ![Minio is installed on Cloudron](screenshots/cloudron/installed.png?raw=true "Minio is installed and running")

### Minio running with Lets Encrypt

Notice how minio is already setup with Lets Encrypt Certificate. You can access Minio with Access Key `admin` and
Secret Key `secretkey`.

  ![Minio running on Cloudron](screenshots/cloudron/running.png?raw=true "Minio is live with Lets Encrypt")

