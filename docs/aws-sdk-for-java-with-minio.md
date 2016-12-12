# How to use AWS SDK for Java with Minio Server [![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/minio/minio?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

`aws-sdk-java` is the official AWS SDK for the Java programming language. In this recipe we will learn how to use `aws-sdk-java` with Minio server.

## 1. Prerequisites

Install Minio Server from [here](http://docs.minio.io/docs/minio).
 
## 2. Installation

Install `aws-sdk-java` from AWS SDK for Java official docs [here](https://aws.amazon.com/sdk-for-java/), for this document we are using the aws-sdk-java [ZIP](https://sdk-for-java.amazonwebservices.com/latest/aws-java-sdk.zip)

## 3. Example

Replace ``aws-java-sdk-1.11.43/samples/AmazonS3/S3Sample.java`` with code below and update ``Endpoint``,``BasicAWSCredentials``, ``bucketName``, ``uploadFileName`` and ``keyName`` with your local setup. 

Example below shows upload and download object operations on Minio server using aws-sdk-java.

```java
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.BufferedReader;

import com.amazonaws.regions.Region;
import com.amazonaws.regions.Regions;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.services.s3.S3ClientOptions;
import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.ClientConfiguration;

import com.amazonaws.AmazonClientException;
import com.amazonaws.AmazonServiceException;
import com.amazonaws.auth.profile.ProfileCredentialsProvider;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.amazonaws.services.s3.model.GetObjectRequest;
import com.amazonaws.services.s3.model.S3Object;
import static com.amazonaws.SDKGlobalConfiguration.DISABLE_CERT_CHECKING_SYSTEM_PROPERTY;

public class S3Sample {
    private static String bucketName     = "testbucket";
    private static String keyName        = "hosts";
    private static String uploadFileName = "/etc/hosts";

    public static void main(String[] args) throws IOException {
    AWSCredentials credentials = new BasicAWSCredentials("YOUR-ACCESSKEYID",
                                 "YOUR-SECRETACCESSKEY");
    ClientConfiguration clientConfiguration = new ClientConfiguration();
    clientConfiguration.setSignerOverride("AWSS3V4SignerType");
    AmazonS3 s3Client = new AmazonS3Client(credentials, clientConfiguration);
    Region usEast1 = Region.getRegion(Regions.US_EAST_1);
    s3Client.setRegion(usEast1);
    s3Client.setEndpoint("http://localhost:9000");
    final S3ClientOptions clientOptions = S3ClientOptions.builder().setPathStyleAccess(true).build();
    s3Client.setS3ClientOptions(clientOptions);

    try {
        System.out.println("Uploading a new object to S3 from a file\n");
        File file = new File(uploadFileName);
        // Upload file
        s3Client.putObject(new PutObjectRequest(bucketName, keyName, file));

        // Download file
        GetObjectRequest rangeObjectRequest = new GetObjectRequest(bucketName, keyName);
        S3Object objectPortion = s3Client.getObject(rangeObjectRequest);
        System.out.println("Printing bytes retrieved:");
        displayTextInputStream(objectPortion.getObjectContent());
    } catch (AmazonServiceException ase) {
        System.out.println("Caught an AmazonServiceException, which " +
                   "means your request made it " +
                                       "to Amazon S3, but was rejected with an error response" +
                   " for some reason.");
        System.out.println("Error Message:    " + ase.getMessage());
        System.out.println("HTTP Status Code: " + ase.getStatusCode());
        System.out.println("AWS Error Code:   " + ase.getErrorCode());
        System.out.println("Error Type:       " + ase.getErrorType());
        System.out.println("Request ID:       " + ase.getRequestId());

    } catch (AmazonClientException ace) {
        System.out.println("Caught an AmazonClientException, which " +
                   "means the client encountered " +
                                       "an internal error while trying to " +
                                       "communicate with S3, " +
                   "such as not being able to access the network.");
        System.out.println("Error Message: " + ace.getMessage());

    }

    }

    private static void displayTextInputStream(InputStream input)
    throws IOException {
    // Read one text line at a time and display.
    BufferedReader reader = new BufferedReader(new InputStreamReader(input));
    while (true) {
        String line = reader.readLine();
        if (line == null) break;

        System.out.println("    " + line);
    }
    System.out.println();       
    }
}

```

## 4. Run the Program

```
$ ant
Buildfile: /home/ubuntu/aws-java-sdk-1.11.43/samples/AmazonS3/build.xml

run:
     [java] Uploading a new object to S3 from a file
     [java] 
     [java] Printing bytes retrieved:
     [java]     127.0.0.1       localhost
     [java]     127.0.1.1       minio
     [java]     
     [java]     # The following lines are desirable for IPv6 capable hosts
     [java]     ::1     localhost ip6-localhost ip6-loopback
     [java]     ff02::1 ip6-allnodes
     [java]     ff02::2 ip6-allrouters
     [java] 

BUILD SUCCESSFUL
Total time: 3 seconds

```
## 5. Explore Further

* [Minio Java Library for Amazon S3](https://docs.minio.io/docs/java-client-quickstart-guide)
