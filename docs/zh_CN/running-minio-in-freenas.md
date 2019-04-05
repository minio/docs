# 如何在FreeNAS中运行MinIO [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

在本文中，我们将学习如何使用FreeNAS运行MinIO。 

## 1. 前提条件

* FreeNAS已经安装并运行,如果没有，请参考[安装说明](http://doc.freenas.org/9.10/install.html)
* 你有一个FreeNAS Jail path set，如果没有，请参考[jails configuration](http://doc.freenas.org/9.10/jails.html#jails-configuration)

## 2. 安装步骤

### 创建一个新的Jail
在FreeNAS UI中找到`Jails -> Add Jail`，点击 `Advanced`，然后输入如下信息:

```
Name:         MinIO
Template:     --- (unset, defaults to FreeBSD)
VImage:       Unticked
```

为你的环境配置相关的网络设置。点击`OK`，等待Jail下载并安装。

### 添加存储
找到`Jails -> View Jails -> Storage`，点击`Add Storage`，然后输入如下信息：

```
Jail:             MinIO
Source:           </path/to/your/dataset>
Destination:      </path/to/your/dataset/inside/jail> (usually the same as 'Source' dataset for ease of use)
Read Only:        Unticked
Create Directory: Ticked
```

### 下载MinIO
下载MinIO到jail:

```
curl -Lo/<jail_root>/MinIO/usr/local/bin/minio https://dl.min.io/server/minio/release/freebsd-amd64/minio
chmod +x /<jail_root>/MinIO/usr/local/bin/minio
```

### 创建MinIO服务
创建一个MinIO服务的文件:

```
touch /<jail_root>/MinIO/usr/local/etc/rc.d/minio
chmod +x /<jail_root>/MinIO/usr/local/etc/rc.d/minio
nano /<jail_root>/MinIO/usr/local/etc/rc.d/minio
```

添加下面的内容:

```
#!/bin/sh

# PROVIDE: minio
# KEYWORD: shutdown

# Define these minio_* variables in one of these files:
#       /etc/rc.conf
#       /etc/rc.conf.local
#       /etc/rc.conf.d/minio
#
# DO NOT CHANGE THESE DEFAULT VALUES HERE
#

# Add the following lines to /etc/rc.conf to enable minio:
#
#minio_enable="YES"
#minio_config="/etc/minio"


minio_enable="${minio_enable-NO}"
minio_config="${minio_config-/etc/minio}"
minio_disks="${minio_disks}"
minio_address="${minio_address-:443}"

. /etc/rc.subr

load_rc_config ${name}

name=minio
rcvar=minio_enable

pidfile="/var/run/${name}.pid"

command="/usr/sbin/daemon"
command_args="-c -f -p ${pidfile} /usr/local/bin/${name} -C \"${minio_config}\" server --address=\"${minio_address}\" ${minio_disks}"

run_rc_command "$1"
```

### 配置MinIO启动
编辑`/<jail_root>/MinIO/etc/rc.conf`:

```
nano /<jail_root>/MinIO/etc/rc.conf
```

添加如下内容:

```
minio_enable="YES"
minio_config="/etc/minio"
minio_disks="</path/to/your/dataset/inside/jail>"
minio_address="<listen address / port>" (Defaults to :443)
```

### 创建MinIO配置目录

```
mkdir -p /<jail_root>/MinIO/etc/minio/certs
```

### 创建MinIO Private key和Public Key (可选,如果需要HTTPS并且`minio_address`设置成443端口)

```
nano /<jail_root>/MinIO/etc/minio/certs/public.crt
nano /<jail_root>/MinIO/etc/minio/certs/private.key
```

### 启动MinIO Jail
在FreeNAS UI中找到找到`Jails -> View Jails` ，选择 `MinIO`，然后点击`Start`按钮 (从左边开始第三个):

### 测试MinIO
找到`http(s)://<ip_address>:<port>`并确认MinIO加载。



