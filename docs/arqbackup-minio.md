# Arq backup with MinIO [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

Arq backup software is available for Mac and Windows. Arq stores multiple versions of files in encrypted format. The  backups can be stored on various cloud backends including MinIO. This document will walk you through arqbackup configuration with MinIO backend.

## 1. Prerequisites

* [Arq](https://www.arqbackup.com/) backup installed.
* MinIO Server is running on localhost:9000, follow [MinIO quickstart guide](https://docs.minio.io/docs/minio-quickstart-guide) for installing MinIO.

## 2. Steps

Click to Arq backup icon and from the choose your backup destination tab select ``Other S3-Comptible service`` and provide MinIO server configuration details.

![D_BUCKET](https://raw.githubusercontent.com/minio/cookbook/master/docs/screenshots/arqbackup.png?raw=true)

Next select an existing bucket for storing backup or create a new bucket for Arq backup.

## 3. Explore Further

* [MinIO Client complete guide](https://docs.minio.io/docs/minio-client-complete-guide)
* [Arq backup homepage](https://www.arqbackup.com/)

