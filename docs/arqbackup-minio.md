# Arq backup with Minio [![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/minio/minio?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Arq backup software is available for Mac and Windows. Arq stores multiple versions of  files in encrypted format. The  backups can be stored on various cloud backends including Minio. This document will walk you through arqbackup configuration with Minio backend.   

## 1. Prerequisites

* [Arq](https://www.arqbackup.com/) backup installed.
* Minio Server is running on localhost on port 9000 in ``HTTP``, follow [Minio quickstart guide](https://docs.minio.io/docs/minio-quickstart-guide) for installing Minio.

## 2. Steps

From choose your backup destination tab select ``Other S3-Comptible service`` and provide Minio server configuration details.

![D_BUCKET](https://raw.githubusercontent.com/minio/cookbook/master/docs/screenshots/arqbackup.png?raw=true)

Next select an existing bucket for storing backup or let Arq create a storage backup and carry out operations as per need. Check official Arq docs for feature details.

## 3. Explore Further

* [Minio Client complete guide](https://docs.minio.io/docs/minio-client-complete-guide)
* [Arq backup homepage](https://www.arqbackup.com/)

