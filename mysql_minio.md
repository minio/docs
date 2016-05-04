# How to back up your mysql database on Minio
## Prerequisites
* You have minio client library installed, if not follow mc [install instructions](https://github.com/minio/mc/blob/master/README.md)
* You have a Minio server configured and running, if not follow Minio [install instructions](https://github.com/minio/minio/blob/master/README.md)
* You have a directory which stores all the database backup, this will get backed up on Minio server.
* My scripts are executable
* ``which mc`` on terminal will give you path for ``mc``

## Steps
### Create a bucket:
```
$ mc mb local/mysqlbkp
Bucket created successfully ‘local/mysqlbkp’.
```
### Mirror local backup to Minio server:

```
$ mc mirror mysqlbkp/ local/mysqlbkp

```
### Automating it all:

**mirror script**
```
#!/bin/bash
#FileName: Miniomysqlbkp.sh & has executable permissions.

LocalBackupPath="/home/miniouser/mysqlbkp"
MinioBucket="local/mysqlbkp"
MCPATH="/home/miniouser/go/bin/mc"

$MCPATH --quiet mirror $LocalBackupPath $MinioBucket

```
**Setting it on crontab**

Open ``crontab`` & add the script in the end of the file. This script will take your mysql directory backup everyday at 15:00.

```
$ crontab -e

00 15 * * * /home/miniouser/scripts/Miniomysqlbkp.sh

```
