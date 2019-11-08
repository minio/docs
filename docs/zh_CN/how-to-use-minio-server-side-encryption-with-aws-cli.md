# 如何使用aws-cli调用MinIO服务端加密 [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

MinIO支持采用客户端提供的秘钥（SSE-C）进行S3服务端加密。
客户端**必须**为SSE-C请求指定三个HTTP请求头：
- 算法标识符: `X-Amz-Server-Side-Encryption-Customer-Algorithm`
  唯一的合法值是: `AES256`。
- 加密秘钥: `X-Amz-Server-Side-Encryption-Customer-Key`
  加密秘钥**必须**是一个256位的base64编码的字符串。
- 加密密钥MD5校验和: `X-Amz-Server-Side-Encryption-Customer-Key-MD5`
  加密密钥MD5校验和**必须**是秘钥的MD5和，注意是原始秘钥的MD5和，而不是base64编码之后的。

**安全须知：**
- 根据S3规范，minio服务器将拒绝任何通过不安全（非TLS）连接进行的SSE-C请求。 这意味着SSE-C**必须是**TLS / HTTPS。
- SSE-C请求包含加密密钥。 如果通过非TLS连接进行SSE-C请求，则**必须**将SSE-C加密密钥视为受损。
- 根据S3规范，SSE-C PUT操作返回的content-md5与上传对象的MD5-sum不匹配。
- MinIO Server使用防篡改加密方案来加密对象，并且**不会保存**加密密钥。 这意味着您有责任保管好加密密钥。 如果你丢失了某个对象的加密密钥，你将会丢失该对象。
- MinIO Server期望SSE-C加密密钥是*高熵*的。加密密钥是**不是**密码。如果你想使用密码，请确保使用诸如Argon2，scrypt或PBKDF2的基于密码的密钥派生函数（PBKDF）来派生高熵密钥。

## 1. 前提条件

从[这里](https://docs.min.io/docs/how-to-secure-access-to-minio-server-with-tls)下载MinIO Server,并安装成带有**TLS**的服务。

注意一下，如果你使用的是自己签名的TLS证书，那么当你往MinIO Server上传文件时，像aws-cli或者是mc这些工具就会报错。如果你想获得一个CA结构签名的TLS证书，请参考`Let's Encrypt`。自己签名的证书应该仅做为内部开发和测试。

## 2. 使用SSE-C和aws-cli

从[这里](https://docs.min.io/docs/aws-cli-with-minio)下载并安装aws-cli。

假设你在本地运行了一个MinIO Server,地址是`https://localhost:9000`，并且使用的是自己签名的证书。为了绕过TLS证书的验证，你需要指定`--no-verify-ssl`。如果你的MinIO Server使用的是一个CA认证的证书，那你**永远永远永远**不要指定`--no-verify-ssl，否则aws-cli会接受任何证书。

### 2.1 上传一个对象

- 创建一个名为`my-bucket`的存储桶：

`aws --no-verify-ssl --endpoint-url https://localhost:9000 s3api create-bucket --bucket my-bucket`

- 使用SSE-C上传一个对象。对象名为`my-secret-diary`，内容来自文件`~/my-diary.txt`。

```
aws s3api put-object \
 --no-verify-ssl \
 --endpoint-url https://localhost:9000 \
 --bucket my-bucket --key my-secret-diary \
 --sse-customer-algorithm AES256 \
 --sse-customer-key MzJieXRlc2xvbmdzZWNyZXRrZXltdXN0cHJvdmlkZWQ= \
 --sse-customer-key-md5 7PpPLAK26ONlVUGOWlusfg== \
 --body ~/my-diary.txt
```

你需要指定你自己的加密秘钥。

### 2.2 显示对象信息

你**必须**指定正确的SSE-C秘钥才能得到加密对象的元数据：
```
aws s3api head-object \
 --no-verify-ssl \
 --endpoint-url https://localhost:9000 \
 --bucket my-bucket \
 --key my-secret-diary \
 --sse-customer-algorithm AES256 \
 --sse-customer-key MzJieXRlc2xvbmdzZWNyZXRrZXltdXN0cHJvdmlkZWQ= \
 --sse-customer-key-md5 7PpPLAK26ONlVUGOWlusfg==
```

### 2.3 下载一个对象

1. 删除文件`my-diary.txt`的本地副本：

```
rm ~/my-diary.txt
```

2. 你可以从服务器上把该文件重新下载下来：

```
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
