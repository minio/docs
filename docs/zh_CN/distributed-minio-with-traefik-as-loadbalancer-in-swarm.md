# 如何使用Træfik loadbalancer和Docker swarm运行分布式MinIO [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

[Træfɪk](https://traefik.io/)是一个用Go语言写的先进（和流行技术结合的比较好）的反向代理。它支持多种配置方式，本文将阐述如何用Docker swarm来设置分布式MinIO,并且可以在swarm中用通用名称（而不是`minio1`, `minio2`, ...）来进行访问，而且可以通过Træfɪk对外暴露一个（loadbalanced）端口。

## 1. 前提条件

有一个正在运行的Docker swarm, 可参考[Docker Swarm mode overview](https://docs.docker.com/engine/swarm/)。

## 2. 步骤

参考[Deploy MinIO on Docker Swarm](https://docs.min.io/docs/deploy-minio-on-docker-swarm)官方文档，我们可以使用一个Docker Compose file来部署MinIO。

* 剥离每个MinIO的端口，将Træfɪk做为前置负载均衡
* 添加Træfɪk标签(注意一下`Host:...`标签，它配置了Træfɪk监听Swarm内部及外部访问的前端规则)到每个MinIO Server。
* 添加 `minioproxy` Træfik service。
* 额外收获: 由于咱们用了Docker swarm,我们还可以使用secrets而不是环境变量（这样更安全）。

### 2.1 添加Docker swarm secrets

可以参考[MinIO Docker快速入门](https://docs.min.io/docs/minio-docker-quickstart-guide)

```sh
echo "AKIAIOSFODNN7EXAMPLE" | docker secret create access_key -
echo "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY" | docker secret create secret_key -
```

### 2.2 添加attachable Docker overlay network

后续测试用。

```sh
docker network create --attachable --driver overlay minio_distributed
```

### 2.3 准备Docker Compose file

```yml
version: '3.1'

services:
  minio1:
    image: minio/minio:RELEASE.2017-05-05T01-14-51Z
    volumes:
      - minio1-data:/export
    networks:
      - minio_distributed
    deploy:
      restart_policy:
        delay: 10s
        max_attempts: 10
        window: 60s
      labels:
        traefik.frontend.rule: "Host:minioproxy"
        traefik.port: "9000"
    command: server http://minio1/export http://minio2/export http://minio3/export http://minio4/export
    secrets:
      - secret_key
      - access_key

  minio2:
    image: minio/minio:RELEASE.2017-05-05T01-14-51Z
    volumes:
      - minio2-data:/export
    networks:
      - minio_distributed
    deploy:
      restart_policy:
        delay: 10s
        max_attempts: 10
        window: 60s
      labels:
        traefik.frontend.rule: "Host:minioproxy"
        traefik.port: "9000"
    command: server http://minio1/export http://minio2/export http://minio3/export http://minio4/export
    secrets:
      - secret_key
      - access_key

  minio3:
    image: minio/minio:RELEASE.2017-05-05T01-14-51Z
    volumes:
      - minio3-data:/export
    networks:
      - minio_distributed
    deploy:
      restart_policy:
        delay: 10s
        max_attempts: 10
        window: 60s
      labels:
        traefik.frontend.rule: "Host:minioproxy"
        traefik.port: "9000"
    command: server http://minio1/export http://minio2/export http://minio3/export http://minio4/export
    secrets:
      - secret_key
      - access_key

  minio4:
    image: minio/minio:RELEASE.2017-05-05T01-14-51Z
    volumes:
      - minio4-data:/export
    networks:
      - minio_distributed
    deploy:
      restart_policy:
        delay: 10s
        max_attempts: 10
        window: 60s
      labels:
        traefik.frontend.rule: "Host:minioproxy,minio.example.com"
        traefik.port: "9000"
    command: server http://minio1/export http://minio2/export http://minio3/export http://minio4/export
    secrets:
      - secret_key
      - access_key

  minioproxy:
    image: traefik
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    networks:
      -  minio_distributed
    ports:
      - 80:80
    deploy:
      placement:
        constraints: [node.role == manager]
    command: --docker --docker.swarmmode --docker.domain=minio --docker.watch --web

volumes:
  minio1-data:

  minio2-data:

  minio3-data:

  minio4-data:

networks:
  minio_distributed:
    external: true

secrets:
  secret_key:
    external: true
  access_key:
    external: true
```

### 2.4 部署Stack

```sh
docker stack deploy --compose-file=docker-compose.yaml minio_stack
```

## 测试

### Swarm内部

现在我们在一个Docker swarm节点上启动一个MinIO mc测试容器，使用MinIO的通用名称访问负载均衡的MinIO。

```sh
docker run --rm -it --network minio_distributed --entrypoint=/bin/sh minio/mc
mc config host add minio http://minioproxy:80 AKIAIOSFODNN7EXAMPLE wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
mc mb minio/foo
mc ls minio
```

### Swarm外部

本示例中，我们配置Træfɪk为`Host:minioproxy,minio.example.com`。所以我们需要有一个`minio.example.com`的dns记录，指向任意Docker swarm节点的ip地址，或者为了快速验证的话，直接把它加到`/etc/hosts`里。然后测试时就像是使用另一个主机名的内部测试，而不是在swarm节点上运行。

```sh
docker run --rm -it --entrypoint=/bin/sh minio/mc
mc config host add minio http://minio.example.com:80 AKIAIOSFODNN7EXAMPLE wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
mc mb minio/bar
mc ls minio
```
