# How to run distributed MinIO in Docker swarm with Træfɪk loadbalancer [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

[Træfɪk](https://traefik.io/) is a modern reverse proxy also written in Go. It supports multiple ways to get configured, this cookbook will explain how you can setup distributed MinIO in Docker swarm which can be accessed inside swarm using a generic name (instead of `minio1`, `minio2`, ...) and expose MinIO to the outside world with just one (loadbalanced) port through Træfɪk.

## 1. Prerequisites

You have a running Docker swarm, if not head over to [Docker Swarm mode overview](https://docs.docker.com/engine/swarm/).

## 2. Steps

Based on official [Deploy MinIO on Docker Swarm](https://docs.minio.io/docs/deploy-minio-on-docker-swarm) docs, we will deploy MinIO using a Docker Compose file.

* strip the ports per MinIO and add Træfɪk as loadbalancer in front of
* add Træfɪk labels (mind the `Host:...` label which configures the frontend rule where Træfɪk is listening for Swarm internal and external access) to each MinIO service
* add `minioproxy` Træfɪk service
* Bonus: as we are using Docker swarm, we can also use secrets instead of environment variables (more secure)

### 2.1 Add Docker swarm secrets

Also see [MinIO Docker Quickstart Guide](https://docs.minio.io/docs/minio-docker-quickstart-guide)

```sh
echo "AKIAIOSFODNN7EXAMPLE" | docker secret create access_key -
echo "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY" | docker secret create secret_key -
```

### 2.2 Add attachable Docker overlay network

Used for testing later.

```sh
docker network create --attachable --driver overlay minio_distributed
```

### 2.3 Prepare Docker Compose file

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

### 2.4 Deploy Stack

```sh
docker stack deploy --compose-file=docker-compose.yaml minio_stack
```

## Test

### Inside Swarm

Now we spin up a MinIO mc test container on one of the Docker swarm nodes to access loadbalanced MinIO using it's generic name.

```sh
docker run --rm -it --network minio_distributed --entrypoint=/bin/sh minio/mc
mc config host add minio http://minioproxy:80 AKIAIOSFODNN7EXAMPLE wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
mc mb minio/foo
mc ls minio
```

### Outside Swarm

In this example, we configured Træfɪk with `Host:minioproxy,minio.example.com`. So we need to have a dns record for `minio.example.com` pointing to a ip address of any Docker swarm node or just add it to `/etc/hosts` for a quick test. Then the test is like the internal one just using another hostname and *NOT* to be run on a swarm node:

```sh
docker run --rm -it --entrypoint=/bin/sh minio/mc
mc config host add minio http://minio.example.com:80 AKIAIOSFODNN7EXAMPLE wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
mc mb minio/bar
mc ls minio
```
