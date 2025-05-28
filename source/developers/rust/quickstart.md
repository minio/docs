# MinIO Rust SDK for Amazon S3 Compatible Cloud Storage [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io) [![Sourcegraph](https://sourcegraph.com/github.com/minio/minio-rs/-/badge.svg)](https://sourcegraph.com/github.com/minio/minio-rs?badge) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-blue.svg)](https://github.com/minio/minio-rs/blob/master/LICENSE)

MinIO Rust SDK is Simple Storage Service (aka S3) client to perform bucket and object operations to any Amazon S3 compatible object storage service.

For a complete list of APIs and examples, please take a look at the [MinIO Rust Client API Reference](https://minio-rs.min.io/)

## Examples

Run the examples from the command line with:

`cargo run --example <example_name>`

### file_uploader.rs

* [Upload a file to MinIO](examples/file_uploader.rs)
* [Upload a file to MinIO with CLI](examples/put_object.rs)

### file_downloader.rs

* [Download af file from MinIO](examples/file_downloader.rs)

### object_prompt.rs 

* [Prompt a file on MinIO](examples/object_prompt.rs)

## License
This SDK is distributed under the [Apache License, Version 2.0](https://www.apache.org/licenses/LICENSE-2.0), see [LICENSE](https://github.com/minio/minio-rs/blob/master/LICENSE) for more information.
