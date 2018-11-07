# How to use Minio's Server-side Encryption with the AWS CLI

Minio supports S3 server-side-encryption with customer provided keys (SSE-C). The following sections describe the use of server-side encryption with the AWS Command Line Interface (`aws-cli`):
* [Prerequisites](#prerequisites)
* [Use SSE-C with aws-cli](#use-sse-c-with-aws-cli)
* [Security-Related Notes](#security-notice)

## <a name="prerequisites"></a>1. Prerequisites

A client must specify three HTTP headers for SSE-C requests:
* `X-Amz-Server-Side-Encryption-Customer-Algorithm`: The algorithm identifier. It must be set to `AES256`.
* `X-Amz-Server-Side-Encryption-Customer-Key`: The secret encryption key. It must be a 256-bit Base64-encoded string.
* `X-Amz-Server-Side-Encryption-Customer-Key-MD5`: The encryption key MD5 checksum. It must be set to the MD5-sum of the encryption key. Note: The MD5 checksum is the MD5 sum of the raw binary key, not of the base64-encoded key.

Install the Minio Server with TLS as described [here](https://docs.minio.io/docs/how-to-secure-access-to-minio-server-with-tls).

**Note**: Tools like `aws-cli` or `mc` will display an error if a self-signed TLS certificate is used when trying to upload objects to the server. See [Let's Encrypt](https://letsencrypt.org/) to get a CA-signed TLS certificate. Self-signed certificates should only be used for development, testing or internal usage.

## <a name="use-sse-c-with-aws-cli"></a>2. Use SSE-C with aws-cli

This section describes how to use server-side encryption with customer-provided encryption (SSE-C) keys via the aws-cli.

### Install the aws-cli 
You can install the AWS Command Line Interface using the procedure described [here](https://docs.minio.io/docs/aws-cli-with-minio).

### Create a bucket named `my-bucket`

```sh
aws --no-verify-ssl --endpoint-url https://localhost:9000 s3api create-bucket --bucket my-bucket
```

### Upload an Object using SSE-C

The following example shows how to upload an object named `my-secret-diary` where the content is the file `~/my-diary.txt`. Note that you should use your own encryption key.

```sh
aws s3api put-object \
  --no-verify-ssl \
  --endpoint-url https://localhost:9000 \
  --bucket my-bucket --key my-secret-diary \
  --sse-customer-algorithm AES256 \
  --sse-customer-key MzJieXRlc2xvbmdzZWNyZXRrZXltdXN0cHJvdmlkZWQ= \
  --sse-customer-key-md5 7PpPLAK26ONlVUGOWlusfg== \
  --body ~/my-diary.txt 
```

In this example, a local Minio server is running on https://localhost:9000 with a self-signed certificate. TLS certificate verification is skipped using: `--no-verify-ssl`. If a Minio server uses a CA-signed certificate, then `--no-verify-ssl` should not be included, otherwise aws-cli would accept any certificate.


### Display Object Information
Specify the correct SSE-C key of an encrypted object to display its metadata:

```sh
Copy  aws s3api head-object \
  --no-verify-ssl \
  --endpoint-url https://localhost:9000 \
  --bucket my-bucket \
  --key my-secret-diary \
  --sse-customer-algorithm AES256 \
  --sse-customer-key MzJieXRlc2xvbmdzZWNyZXRrZXltdXN0cHJvdmlkZWQ= \
  --sse-customer-key-md5 7PpPLAK26ONlVUGOWlusfg==
```

### Download an Object
The following examples show how a local copy of a file can be removed and then restored by downloading it from the server:

Delete your local copy of `my-diary.txt`:

```sh
rm ~/my-diary.txt
```

Restore the file by downloading it from the server:

```sh
aws s3api get-object \
--no-verify-ssl \
--endpoint-url https://localhost:9000 \
--bucket my-bucket \
--key my-secret-diary \
--sse-customer-algorithm AES256 \
--sse-customer-key MzJieXRlc2xvbmdzZWNyZXRrZXltdXN0cHJvdmlkZWQ= \
--sse-customer-key-md5 7PpPLAK26ONlVUGOWlusfg== \
~/my-diary.txt
```

## <a name="security-notice"></a>3. Security-Related Notes

* The Minio server will reject any SSE-C request made over an insecure (non-TLS) connection per the S3 specification. This means that SSE-C requires TLS / HTTPS, and an SSE-C request contains the encryption key. 
* If an SSE-C request is made over a non-TLS connection, the SSE-C encryption key must be treated as compromised.
* Per the S3 specification, the `content-md5` returned by an SSE-C PUT operation does not match the MD5 sum of the uploaded object. 
* The Minio server uses a tamper-proof encryption scheme to encrypt objects and does not save the encryption key, which means you are responsible for managing encryption keys. If you lose the encryption key for an object, you will lose the ability to decrypt that object.
* The Minio server expects that the SSE-C encryption key is of *high entropy*. The encryption key is not a password. If you want to use a password make sure that you derive a high-entropy key using a password-based-key-derivation-function (PBKDF) like Argon2, scrypt or PBKDF2.

