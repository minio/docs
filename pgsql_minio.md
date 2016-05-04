# Backing up your pgsql database on Minio
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
$ mc mb local/pgsqlbkp
Bucket created successfully ‘local/pgsqlbkp’.
```
### Mirror local backup to Minio server:

```
$ mc mirror pgsqlbkp/ local/pgsqlbkp

```
### Automating it all:

**mirror script**
```
#!/bin/bash
#FileName: Miniopgsqlbkp.sh & has executable permissions.

LocalBackupPath="/home/miniouser/pgsqlbkp"
MinioBucket="local/pgsqlbkp"
MCPATH="/home/miniouser/go/bin/mc"

$MCPATH --quiet mirror $LocalBackupPath $MinioBucket

```
**Setting it on crontab**

Open ``crontab`` & add the script in the end of the file. This script will take your pgsql directory backup everyday at 15:00.

```
$ crontab -e

00 15 * * * /home/miniouser/scripts/Miniopgsqlbkp.sh

```
