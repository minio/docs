# Elasticsearch snapshots on Minio Server [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

Elasticsearch is a distributed, RESTful search and analytics engine. In this recipe we'll see how to store Elasticsearch `6.x` snapshots to Minio server.

## 1. Prerequisites

- Install Minio Server from [here](http://docs.minio.io/docs/minio-quickstart-guide).
- Download Elasticsearch version `6.2.4` from [here](https://www.elastic.co/downloads/elasticsearch).

## 2. Installation

Extract the `elasticsearch-6.2.4` tar ball in the directory where you plan to install Elasticsearch.

## 3. Install S3 Repository plugin in Elasticsearch

The S3 repository plugin adds support for using S3 as a repository for Snapshot/Restore. Install the plugin using plugin manager. Run the below command from inside the Elasticsearch directory

```sh
sudo bin/elasticsearch-plugin install repository-s3
```

## 4. Configure Elasticsearch

S3 Repository plugin points to AWS S3 by default. Add the below fields to `conf/elasticsearch.yml` file, so that the S3 Repository plugin talks to the Minio installation.

```yaml
s3.client.default.endpoint: "http://127.0.0.1:9000" # Replace with actual Minio server endpoint
s3.client.default.protocol: http                    # Replace with actual protocol (http/https)
```

S3 repository credentials are sensitive and must be stored in the elasticsearch keystore. Use the below commands to create entries for access key and secret key

```sh
bin/elasticsearch-keystore add s3.client.default.access_key
bin/elasticsearch-keystore add s3.client.default.secret_key
```

## 5. Configure Minio server

Assuming Minio server is running on `http://127.0.0.1:9000`. Create a bucket called `elasticsearch` on your Minio server. This is the bucket to store Elasticsearch snapshots. Using `mc`

```sh
mc config host add myminio http://127.0.0.1:9000 minio minio123
mc mb myminio/elasticsearch
```

## 6. Start Elastisearch and create repository

Start Elasticsearch by running

```sh
bin/elasticsearch
```

Then create the repository by

```sh
curl -X PUT "localhost:9200/_snapshot/my_minio_repository" -H 'Content-Type: application/json' -d'
{
  "type": "s3",
  "settings": {
    "bucket": "elasticsearch",
    "endpoint": "http://127.0.0.1:9000",
    "protocol": "http"
  }
}
'
```

Confirm if the repository was successfully created by

```sh
curl -X GET http://127.0.0.1:9200/_snapshot/my_minio_repository?pretty
```

## 7. Create Snapshots

We're now all set to create snapshots. Create a snapshot using 

```sh
curl -X PUT http://127.0.0.1:9200/_snapshot/my_minio_repository/snapshot_1/\?wait_for_completion=true
```

This will make a snapshot and upload it to the Minio repository we just created. Verify using 

```sh
curl -X GET http://127.0.0.1:9200/_snapshot/my_minio_repository/snapshot_1/
```
