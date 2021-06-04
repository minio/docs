# JuiceFS with MinIO Server [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

`JuiceFS` is a fast, efficient and secure cloud sharing file system, open source and distributed under the AGPLv3 license. It uses object storage as the storage backend, and uses Redis, MySQL, SQLite and other databases to store metadata. It can connect cloud storage to the existing system and use it like a local disk.

JuiceFS is widely used in big data, artificial intelligence, machine learning and other platforms, and is very suitable for use in combination with MinIO.

In this article, we will learn how to configure MinIO Server as the storage backend of JuiceFS, and finally use Minio Server to store data like a local disk.

## 1. Prerequisites

Before starting, please refer to [MinIO Quickstart Guide](https://docs.min.io/docs/minio-quickstart-guide) to install MinIO Server.

## 2. Installation

Refer to [JuiceFS Quick Start Guide](https://github.com/juicedata/juicefs/blob/main/docs/en/quick_start_guide.md) to install `JuiceFS`.

## 3. Usage

JuiceFS is very simple to use. First, create a JuiceFS storage, then you can mount and use it.

JuiceFS storage consists of two parts: `object storage` and `database`. As a file system with `data sharing` capability, JuiceFS storage can be mounted by thousands of servers at the same time. But it should be noted that if you want to mount the same JuiceFS storage on multiple servers, you must ensure that the `object storage` and `database` services used when creating the JuiceFS storage can be accessed by all servers.

JuiceFS supports all S3-compatible object storage services. Keep it simple, here we use the test server officially provided by MinIO:

 - MinIO Server: <https://play.min.io:9000>
 - Access Key: `Q3AM3UQ867SPQQA43P2F`
 - Secret Key: `zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG`

> Note: The above test server is public, anyone can read and write access, only for test purposes. For actual deployment, please use your own server address and secret key.

The database is specially used to store the metadata corresponding to the data. Currently, the available databases are Redis, MySQL/MariaDB, and SQLite. Since SQLite is a single-file database, it cannot be read by other hosts without special sharing settings. If you want to create a JuiceFS storage that can be mounted by multiple servers at the same time, it is recommended to use Redis or MySQL/MariaDB database.

Keep it simple, here we use SQLite database. If you want to know how to configure other databases, you can [check this document](https://github.com/juicedata/juicefs/blob/main/docs/en/databases_for_metadata.md).


### Create a JuiceFS storage

Executing the following command will use MiniO's official test server to create a JuiceFS storage named `hi-jfs`. When used, the data will be stored in the `hi-jfs` bucket, and the metadata corresponding to the data will be stored in the `hi-jfs.db` database under the current directory.

```sh
$ juicefs format \
	--storage minio \
	--bucket https://play.min.io:9000/hi-jfs \
	--access-key Q3AM3UQ867SPQQA43P2F \
	--secret-key zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG \
    sqlite3://hi-jfs.db \
    hi-jfs
```

After the command is executed, the output similar to the following, indicating that the JuiceFS storage was created successfully.

```sh
2021/06/04 22:58:41.576410 juicefs[37352] <INFO>: Meta address: sqlite3://hi-jfs.db
[xorm] [info]  2021/06/04 22:58:41.579868 PING DATABASE sqlite3
2021/06/04 22:58:41.590066 juicefs[37352] <WARNING>: The latency to database is too high: 11.681432ms
2021/06/04 22:58:41.592698 juicefs[37352] <INFO>: Data uses play.min.io:9000/hi-jfs/
2021/06/04 22:58:43.946219 juicefs[37352] <INFO>: Volume is formatted as {Name:hi-jfs UUID:81dcbd11-401a-46d5-9265-da1afbe57366 Storage:minio Bucket:https://play.min.io:9000/hi-jfs AccessKey:Q3AM3UQ867SPQQA43P2F SecretKey:removed BlockSize:4096 Compression:none Shards:0 Partitions:0 EncryptKey:}
```

### Mount and use JuiceFS storage

Execute the following command to mount the `hi-jfs` storage to the `jfs` directory under the current directory:

```sh
$ sudo juicefs mount sqlite3://hi-jfs.db ./jfs
```

> Tip: You can add the `-d` parameter to let JuiceFS storage mount and run in the background.

After the command is executed, you will see an output similar to the following, which means that the JuiceFS storage is successfully mounted.

```sh
2021/06/04 23:02:39.689628 juicefs[37431] <INFO>: Meta address: sqlite3://hi-jfs.db
[xorm] [info]  2021/06/04 23:02:39.693130 PING DATABASE sqlite3
2021/06/04 23:02:39.711075 juicefs[37431] <WARNING>: The latency to database is too high: 19.26057ms
2021/06/04 23:02:39.714632 juicefs[37431] <INFO>: Data use play.min.io:9000/hi-jfs/
2021/06/04 23:02:39.716535 juicefs[37431] <INFO>: Cache dirs: /Users/herald/.juicefs/cache/81dcbd11-401a-46d5-9265-da1afbe57366, capacity: 1024 MB
2021/06/04 23:02:39.717732 juicefs[37431] <INFO>: Created new cache store (/Users/herald/.juicefs/cache/81dcbd11-401a-46d5-9265-da1afbe57366/): capacity (1024 MB), free ratio (10%), max pending pages (15)
2021/06/04 23:02:39.729152 juicefs[37431] <INFO>: Mounting volume hi-jfs at jfs ...
```

Now you can store files in the `./jfs` directory just like using a local disk. All stored files will be split into data blocks according to specific rules and stored in MinIO Server. The related metadata information will be stored in the SQLite database.

### Unmount JuiceFS storage

If you did not use the `-d` parameter when mounting a JuiceFS storage, you can use the keyboard combination <kbd>ctrl</kbd> + <kbd>c</kbd> to end the process.

Otherwise, you can use the subcommand `umount` to unmount a storage:

```sh
$ sudo juicefs umount ./jfs
```