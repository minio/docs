# restic with Minio Server [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

`restic` is an open source backup tool that is fast, efficient, and secure. `restic` is available under the [BSD 2-Clause License](https://opensource.org/licenses/BSD-2-Clause).

This guide describes how to use `restic` to backup data onto the Minio server.

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

Store the URL, access key, and secret key displayed by Minio Server, as well as the Restic password, in the respective environment variables:

```sh
export RESTIC_REPOSITORY="s3:http://localhost:9000/restic"
export AWS_ACCESS_KEY_ID=<ACCESS-KEY-ID>
export AWS_SECRET_ACCESS_KEY=<SECRET-ACCESS-KEY>
export RESTIC_PASSWORD=<RESTIC-PASSWORD>
```

## <a name="startrestic"></a>4. Start Restic

Start `restic`:

```sh
restic init
```
## <a name="performbackup"></a>5. Perform a Backup
Use `restic` to create a backup copy of a directory from the local machine to a bucket on Minio Server:

```sh
restic backup ~/.Data
```

A response similar to this one should be displayed:

```
repository 6a963c49 opened successfully, password is correct
created new cache in /Users/<user name>/Library/Caches/restic

Files:           3 new,     0 changed,     0 unmodified
Dirs:            0 new,     0 changed,     0 unmodified
Added to the repo: 54.655 KiB

processed 3 files, 54.289 KiB in 0:00
snapshot d046a656 saved
```

## Verify the Backup
Use `mc` to verify that the contents were backed up:

```sh
mc ls minio/restic
```
A response similar to this one should be displayed:

```
[2018-11-15 09:25:28 PST]   155B config
[2018-11-15 09:26:46 PST]     0B data/
[2018-11-15 09:26:46 PST]     0B index/
[2018-11-15 09:26:46 PST]     0B keys/
[2018-11-15 09:26:46 PST]     0B snapshots/
```

