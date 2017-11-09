# How to use Minio's server-side-encryption [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

Minio supports S3 server-side-encryption with customer provided keys (SSE-C).
A client **must** specify three HTTP headers for SSE-C requests:
 - The algorithm identifier: `X-Amz-Server-Side-Encryption-Customer-Algorithm`  
   The only valid value is: `AES256`.
 - The secret encryption key: `X-Amz-Server-Side-Encryption-Customer-Key`  
   The secret encryption key **must** be a 256 bit base64 encoded string.
 - The encryption key MD5 checksum: `X-Amz-Server-Side-Encryption-Customer-Key-MD5`  
   The encryption key MD5 checksum **must** be the MD5-sum of the encryption key.
   The encryption key MD5 checksum is the MD5-sum of the raw binary key not of the
   base64 encoded key.

**Security notice:**
 - According to the S3 specification the minio server will reject any SSE-C request made over an insecure (non-TLS) connection. This means that SSE-C **requires** TLS / HTTPS.
 - A SSE-C request contains the encryption key. If a SSE-C request is ever made over a non-TLS connection the SSE-C encryption key **must** be treated as compromised.
 - According to the S3 specification the returned content-md5 of an SSE-C PUT operation does not match the MD5-sum of the uploaded object.
 - Minio server uses a tamper-proof encryption scheme to encrypt objects and
   does **not save** the encryption key. This means that you are responsible to manage encryption keys. If you loose the encryption key of an object you will loose that object.
 - The minio server expects that the SSE-C encryption key is of *high entropy*.
   The encryption key is **not** a password. If you want to use a password make sure that you derive a high-entropy key using a password-based-key-derivation-function (PBKDF) like Argon2, scrypt or PBKDF2.

 ## 1. Prerequisites

Install Minio Server **with TLS** from [here](https://docs.minio.io/docs/how-to-secure-access-to-minio-server-with-tls).

Notice that tools like aws-cli or mc will show an error if use a self-signed TLS certificate and try to upload objects to the server. Please take a look at Let's Encrypt to get a CA-signed TLS certificate. Self-signed certificates should only be used for development/testing or internal usage.

## 2. Use SSE-C with the aws-cli

Install the aws-cli like shown [here](https://docs.minio.io/docs/aws-cli-with-minio).

Let's assume your running a local minio server on `https://localhost:9000` with
a self-signed certificate. To skip the TLS certificate verification you need to
specify: `--no-verify-ssl`. If your minio server uses a CA-signed certificate you
should **never** specify `--no-verify-ssl`. Otherwise the aws-cli would accept
any certificate. 

### 2.1 Upload an object.

1. Create a bucket named `my-bucket`:  
`aws --no-verify-ssl --endpoint-url https://localhost:9000 s3api create-bucket --bucket my-bucket`
2. Upload an object using SSE-C. The object name is `my-secret-diary` and the
   its content is the file `~/my-diary.txt`.
    ```
    aws s3api put-object\
    --no-verify-ssl\
    --endpoint-url https://localhost:9000\
    --bucket my-bucket --key my-secret-diary\
    --sse-customer-algorithm AES256\
    --sse-customer-key MzJieXRlc2xvbmdzZWNyZXRrZXltdXN0cHJvdmlkZWQ=\
    --sse-customer-key-md5 7PpPLAK26ONlVUGOWlusfg==\
    --body ~/my-diary.txt
    ```
    You should use your own encryption key.

### 2.2 Show object information
  You **must** specify the correct SSE-C key of an encrypted object to show its metadata:
  ```
  aws s3api head-object\
  --no-verify-ssl\
  --endpoint-url https://localhost:9000\
  --bucket my-bucket\
  --key my-secret-diary\
  --sse-customer-algorithm AES256\
  --sse-customer-key MzJieXRlc2xvbmdzZWNyZXRrZXltdXN0cHJvdmlkZWQ=\
  --sse-customer-key-md5 7PpPLAK26ONlVUGOWlusfg==
  ```

### 2.3 Download an object

1. Now delete your local copy of `my-diary.txt`:  
   `rm ~/my-diary.txt` 
   
2. You can restore the diary by downloading it from the server:
   ```
   aws s3api get-object\
   --no-verify-ssl\
   --endpoint-url https://localhost:9000\
   --bucket my-bucket\
   --key my-secret-diary\
   --sse-customer-algorithm AES256\
   --sse-customer-key MzJieXRlc2xvbmdzZWNyZXRrZXltdXN0cHJvdmlkZWQ=\
   --sse-customer-key-md5 7PpPLAK26ONlVUGOWlusfg==\
   ~/my-diary.txt
   ```

   