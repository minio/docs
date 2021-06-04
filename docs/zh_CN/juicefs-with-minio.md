# JuiceFS 使用 MinIO 存储 [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

`JuiceFS` 是一个快速、高效、安全的云端共享文件系统，在 AGPLv3 协议下开源。它采用对象存储作为存储后端，采用 Redis、MySQL、SQLite 等数据库存储元数据，可将海量云存储接入现有系统，像本地磁盘一样使用。

JuiceFS 广泛应用于大数据、人工智能、机器学习等平台，非常适合与 MinIO 组合在一起使用。

在本文中，我们将学习如何将 MinIO Server 配置成为 JuiceFS 的存储后端，最终可以像使用本地磁盘一样使用 Minio Server 存储数据。

## 1. 前提条件

在开始之前，请先参照 [MinIO Quickstart Guide](https://docs.min.io/docs/minio-quickstart-guide) 安装好 MinIO Server。

## 2. 安装

参照 [JuiceFS Quick Start Guide](https://github.com/juicedata/juicefs/blob/main/docs/en/quick_start_guide.md) 安装 `JuiceFS`。

## 3. 使用

JuiceFS 的使用非常简单，首先创建 JuiceFS 存储，然后即可挂载和使用。

JuiceFS 存储由 `对象存储` 和 `数据库` 两部分组成。作为一个拥有 `数据共享` 能力的文件系统，JuiceFS 存储可以被上千台服务器同时挂载读写。但需要注意的是，如果你想在多台服务器上挂载同一个 JuiceFS 存储，必须确保创建 JuiceFS 存储时使用的 `对象存储` 和 `数据库` 服务都能被所有服务器正常访问。

JuiceFS 支持所有 S3 兼容的对象存储服务，为了便于演示，这里我们使用 MinIO 官方提供的测试服务器：

 - MinIO Server: <https://play.min.io:9000>
 - Access Key: `Q3AM3UQ867SPQQA43P2F`
 - Secret Key: `zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG`

> 注意：上述测试服务器是公开的，任何人都可以读写访问，仅用测试目的。实际部署时，请使用你自己的服务器地址和秘钥。

数据库专门用来存储数据所对应的元数据，目前可以使用的数据库有 Redis、MySQL/MariaDB、SQLite。由于 SQLite 是单文件数据库，在不做特殊共享设置的情况下，无法被其他主机读取，如果你要创建可以被多台服务器同时挂载的 JuiceFS 存储，建议使用 Redis 或 MySQL/MariaDB 数据库。

为了便于演示，这里我们使用最简单的 SQLite 数据库。如果你想了解其他数据库的配置方法可以 [查看这篇文档](https://github.com/juicedata/juicefs/blob/main/docs/en/databases_for_metadata.md)。


### 创建 JuiceFS 存储

执行以下命令，会使用 MiniO 的官方测试服务器，创建一个名为 `hi-jfs` 的 JuiceFS 存储。使用时，数据会被存入 `hi-jfs` 存储桶，数据对应的元数据会被存入当前目录下的 `hi-jfs.db` 数据库中。

```sh
$ juicefs format \
	--storage minio \
	--bucket https://play.min.io:9000/hi-jfs \
	--access-key Q3AM3UQ867SPQQA43P2F \
	--secret-key zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG \
    sqlite3://hi-jfs.db \
    hi-jfs
```

命令执行以后，看到类似下方的输出，代表 JuiceFS 存储创建成功。

```sh
2021/06/04 22:58:41.576410 juicefs[37352] <INFO>: Meta address: sqlite3://hi-jfs.db
[xorm] [info]  2021/06/04 22:58:41.579868 PING DATABASE sqlite3
2021/06/04 22:58:41.590066 juicefs[37352] <WARNING>: The latency to database is too high: 11.681432ms
2021/06/04 22:58:41.592698 juicefs[37352] <INFO>: Data uses play.min.io:9000/hi-jfs/
2021/06/04 22:58:43.946219 juicefs[37352] <INFO>: Volume is formatted as {Name:hi-jfs UUID:81dcbd11-401a-46d5-9265-da1afbe57366 Storage:minio Bucket:https://play.min.io:9000/hi-jfs AccessKey:Q3AM3UQ867SPQQA43P2F SecretKey:removed BlockSize:4096 Compression:none Shards:0 Partitions:0 EncryptKey:}
```

### 挂载和使用 JuiceFS 存储

执行以下命令，会将刚刚创建的 `hi-jfs` 存储，挂载到当前目录下的 `jfs` 目录：

```sh
$ sudo juicefs mount sqlite3://hi-jfs.db ./jfs
```

> 提示：可以添加 `-d` 参数，让 JuiceFS 存储在后台挂载运行。

命令执行以后，看到类似下方的输出，代表 JuiceFS 存储挂载成功。

```sh
2021/06/04 23:02:39.689628 juicefs[37431] <INFO>: Meta address: sqlite3://hi-jfs.db
[xorm] [info]  2021/06/04 23:02:39.693130 PING DATABASE sqlite3
2021/06/04 23:02:39.711075 juicefs[37431] <WARNING>: The latency to database is too high: 19.26057ms
2021/06/04 23:02:39.714632 juicefs[37431] <INFO>: Data use play.min.io:9000/hi-jfs/
2021/06/04 23:02:39.716535 juicefs[37431] <INFO>: Cache dirs: /Users/herald/.juicefs/cache/81dcbd11-401a-46d5-9265-da1afbe57366, capacity: 1024 MB
2021/06/04 23:02:39.717732 juicefs[37431] <INFO>: Created new cache store (/Users/herald/.juicefs/cache/81dcbd11-401a-46d5-9265-da1afbe57366/): capacity (1024 MB), free ratio (10%), max pending pages (15)
2021/06/04 23:02:39.729152 juicefs[37431] <INFO>: Mounting volume hi-jfs at jfs ...
```

现在就可以像使用本地磁盘一样，在 `./jfs` 目录中存储文件了，所有存入的文件都会按照特定的规则被拆分成数据块，存储在 MinIO Server 中。而相关的元数据信息则会被存入 sqlite 数据库中。

### 卸载 JuiceFS 存储

如果你在挂载 JuiceFS 存储时没有使用 `-d` 参数，那么可以直接使用键盘组合键  <kbd>ctrl</kbd> + <kbd>c</kbd> 结束进程。

如果你使用 `-d` 参数在守护进程中挂载的 JuiceFS 存储，那么可以使用 `unmount` 子命令卸载存储：

```sh
$ sudo juicefs umount ./jfs
```
