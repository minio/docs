# Arq backup with Minio [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io) 

Arq backup software is available for Mac and Windows. Arq stores multiple versions of files in encrypted format. The  backups can be stored on various cloud backends including Minio. This document will walk you through arqbackup configuration with Minio backend.   

## 1. Prerequisites

* [Arq](https://www.arqbackup.com/) backup installed.
* Minio Server is running on localhost:9000, follow [Minio quickstart guide](https://docs.minio.io/docs/minio-quickstart-guide) for installing Minio.

## 2. Steps

Click to Arq backup icon and from the choose your backup destination tab select ``Other S3-Comptible service`` and provide Minio server configuration details.

![D_BUCKET](https://raw.githubusercontent.com/minio/cookbook/master/docs/screenshots/arqbackup.png?raw=true)

Next select an existing bucket for storing backup or create a new bucket for Arq backup. 

## 3. Explore Further

* [Minio Client complete guide](https://docs.minio.io/docs/minio-client-complete-guide)
* [Arq backup homepage](https://www.arqbackup.com/)

