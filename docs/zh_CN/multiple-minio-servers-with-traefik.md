# 如何使用Træfɪk代理多个MinIO服务 [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

[Træfɪk](https://traefik.io/)是一个用Go语言写的先进（和流行技术结合的比较好）的反向代理。它支持多种配置方式，本文将介绍如何通过Docker设置多个MinIO实例，并用Træfɪk可实现通过不同的子域名进行访问。 

## 1. 前提条件

已经安装Docker并运行, 如果没有参考[安装说明](https://docs.docker.com/engine/installation/ubuntulinux/).

## 2. 步骤

### 获取，配置和启动Træfɪk

首先你应该为Træfɪk创建一个配置文件来启用Let's Encrypt并配置Docker后端。通过HTTP获取请求自动重定向到HTTPS，证书通过集成的Let's Encrypt进行创建。

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

除了上面的配置之外，我们还需要touch一下`acme.json`，这个文件存了生成的证书，同时也存着私钥,所以你需要设置好权限，别让所有人都能访问这个文件。


```sh
touch acme.json
chmod 640 acme.json
```

经过上述步骤，我们已经准备好了一个可以代理请求的Træfɪk容器。

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

### 获取，配置和启动MinIO

现在咱们可以准备多个MinIO的实例，来演示一个多租户场景的解决方案。你可以启动多个MinIO实例，让Træfɪk基于不同的凭据信息来进行路由。

我们将从宿主机上启动多个带有挂载卷的MinIO实例。如果你更喜欢data containers，请参考[MinIO Docker 快速入门](https://docs.min.io/docs/minio-docker-quickstart-guide).

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

### 测试启动的实例

你可以用curl来测试启动的实例，这样你就可以确认实例是否启动正确。

```sh
curl -H Host:minio-1.example.com http://127.0.0.1
```

这个请求会获得下面的输出信息，因为没有认证，不过你可以看到确实是正确启动了。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Error><Code>AccessDenied</Code><Message>Access Denied.</Message><Key></Key><BucketName></BucketName><Resource>/</Resource><RequestId>3L137</RequestId><HostId>3L137</HostId></Error>
```

现在你可以通过`https://minio-{1,2,3,4,5}.example.com`来访问所有的MinIO实例。

最后我想多说一句，你应该用你操作系统的init system来启支MinIO的Docker容器。做为示例，你可以看到我是如何使用systemd service来启动新的MinIO实例。就是把这个文件存成`/etc/systemd/system/minio@.service`，并且用`systemctl start minio@server1`来启动新的实例，然后这个实例就可以通过`server1.example.com`来访问了，诸如此类。

```sh
[Unit]
Description=MinIO: %i

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
