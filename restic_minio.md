# Running restic on Minio. -- DRAFT

## This document assumes-
* You have restic installed and running, if not follow [install instructions](https://restic.github.io/manual/)
* You have Minio server installed and running, if not follow [install instructions](https://github.com/minio/minio/blob/master/README.md)

## Steps

### Authenticating restic to use Minio server
```
$ export AWS_ACCESS_KEY_ID=IQP18YBF51DG8HSZEE7B
$ export AWS_SECRET_ACCESS_KEY=AlDzw6dj9zfne8JhPwGapt0Idlfg/QLhMq58Z0ax
```
>TIP: Replace these keys with your Minio credentials .

### restic operations on Minio
```
$ ./restic -r s3:http://localhost:9000/resticbucket init
```
>TIP: Replace the endpoint with your Minio configuration.

```
$  ./restic -r s3:http://localhost:9000/resticbucket backup /home/minio/workdir/Docs/
enter password for repository:
scan [/home/minio/workdir/Docs]
scanned 2 directories, 6 files in 0:00
[0:00] 100.00%  0B/s  8.045 KiB / 8.045 KiB  6 / 8 items  0 errors  ETA 0:00
duration: 0:00, 0.06MiB/s
snapshot 85a9731a saved

```

You can read more on restic [here](https://restic.github.io) and documents about Minio server is available [here](https://github.com/minio/minio).

### suggestions
We would love to hear back from you, feel free to reach out to us [![Gitter](http://minio.io/img/gitter.svg)](https://gitter.im/minio/minio?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)  [![Twitter](http://minio.io/img/twitter.svg)](https://twitter.com/intent/user?screen_name=minio)
