# restic with Minio Server [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

`restic` is an open source backup tool that is fast, efficient, and secure. `restic` is available under the [BSD 2-Clause License](https://opensource.org/licenses/BSD-2-Clause).

This guide describes how to use `restic` to backup your data onto Minio Server. These are the steps you will follow:

1. [Install Minio Server](#installserver) 
2. [Install `restic`](#installrestic) 
3. [Prepare the Environment for `restic`](#prepenv) 
4. [Start Restic](#startrestic) 
5. [Perform a Backup](#performbackup)

## <a name="installserver"></a>1. Install Minio Server

Install Minio Server using the instructions in the [Minio Quickstart Guide](http://docs.minio.io/docs/minio-quickstart-guide).

## <a name="installrestic"></a>2. Install `restic`

Install `restic` using these instructions: [https://restic.github.io](https://restic.github.io).

## <a name="prepenv"></a>3. Prepare the Environment for `restic`

Store the access key and secret displayed by Minio Server in the respective environment variables:

```sh
export AWS_ACCESS_KEY_ID=<YOUR-ACCESS-KEY-ID>
export AWS_SECRET_ACCESS_KEY=<YOUR-SECRET-ACCESS-KEY>
```

## <a name="startrestic"></a>4. Start Restic

As you start `restic`, specify the bucket where the backup data will reside:

```sh
./restic -r s3:http://localhost:9000/resticbucket init
```

**Note:** When prompted, enter a password to assign to the repository.

## <a name="performbackup"></a>5. Perform a Backup
Use `restic` to create a backup copy of a directory on your local machine to a bucket on Minio Server:

```sh
./restic -r s3:http://localhost:9000/resticbucket backup /home/minio/workdir/Docs/
```

You should see a response similar to this one:

```sh
enter password for repository:
scan [/home/minio/workdir/Docs]
scanned 2 directories, 6 files in 0:00
[0:00] 100.00%  0B/s  8.045 KiB / 8.045 KiB  6 / 8 items  0 errors  ETA 0:00
duration: 0:00, 0.06MiB/s
snapshot 85a9731a saved
```

**Note:** When prompted for a password, enter the password for the repository that you assigned in step 4.
