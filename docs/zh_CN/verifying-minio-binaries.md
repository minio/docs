# 验证MinIO二进制文件 [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

当从互联网上下载二进制文件时，最好的做法是先验证其完整性。 MinIO的下载站点<https://dl.min.io/>提供了PGP签名，SHA256校验和以及SHA1校验和文件，以帮助验证MinIO Server和MinIO Client的每个版本是否被篡改。

本文我们将学习如何验证MinIO的二进制文件是否被篡改。你可以使用以下一种或多种验证方式。

**注意：** 虽然本文将引用MinIO Server版本[`minio.RELEASE.2017-11-22T19-55-46Z`](https://github.com/minio/minio/releases/tag/RELEASE.2017-11-22T19-55-46Z) ([下载](https://dl.min.io/server/minio/release/), [版本说明](https://github.com/minio/minio/releases))，这些通用步骤同样适用于MinIO Client ([下载](https://dl.min.io/client/mc/release/), [版本说明](https://github.com/minio/mc/releases)).

## 1. 前提条件

1. 进入MinIO Server的版本目录，比如：

* **Linux (64-bit):** <https://dl.min.io/server/minio/release/linux-amd64/>
* **Windows (64-bit):** <https://dl.min.io/server/minio/release/windows-amd64/>
* **macOS (64-bit):** <https://dl.min.io/server/minio/release/darwin-amd64/>

2. 假设你设使用的版本是`minio.RELEASE.2017-11-22T19-55-46Z`，下载文件到你的工作目录：

* `minio.RELEASE.2017-11-22T19-55-46Z`: 你选择的操作系统对应的二进制文件。
* `minio.RELEASE.2017-11-22T19-55-46Z.asc`: 针对该二进制文件的PGP签名。
* `minio.RELEASE.2017-11-22T19-55-46Z.sha256sum`: 该二进制文件的SHA256校验和。
* `minio.RELEASE.2017-11-22T19-55-46Z.shasum`: 该二进制文件的SHA1校验和。

3. 在你的工作目录中打开命令行。

## 2. 使用PGP签名进行验证

**注意：** 如果你没有软件可验证PGP签名，你可以安装[GnuPG](https://www.gnupg.org/) (GPG)。Windows用户可能更喜欢使用[Git for Windows](https://git-for-windows.github.io/)中自动的GnuPG。

### Linux, Windows, and macOS
```sh
# Import the public key used for MinIO releases
# User ID = MinIO Trusted <trusted@min.io>
# Key ID = F9AAC728
# Key Fingerprint = 4405 F3F0 DDBA 1B9E 68A3  1D25 12C7 4390 F9AA C728
gpg --interactive --with-fingerprint --keyserver pgp.mit.edu --recv-keys 12C74390F9AAC728

# Verify the integrity of the file using the signature file associated with the binary
gpg --verify minio.RELEASE.2017-11-22T19-55-46Z.asc minio.RELEASE.2017-11-22T19-55-46Z
```

## 3. 使用SHA256校验和进行验证


### Linux and macOS
```sh
# Inserting the missing "*" character indicating binary mode should be used
cat minio.RELEASE.2017-11-22T19-55-46Z.sha256sum | sed 's/ / */' | shasum -a 256 -c -

# Alternatively (if available): sha256sum -c minio.RELEASE.2017-11-22T19-55-46Z.sha256sum
```

### Windows
```ps
# Check the hash with PowerShell 4.0+
(Get-FileHash -Algorithm SHA256 'minio.RELEASE.2017-11-22T19-55-46Z').Hash -eq ((Get-Content 'minio.RELEASE.2017-11-22T19-55-46Z.sha256sum') -split ' ')[0]

# Alternatively, "Git for Windows" users may run the Linux commands in a Git BASH shell
```

## 4. 使用SHA1校验和进行验证

### Linux and macOS
```sh
# Inserting the missing "*" character indicating binary mode should be used
cat minio.RELEASE.2017-11-22T19-55-46Z.shasum | sed 's/ / */' | shasum -a 1 -c -

# Alternatively (if available): sha1sum -c minio.RELEASE.2017-11-22T19-55-46Z.shasum
```

### Windows
```ps
# Check the hash with PowerShell 4.0+
(Get-FileHash -Algorithm SHA1 'minio.RELEASE.2017-11-22T19-55-46Z').Hash -eq ((Get-Content 'minio.RELEASE.2017-11-22T19-55-46Z.shasum') -split ' ')[0]

# Alternatively, "Git for Windows" users may run the Linux commands in a Git BASH shell
```

## 5. 准备二进制文件

### Linux and macOS
```sh
# Rename
mv minio.RELEASE.2017-11-22T19-55-46Z minio

# Make executable
chmod +x minio
```


### Windows
```ps
# Rename with PowerShell...
Rename-Item 'minio.RELEASE.2017-11-22T19-55-46Z' 'minio.exe'
```
