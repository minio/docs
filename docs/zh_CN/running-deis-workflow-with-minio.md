# 结合MinIO运行Deis Workflow [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

[Deis Workflow](https://deis.com/)是一个开源的[PaaS](https://en.wikipedia.org/wiki/Platform_as_a_service) ，可以很容易地在自己的服务器上部署和管理应用程序。Workflow建立于[Kubernetes](http://kubernetes.io/)和[Docker](https://www.docker.com/)基础上，提供一个轻量级的PaaS，受[Heroku](https://www.heroku.com/)启发的工作流。Workflow有多个模块化比较好的组件（请看 <https://github.com/deis>），它们之间使用Kubernetes system和一个对象存储服务进行通信。它有良好的可配置性，可以配置为使用多种云存储服务，像[Amazon S3](https://aws.amazon.com/s3/), [Google Cloud Storage](https://cloud.google.com/storage/) ， [Microsoft Azure Storage](https://azure.microsoft.com/en-us/services/storage/)，当然，还有MinIO。我们目前不会建议你在Deis Workflow生产环境上使用MinIO，目前MinIO可以做为快速安装一个Deis Workflow集群，用于演示、开发、测试的方案。事实上，我们默认提供了装有MinIO的Deis Workflow。

要使用它，请按照<https://docs-v2.readthedocs.io/en/latest/installing-workflow/>中的说明进行操作。完成安装后，请按以下三种方法进行部署：

- [Buildpack部署](https://docs-v2.readthedocs.io/en/latest/applications/using-buildpacks/)
- [Dockerfile部署](https://docs-v2.readthedocs.io/en/latest/applications/using-dockerfiles/)
- [Docker Image部署](https://docs-v2.readthedocs.io/en/latest/applications/using-docker-images/)

所有这三种部署方法，以及Workflow内部广泛使用了MinIO：

- Buildpack部署使用了MinIO存储代码和[slugs](https://devcenter.heroku.com/articles/slug-compiler)
- Dockerfile部署使用了MinIO存储Dockerfiles和关联的artifacts
- Docker Image部署使用了MinIO作为运行Workflow的内部Docker registry的后备存储
- Workflow的内部数据库存储用户登录信息，SSH密钥等。它将所有数据备份到MinIO
