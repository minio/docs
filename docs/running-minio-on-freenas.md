# How to run Minio in FreeNAS [![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/minio/minio?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## Prerequisites

* You have FreeNAS installed and running, if not follow [install instructions](http://doc.freenas.org/9.10/freenas_install.html)
* You have a FreeNAS Jail path set, if not follow [jails configuration](http://doc.freenas.org/9.10/freenas_jails.html?highlight=jails#jails-configuration)

## Steps

### Create a new Jail
Browse to `Jails -> Add Jail` in the FreeNAS UI, click `Advanced` and enter the following settings:

```
Name:         Minio
Template:     --- (unset, defaults to FreeBSD)
VImage:       Unticked
```

Configure relevant network settings for your environment. Click `OK` and wait for Jail to download and install.

### Attach Storage
Browse to `Jails -> View Jails -> Storage`, click `Add Storage` and enter the following settings:

```
Jail:             Minio
Source:           </path/to/your/dataset>
Destination:      </path/to/your/dataset/inside/jail> (usually the same as 'Source' dataset for ease of use)
Read Only:        Unticked
Create Directory: Ticked
```

### Download Minio
Download Minio into the jail:

```
curl -Lo/<jail_root>/Minio/usr/local/bin/minio https://dl.minio.io/server/minio/release/freebsd-amd64/minio
chmod +x /<jail_root>/Minio/usr/local/bin/minio
```

### Create Minio Service
Create a new Minio service file:

```
touch /<jail_root>/Minio/usr/local/etc/rc.d/minio
chmod +x /<jail_root>/Minio/usr/local/etc/rc.d/minio
nano /<jail_root>/Minio/usr/local/etc/rc.d/minio
```

Add the following content:

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

### Configure Minio Startup
Edit `/<jail_root>/Minio/etc/rc.conf`:

```
nano /<jail_root>/Minio/etc/rc.conf
```

Add the following content:

```
minio_enable="YES"
minio_config="/etc/minio"
minio_disks="</path/to/your/dataset/inside/jail>"
minio_address="<listen address / port>" (Defaults to :443)
```

### Create Minio config directories

```
mkdir -p /<jail_root>/Minio/etc/minio/certs
```

### Create Minio Private and Public Keys (Optional, if HTTPS required and `minio_address` set on port 443)

```
nano /<jail_root>/Minio/etc/minio/certs/public.crt
nano /<jail_root>/Minio/etc/minio/certs/private.key
```

### Start Minio Jail
Browse to `Jails -> View Jails` in the FreeNAS UI, select `Minio` and press the `Start` button (3rd from Left):

### Test Minio
Browse to `http(s)://<ip_address>:<port>` and confirm Minio loads.


#### TODO: Convert this to a Plugin for ease of management
