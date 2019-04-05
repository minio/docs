# 如何使用AWS SDK for Java给MinIO Server进行加密 [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

`aws-sdk` for Java是java语言版本的官方AWS SDK。本文我们将学习如何使用`aws-sdk` for Java给MinIO Server进行加密，使用对称加密和非对称加密。

加密可以给一些存储在MinIO Server的敏感的用户数据(图片, 音频等)提供额外的安全性。

## 前提条件

从[官方AWS SDK for Java文档](http://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/welcome.html)下载并安装`aws-sdk` for Java。

## 对称加密

对称加密使用同一个key进行加密和解密。以下是使用AES进行对称加密的步骤：

### 1. 生成AES key

 使用[Java KeyGenrator](https://docs.oracle.com/javase/7/docs/api/javax/crypto/KeyGenerator.html)类生成一个256位的AES key。

```java
    // 生成256位AES key.
    KeyGenerator symKeyGenerator = KeyGenerator.getInstance("AES");
    symKeyGenerator.init(256);
    SecretKey symKey = symKeyGenerator.generateKey();
```

### 2. 使用生成的key创建AWS S3加密客户端。

```java
    EncryptionMaterials encryptionMaterials = new EncryptionMaterials(
      mySymmetricKey);

    // 添加 MinIO Server accessKey和secretKey  
    AWSCredentials credentials = new BasicAWSCredentials(
      "USWUXHGYZQYFYFFIT3RE", "MOJRH0mkL1IPauahWITSVvyDrQbEEIwljvmxdq03");

    // 创建以MinIO Server做为endpoint的加密client。
    AmazonS3EncryptionClient encryptionClient = new AmazonS3EncryptionClient(
      credentials, new StaticEncryptionMaterialsProvider(
      encryptionMaterials));
    Region usEast1 = Region.getRegion(Regions.US_EAST_1);
    encryptionClient.setRegion(usEast1);
    encryptionClient.setEndpoint("http://localhost:9000");
```

### 3. 使用AWS S3加密客户端操作MinIO。

使用前面步骤创建的加密客户端操作MinIO Server。

```java
    // 创建存储桶
    encryptionClient.createBucket(bucketName);

    // 使用加密client上传文件
    byte[] plaintext = "Hello World, S3 Client-side Encryption Using Asymmetric Master Key!"
      .getBytes();
    System.out.println("plaintext's length: " + plaintext.length);
    encryptionClient.putObject(new PutObjectRequest(bucketName, objectKey,
    new ByteArrayInputStream(plaintext), new ObjectMetadata()));
```

### 4. 测试

文件下载之后，验证解密后的文件是否和之前上传到MinIO Server的原文件是否相同。

```java
    // 下载文件
    S3Object downloadedObject = encryptionClient.getObject(bucketName,
    objectKey);
    byte[] decrypted = IOUtils.toByteArray(downloadedObject
    .getObjectContent());

    // 验证数据是否一致
    Assert.assertTrue(Arrays.equals(plaintext, decrypted));
```

完整的AES加密代码在[这里](././sample-code/aws-sdk-java-encryption-code/symmetric-AES/)

## 非对称加密

非对称加密使用公钥进行加密，私钥进行解密。以下是使用[RSA](https://en.wikipedia.org/wiki/RSA_(cryptosystem))进行非对称加密的步骤：

### 1. 生成RSA key

```java
    // 生成RSA key pair
    KeyPairGenerator keyGenerator = KeyPairGenerator.getInstance(algorithm);
    keyGenerator.initialize(1024, srand);
    keyGenerator.generateKeyPair();
```

### 2. 使用生成的key创建AWS S3加密客户端。

```java
    EncryptionMaterials encryptionMaterials = new EncryptionMaterials(
      loadedKeyPair);

    // 添加 MinIO Server accessKey和secretKey
    AWSCredentials credentials = new BasicAWSCredentials("USWUXHGYZQYFYFFIT3RE",
      "MOJRH0mkL1IPauahWITSVvyDrQbEEIwljvmxdq03");	   

    // 创建以MinIO Server做为endpoint的加密client。
    AmazonS3EncryptionClient encryptionClient = new AmazonS3EncryptionClient(
      credentials, new StaticEncryptionMaterialsProvider(encryptionMaterials));
    Region usEast1 = Region.getRegion(Regions.US_EAST_1);
    encryptionClient.setRegion(usEast1);
    encryptionClient.setEndpoint("http://localhost:9000");
```

### 3. 使用AWS S3加密客户端操作MinIO。

使用前面步骤创建的加密客户端操作MinIO Server。

```java
    // 创建存储桶
    encryptionClient.createBucket(bucketName);

    // 上传文件
    byte[] plaintext = "Hello World, S3 Client-side Encryption Using Asymmetric Master Key!"
      .getBytes();
    System.out.println("plaintext's length: " + plaintext.length);
    encryptionClient.putObject(new PutObjectRequest(bucketName, objectKey,
    new ByteArrayInputStream(plaintext), new ObjectMetadata()));
```

### 4. 测试

文件下载之后，验证解密后的文件是否和之前上传到MinIO Server的原文件是否相同。

```java
    // 下载文件
    S3Object downloadedObject = encryptionClient.getObject(bucketName,
      objectKey);
    byte[] decrypted = IOUtils.toByteArray(downloadedObject
      .getObjectContent());
    Assert.assertTrue(Arrays.equals(plaintext, decrypted));

    // 验证数据是否一致
    System.out.println("decrypted length: " + decrypted.length);
```

完整的RSA加密代码在[这里](././sample-code/aws-sdk-java-encryption-code/asymmetric-RSA/)

*注意*:当MinIO生成一个presignedURL，它代表的是一个加密后的对象。所以，如果通过其它方法比如curl下载这个对象，你得到的将会是一个加密后的对象。这是因为curl对加密的事一无所知。
