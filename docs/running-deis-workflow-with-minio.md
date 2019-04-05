# Running Deis Workflow with MinIO [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

[Deis Workflow](https://deis.com/) is an open source [PaaS](https://en.wikipedia.org/wiki/Platform_as_a_service) that makes it easy to deploy and manage applications on your own servers. Workflow builds upon [Kubernetes](http://kubernetes.io/) and [Docker](https://www.docker.com/) to provide a lightweight PaaS with a [Heroku](https://www.heroku.com/)-inspired workflow. Workflow is implemented as a variety of self-contained components (see <https://github.com/deis> for a list) which communicate using both the Kubernetes system and an object storage server. It's configurable to use cloud object storage systems like [Amazon S3](https://aws.amazon.com/s3/), [Google Cloud Storage](https://cloud.google.com/storage/) and [Microsoft Azure Storage](https://azure.microsoft.com/en-us/services/storage/) and, of course, MinIO. We don't yet recommend you use MinIO in production Deis Workflow installations, we do recommend it as a great way to quickly install a Deis Workflow cluster for a quick demo, development, testing, etc. In fact, we ship Deis Workflow with MinIO installed by default.

To use it, follow the instructions at <https://docs-v2.readthedocs.io/en/latest/installing-workflow/>. Once you've completed the installation, follow any of the three methods for deployment listed below:

- [Buildpack Deployment](https://docs-v2.readthedocs.io/en/latest/applications/using-buildpacks/)
- [Dockerfile Deployment](https://docs-v2.readthedocs.io/en/latest/applications/using-dockerfiles/)
- [Docker Image Deployment](https://docs-v2.readthedocs.io/en/latest/applications/using-docker-images/)

All of the three deployment methods, as well as Workflow internals use MinIO extensively behind the scenes:

- Buildpack deployments use MinIO to store code and [slugs](https://devcenter.heroku.com/articles/slug-compiler)
- Dockerfile deployments use MinIO to store Dockerfiles and associated artifacts
- Docker Image deployments use MinIO as the backing store for the internal Docker registry that Workflow runs
- The internal Workflow database stores user login information, SSH keys, and more. It backs all data up to MinIO
