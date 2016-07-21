# Store MongoDB Backups in Minio Server [![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/minio/minio?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

In this recipe we will learn how to store MongoDB backups in Minio Server.


## 1. Prerequisites

* Install mc from [here](https://docs.minio.io/docs/minio-client-quick-start-guide).
* Install Minio Server from [here](https://docs.minio.io/docs/minio ).
* Know where the MongoDB backups reside in the local filesystem.
 

## 2. Recipe Steps

In this recipe, we will use https://play.minio.io:9000 which is aliased to play. Feel free to use play server for testing and development. Access credentials shown in this example are open to public. 
Replace with your own access credentials when running this example in your environment.

### Step 1: Create a bucket.

```sh

$ mc mb play/mongobkp
Bucket created successfully ‘play/mongobkp’.

```

### Step 2: Mirror local backup to Minio server.

```sh

$ mc mirror mongobkp/ play/mongobkp


```

## 3. Automate

The above recipe can be automated easily. Change the bash script below to your own directories and PATHS as needed. Set up a cron to run this task as needed.

```sh

#!/bin/bash
#FileName: Minimongobkp.sh & has executable permissions.

LocalBackupPath="/home/miniouser/mongobkp"
MinioBucket="play/mongobkp"
MCPATH="/home/miniouser/go/bin/mc"

$MCPATH - -quiet mirror $LocalBackupPath $MinioBucket

```
