# How to use AWS SDK for Java for encryption with Minio Server [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

`aws-sdk` for Java is the official AWS SDK for Java. In this recipe we will learn how to use `aws-sdk` for Java for encryption on Minio server using both Symmetric and Asymmetric approach.

Encryption allows additional security layer for sensitive user data (images, audio clips, etc.) stored on Minio server.

## Prerequisites

Install `aws-sdk` for Java from the official AWS SDK docs [here](http://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/welcome.html).

## Symmetric Encryption

Symmetric Encryption uses single key for both encryption and decryption. Following are the steps involved for Symmetric Encryption using AES :

### 1. Generate AES key

 Use [Java KeyGenrator](https://docs.oracle.com/javase/7/docs/api/javax/crypto/KeyGenerator.html) class for generating 256 bit AES key.

```java
    //Generate symmetric 256 bit AES key.
    KeyGenerator symKeyGenerator = KeyGenerator.getInstance("AES");
    symKeyGenerator.init(256);
    SecretKey symKey = symKeyGenerator.generateKey();
```

### 2. Create AWS S3 encryption client using generated key.

```java
    EncryptionMaterials encryptionMaterials = new EncryptionMaterials(
      mySymmetricKey);

    // Add Minio server accessKey and secretKey  
    AWSCredentials credentials = new BasicAWSCredentials(
      "USWUXHGYZQYFYFFIT3RE", "MOJRH0mkL1IPauahWITSVvyDrQbEEIwljvmxdq03");

    // Create encryption client with Minio server as endpoint  
    AmazonS3EncryptionClient encryptionClient = new AmazonS3EncryptionClient(
      credentials, new StaticEncryptionMaterialsProvider(
      encryptionMaterials));
    Region usEast1 = Region.getRegion(Regions.US_EAST_1);
    encryptionClient.setRegion(usEast1);
    encryptionClient.setEndpoint("http://localhost:9000");
```

### 3. Operations on Minio using AWS S3 encryption client

Use the encryption client created in previous steps to perform operations on Minio server.

```java
    // Create the bucket
    encryptionClient.createBucket(bucketName);

    // Upload object using the encryption client.
    byte[] plaintext = "Hello World, S3 Client-side Encryption Using Asymmetric Master Key!"
      .getBytes();
    System.out.println("plaintext's length: " + plaintext.length);
    encryptionClient.putObject(new PutObjectRequest(bucketName, objectKey,
    new ByteArrayInputStream(plaintext), new ObjectMetadata()));
```

### 4. Test

Once the object is downloaded, check if the decrypted object is same as the plaintext object uploaded to the server.

```java
    // Download the object
    S3Object downloadedObject = encryptionClient.getObject(bucketName,
    objectKey);
    byte[] decrypted = IOUtils.toByteArray(downloadedObject
    .getObjectContent());

    // Verify same data.
    Assert.assertTrue(Arrays.equals(plaintext, decrypted));
```

Complete working code for Symmetric AES encryption can be found [here](./sample-code/aws-sdk-java-encryption-code/symmetric-AES/)

## Asymmetric Encryption

Asymmetric Encryption uses public key and private key for encryption and decryption. Following are the steps involved for Asymmetric Encryption using [RSA](https://en.wikipedia.org/wiki/RSA_(cryptosystem)) :

### 1. Generate RSA key

```java
    // Generate RSA key pair
    KeyPairGenerator keyGenerator = KeyPairGenerator.getInstance(algorithm);
    keyGenerator.initialize(1024, srand);
    keyGenerator.generateKeyPair();
```

### 2. Create AWS S3 encryption client using generated key.

```java
    EncryptionMaterials encryptionMaterials = new EncryptionMaterials(
      loadedKeyPair);

    // Add Minio server accessKey and secretKey
    AWSCredentials credentials = new BasicAWSCredentials("USWUXHGYZQYFYFFIT3RE",
      "MOJRH0mkL1IPauahWITSVvyDrQbEEIwljvmxdq03");	   

    // Create encryption client with Minio server as endpoint   
    AmazonS3EncryptionClient encryptionClient = new AmazonS3EncryptionClient(
      credentials, new StaticEncryptionMaterialsProvider(encryptionMaterials));
    Region usEast1 = Region.getRegion(Regions.US_EAST_1);
    encryptionClient.setRegion(usEast1);
    encryptionClient.setEndpoint("http://localhost:9000");
```

### 3. Operations on Minio using AWS S3 encryption client

Use the encryption client created in previous steps to perform operations on Minio server.

```java
    // Create the bucket
    encryptionClient.createBucket(bucketName);

    // Upload the object.
    byte[] plaintext = "Hello World, S3 Client-side Encryption Using Asymmetric Master Key!"
      .getBytes();
    System.out.println("plaintext's length: " + plaintext.length);
    encryptionClient.putObject(new PutObjectRequest(bucketName, objectKey,
    new ByteArrayInputStream(plaintext), new ObjectMetadata()));
```

### 4. Test

Once the object is downloaded, check if the decrypted object is same as the plaintext object uploaded to the server.

```java
    // Download the object
    S3Object downloadedObject = encryptionClient.getObject(bucketName,
      objectKey);
    byte[] decrypted = IOUtils.toByteArray(downloadedObject
      .getObjectContent());
    Assert.assertTrue(Arrays.equals(plaintext, decrypted));

    // Verify same data.
    System.out.println("decrypted length: " + decrypted.length);
```

Complete working code for Asymmetric RSA encryption can be found [here](./sample-code/aws-sdk-java-encryption-code/asymmetric-RSA/)

*Note*: When Minio generates a presignedURL it would be generated for an encrypted object. So, downloading this object through other methods like curl you would get an encrypted object. This is because curl has no awareness of encryption details.
