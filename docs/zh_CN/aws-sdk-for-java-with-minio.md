# 如何使用AWS SDK for Java操作MinIO Server [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

`aws-sdk-java`是Java语言版本的官方AWS SDK。本文我们将学习如何使用`aws-sdk-java`操作MinIO Server。

## 1. 前提条件

从[这里](https://docs.min.io/docs/minio-quickstart-guide)下载并安装MinIO Server。

## 2. 设置依赖

你可以参考[AWS Java SDK文档](https://aws.amazon.com/sdk-for-java/)下载并安装[aws-java-sdk](https://sdk-for-java.amazonwebservices.com/latest/aws-java-sdk.zip)，或者使用Apache Maven来获得相应的依赖。

```xml
…
	<properties>
		<project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
		<aws.sdk.version>1.11.106</aws.sdk.version>
	</properties>

	<dependencyManagement>
		<dependencies>
			<dependency>
				<groupId>com.amazonaws</groupId>
				<artifactId>aws-java-sdk-bom</artifactId>
				<version>${aws.sdk.version}</version>
				<type>pom</type>
				<scope>import</scope>
			</dependency>
		</dependencies>
	</dependencyManagement>

	<dependencies>
		<dependency>
			<groupId>com.amazonaws</groupId>
			<artifactId>aws-java-sdk-s3</artifactId>
		</dependency>
	</dependencies>

	<build>
		<plugins>
			<plugin>
				<groupId>org.apache.maven.plugins</groupId>
				<artifactId>maven-compiler-plugin</artifactId>
				<configuration>
					<source>1.8</source>
					<target>1.8</target>
				</configuration>
			</plugin>
		</plugins>
	</build>
…
```

## 3. 示例

使用下面的代码替换``aws-java-sdk-1.11.213/samples/AmazonS3/S3Sample.java``，并且修改``Endpoint``，``BasicAWSCredentials``，``bucketName``，``uploadFileName``和``keyName``成你的本地配置。

下面的示例描述的是如何使用asw-sdk-java来对MinIO Server进行上传和下载操作。

```java
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

import com.amazonaws.AmazonClientException;
import com.amazonaws.AmazonServiceException;
import com.amazonaws.ClientConfiguration;
import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.client.builder.AwsClientBuilder;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.GetObjectRequest;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.amazonaws.services.s3.model.S3Object;

public class S3Sample {
	private static String bucketName = "testbucket";
	private static String keyName = "hosts";
	private static String uploadFileName = "/etc/hosts";

	public static void main(String[] args) throws IOException {
		AWSCredentials credentials = new BasicAWSCredentials("YOUR-ACCESSKEYID", "OUR-SECREYTACCESSKEY");
		ClientConfiguration clientConfiguration = new ClientConfiguration();
		clientConfiguration.setSignerOverride("AWSS3V4SignerType");

		AmazonS3 s3Client = AmazonS3ClientBuilder
				.standard()
				.withEndpointConfiguration(new AwsClientBuilder.EndpointConfiguration("http://localhost:9000", Regions.US_EAST_1.name()))
				.withPathStyleAccessEnabled(true)
				.withClientConfiguration(clientConfiguration)
				.withCredentials(new AWSStaticCredentialsProvider(credentials))
				.build();

		try {
			System.out.println("Uploading a new object to S3 from a file\n");
			File file = new File(uploadFileName);
			// 上传文件
			s3Client.putObject(new PutObjectRequest(bucketName, keyName, file));

			// 下载文件
			GetObjectRequest rangeObjectRequest = new GetObjectRequest(bucketName, keyName);
			S3Object objectPortion = s3Client.getObject(rangeObjectRequest);
			System.out.println("Printing bytes retrieved:");
			displayTextInputStream(objectPortion.getObjectContent());
		} catch (AmazonServiceException ase) {
			System.out.println("Caught an AmazonServiceException, which " + "means your request made it "
					+ "to Amazon S3, but was rejected with an error response" + " for some reason.");
			System.out.println("Error Message:    " + ase.getMessage());
			System.out.println("HTTP Status Code: " + ase.getStatusCode());
			System.out.println("AWS Error Code:   " + ase.getErrorCode());
			System.out.println("Error Type:       " + ase.getErrorType());
			System.out.println("Request ID:       " + ase.getRequestId());

		} catch (AmazonClientException ace) {
			System.out.println("Caught an AmazonClientException, which " + "means the client encountered " + "an internal error while trying to "
					+ "communicate with S3, " + "such as not being able to access the network.");
			System.out.println("Error Message: " + ace.getMessage());

		}

	}

	private static void displayTextInputStream(InputStream input) throws IOException {
		// 按行读取并打印。
		BufferedReader reader = new BufferedReader(new InputStreamReader(input));
		while (true) {
			String line = reader.readLine();
			if (line == null)
				break;

			System.out.println("    " + line);
		}
		System.out.println();
	}
}
```

## 4. 运行程序

```sh
ant
Buildfile: /home/ubuntu/aws-java-sdk-1.11.213/samples/AmazonS3/build.xml

run:
     [java] Uploading a new object to S3 from a file
     [java]
     [java] Printing bytes retrieved:
     [java]     127.0.0.1       localhost
     [java]     127.0.1.1       minio
     [java]     
     [java]     # 对于支持IPv6的主机，会有以下几行输出。
     [java]     ::1     localhost ip6-localhost ip6-loopback
     [java]     ff02::1 ip6-allnodes
     [java]     ff02::2 ip6-allrouters
     [java]

BUILD SUCCESSFUL
Total time: 3 seconds
```
## 5. 了解更多

* [MinIO Java Library for Amazon S3](https://docs.min.io/docs/java-client-quickstart-guide)
