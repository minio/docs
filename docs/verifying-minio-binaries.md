# Verifying MinIO Binaries [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

When using binaries from the Internet a best practice is to verify their integrity.  MinIO's download site, <https://dl.minio.io/>, provides PGP signature, SHA256 checksum, and SHA1 checksum files to help verify each release of MinIO Server and MinIO Client.

In this recipe we will learn how to confirm a binary came from MinIO and has not been modified.  Feel free to perform one or more of the verification steps listed below.

**NOTE:** Although the instructions will reference MinIO Server release [`minio.RELEASE.2017-11-22T19-55-46Z`](https://github.com/minio/minio/releases/tag/RELEASE.2017-11-22T19-55-46Z) ([Downloads](https://dl.minio.io/server/minio/release/), [Release Notes](https://github.com/minio/minio/releases)), the same general steps will apply to MinIO Client ([Downloads](https://dl.minio.io/client/mc/release/), [Release Notes](https://github.com/minio/mc/releases)).

## 1. Prerequisites

1. Navigate to the MinIO Server release directory for your platform.  For example:

* **Linux (64-bit):** <https://dl.minio.io/server/minio/release/linux-amd64/>
* **Windows (64-bit):** <https://dl.minio.io/server/minio/release/windows-amd64/>
* **macOS (64-bit):** <https://dl.minio.io/server/minio/release/darwin-amd64/>

2. Assuming you want the latest release of MinIO Server, and the latest release is `minio.RELEASE.2017-11-22T19-55-46Z`, download the following to a working directory:

* `minio.RELEASE.2017-11-22T19-55-46Z`: The binary compiled for your platform of choice.
* `minio.RELEASE.2017-11-22T19-55-46Z.asc`: The PGP signature for the binary.
* `minio.RELEASE.2017-11-22T19-55-46Z.sha256sum`: The SHA256 checksum of the binary.
* `minio.RELEASE.2017-11-22T19-55-46Z.shasum`: The SHA1 checksum of the binary.

3. Open a command prompt in your working directory.

## 2. Verify Using PGP Signature

**NOTE:** If you don't already have a process to verify PGP signatures, you might want to install [GnuPG](https://www.gnupg.org/) (GPG). Alternatively, Windows users might prefer using the version of GnuPG bundled in [Git for Windows](https://git-for-windows.github.io/).

### Linux, Windows, and macOS
```sh
# Import the public key used for MinIO releases
# User ID = MinIO Trusted <trusted@minio.io>
# Key ID = F9AAC728
# Key Fingerprint = 4405 F3F0 DDBA 1B9E 68A3  1D25 12C7 4390 F9AA C728
gpg --interactive --with-fingerprint --keyserver pgp.mit.edu --recv-keys 12C74390F9AAC728

# Verify the integrity of the file using the signature file associated with the binary
gpg --verify minio.RELEASE.2017-11-22T19-55-46Z.asc minio.RELEASE.2017-11-22T19-55-46Z
```

## 3. Verify Using SHA256 Checksum


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

## 4. Verify Using SHA1 Checksum

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

## 5. Prepare the Binary

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
