# How to back up MongoDB database on Minio
## Prerequisites
* You have minio client library installed, if not follow mc [install instructions](https://github.com/minio/mc/blob/master/README.md)
* You have a Minio server configured and running, if not follow Minio [install instructions](https://github.com/minio/minio/blob/master/README.md)
* You have a directory which stores all the database backup, this will get backed up on Minio server.
* My current working directory is ``/home/miniouser`` & scripts are part of the ``bash PATH``
* My scripts are executable
* ``which mc`` on terminal will give you path for ``mc``

## Steps
### Create a bucket:
```
$ mc mb local/mongobkp
Bucket created successfully ‘local/mongobkp’.
```
### Mirror local backup to Minio server:

```
$ mc mirror mongobkp/ local/mongobkp

```
### Automating it all:

**mirror script**
```
#!/bin/bash
#FileName: Minimongobkp.sh & has executable permissions.

LocalBackupPath="/home/miniouser/mongobkp"
MinioBucket="local/mongobkp"
MCPATH="/home/miniouser/go/bin/mc"

$MCPATH --quiet mirror $LocalBackupPath $MinioBucket

```
**Setting it on crontab**

Open ``crontab`` & add the script in the end of the file. This script will take your mongoDB directory backup everyday at 15:00.

```
$ crontab -e

00 15 * * * /home/miniouser/scripts/Miniomongobkp.sh

```
