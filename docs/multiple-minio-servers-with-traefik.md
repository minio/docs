# How to run multiple Minio servers with Træfɪk [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

[Træfɪk](https://traefik.io/) is a modern reverse proxy also written in Go. It
supports multiple ways to get configured, this cookbook will explain how you
can setup multiple Minio instances via Docker which you can access on different
sub-domains through Træfɪk.

## 1. Prerequisites

You have Docker installed and running, if not follow [install instructions](https://docs.docker.com/engine/installation/ubuntulinux/).

## 2. Steps

### Fetch, configure and launch Træfɪk

First of all you should create a configuration file for Træfɪk to enable Let's
Encrypt and to configure the Docker backend. Incoming traffic via HTTP gets
automatically redirected to HTTPS and the certificates are getting created on
demand by the integrated Let's Encrypt support.

```sh
cat << EOF > traefik.toml
defaultEntryPoints = ["http", "https"]

[entryPoints]
  [entryPoints.http]
    address = ":80"
    [entryPoints.http.redirect]
      entryPoint = "https"
  [entryPoints.https]
    address = ":443"
    [entryPoints.https.tls]

[acme]
email = "your@email.com"
storageFile = "/etc/traefik/acme.json"
entryPoint = "https"
onDemand = true

[docker]
endpoint = "unix:///var/run/docker.sock"
domain = "example.com"
watch = true
EOF
```

Beside the configuration we should also touch the `acme.json` file, this file
is the storage for the generated certificates. This file will also store the
private keys, so you should set proper permissions to make sure not everybody
can read the configuration.

```sh
touch acme.json
chmod 640 acme.json
```

With those steps we are prepared to launch a Træfɪk container which proxies the
incoming traffic.

```sh
docker run -d \
  --restart always \
  --name traefik \
  --publish 80:80 \
  --publish 443:443 \
  --volume $(pwd)/traefik.toml:/etc/traefik/traefik.toml \
  --volume $(pwd)/acme.json:/etc/traefik/adme.json \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  traefik
```

### Fetch, configure and launch Minio

Now it's time to prepare multiple instances of Minio to demonstrate a
multi-tenant solution. That way you are able to launch multiple Minio instances
with different credentials that get routed automatically by Træfɪk.

We will launch the Minio instances with volume mounts from the host system. If
you prefer data containers please take a look at the [Minio Docker quickstart guide](https://docs.minio.io/docs/minio-docker-quickstart-guide).

```sh
for i in $(seq 1 5); do
	mkdir -p $(pwd)/minio${i}/{export,config}

	docker run -d \
	  --restart always \
	  --name minio-${i} \
	  --volume $(pwd)/minio${i}/config:/root/.minio \
	  --volume $(pwd)/minio${i}/export:/export \
	  minio/minio
done
```

### Test launched instances

To test the launched instances you can take curl, that way you can verify that
the instances are really launched correctly.

```sh
curl -H Host:minio-1.example.com http://127.0.0.1
```

This call will result in the following output because the request had been
unauthenticated, but you can see that it finally have been correctly launched.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Error><Code>AccessDenied</Code><Message>Access Denied.</Message><Key></Key><BucketName></BucketName><Resource>/</Resource><RequestId>3L137</RequestId><HostId>3L137</HostId></Error>
```

Now you can reach all the launched Minio instances via `https://minio-{1,2,3,4,5}.example.com`

As a final note I would like to mention that you should start the Docker
containers with the init system of your operating system. As an example you can
see an example for a systemd service file how I'm launching new Minio
instances. Just store this file as `/etc/systemd/system/minio@.service` and
start new instances with `systemctl start minio@server1`,
`systemctl start minio@server2`, `systemctl start minio@server3` and the
instances will be available at `server1.example.com` and so on.

```sh
[Unit]
Description=Minio: %i

Requires=docker.service
After=docker.service

[Service]
Restart=always

ExecStop=/bin/sh -c '/usr/bin/docker ps | /usr/bin/grep %p-%i 1> /dev/null && /usr/bin/docker stop %p-%i || true'
ExecStartPre=/bin/sh -c '/usr/bin/docker ps | /usr/bin/grep %p-%i 1> /dev/null && /usr/bin/docker kill %p-%i || true'
ExecStartPre=/bin/sh -c '/usr/bin/docker ps -a | /usr/bin/grep %p-%i 1> /dev/null && /usr/bin/docker rm %p-%i || true'
ExecStartPre=/usr/bin/docker pull minio/minio:latest

ExecStart=/usr/bin/docker run --rm \
  --name %p-%i \
  --volume /storage/%p/%i/files:/export \
  --volume /storage/%p/%i/config:/root/.minio \
  --label traefik.frontend.rule=Host:%i.example.com \
  --label traefik.frontend.passHostHeader=true \
  minio/minio:latest

[Install]
WantedBy=multi-user.target
```
