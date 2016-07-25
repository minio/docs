# How to run Minio in Docker? [![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/minio/minio?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## Prerequisites

* You have Docker installed and running, if not follow [install instructions](https://docs.docker.com/engine/installation/ubuntulinux/)
* You have minio client aka mc installed, if not follow [install instructions](https://docs.minio.io/docs/minio-client-quickstart-guide)

## Steps

### Add a local alias for docker (optional)

I am adding an [``alias``](http://tldp.org/LDP/abs/html/aliases.html) to my local ``bashrc`` file to avoid typing ``sudo`` along with running docker command.

```sh

alias docker="sudo /usr/bin/docker"

```

### Fetching Minio image from repository & running Minio in docker.

```sh

$ docker run -p 9000:9000 minio/minio:latest

AccessKey: IQP18YBF51DG8HSZEE7B  SecretKey: AlDzw6dj9zfne8JhPwGapt0Idlfg/QLhMq58Z0ax

Starting minio server:
Listening on http://127.0.0.1:9000
Listening on http://172.17.0.3:9000

```

### Add Minio configuration to mc

```sh

$ mc config host add localhost http://localhost:9000 IQP18YBF51DG8HSZEE7B AlDzw6dj9zfne8JhPwGapt0Idlfg/QLhMq58Z0ax

```

### Play with Minio server

```sh

$ mc mb localhost/newbucket
Bucket created successfully ‘localhost/newbucket’.
$ mc mb localhost/mybucket
Bucket created successfully ‘localhost/mybucket’.

```

### Persist Minio configs

Running Minio container

```sh

$ docker ps
CONTAINER ID        IMAGE                COMMAND                CREATED             STATUS              PORTS                    NAMES
51e3a48d209a        minio/minio:latest   "/minio server /expo   22 hours ago        Up 22 hours         0.0.0.0:9000->9000/tcp   fervent_shockley

```

```sh

$ docker commit 51e3a48d209a minio/my-minio
fcc98afd0b4da9340b3e635d73a82088e7224798b3467138840b997959af4520

$ docker stop 51e3a48d209a
51e3a48d209a

```

> NOTE: Replace the container id with
>your own.

#### Create a data volume container

```sh

$ docker create -v /export --name minio-export minio/my-minio /bin/true
4e466c4572b96cc16a619f6e13155657745aa653b1857929100f1a8208a58da8
$ docker run -p 9000:9000 --volumes-from minio-export --name minio1 minio/my-minio

AccessKey: IQP18YBF51DG8HSZEE7B  SecretKey: AlDzw6dj9zfne8JhPwGapt0Idlfg/QLhMq58Z0ax


Starting minio server:
Listening on http://127.0.0.1:9000
Listening on http://172.17.0.4:9000

```

#### Test the Persist feature

We created a few buckets in our previous Minio server. Let us see if they still exists.

```sh

$ mc ls localhost
[2016-01-20 14:25:56 IST]     0B mybucket/
[2016-01-21 12:59:52 IST]     0B newbucket/

```

They are very much intact, it clearly means we were able to store the Minio docker image.
