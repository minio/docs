# Apache Spark with Minio Server [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

Apache Spark is a fast and general engine for large-scale data processing. In this recipe we'll see how to launch jobs on Apache Spark-Shell that reads/writes data to a Minio server.

## 1. Prerequisites

- Install Minio Server from [here](http://docs.minio.io/docs/minio-quickstart-guide).
- Download Apache Spark version `spark-2.1.2-bin-without-hadoop` from [here](https://www.apache.org/dist/spark/spark-2.1.2/spark-2.1.2-bin-without-hadoop.tgz).
- Download Apache Hadoop version `hadoop-2.8.2` from [here](https://www.apache.org/dist/hadoop/core/hadoop-2.8.2/hadoop-2.8.2.tar.gz).
- Download other dependencies
    - [`Hadoop 2.8.2`](https://mvnrepository.com/artifact/org.apache.hadoop/hadoop-aws/2.8.2)
    - [`HttpClient 4.5.3`](https://mvnrepository.com/artifact/org.apache.httpcomponents/httpclient/4.5.3)
    - [`Joda Time 2.9.9`](https://mvnrepository.com/artifact/joda-time/joda-time/2.9.9)
    - [`AWS SDK For Java Core 1.11.234`](https://mvnrepository.com/artifact/com.amazonaws/aws-java-sdk-core/1.11.234)
    - [`AWS SDK For Java 1.11.234`](https://mvnrepository.com/artifact/com.amazonaws/aws-java-sdk/1.11.234)
    - [`AWS Java SDK For AWS KMS 1.11.234`](http://mvnrepository.com/artifact/com.amazonaws/aws-java-sdk-kms/1.11.234)
    - [`AWS Java SDK For Amazon S3 1.11.234`](https://mvnrepository.com/artifact/com.amazonaws/aws-java-sdk-s3/1.11.234)

## 2. Installation

- Extract the `spark-2.1.2-bin-without-hadoop` tar ball in the directory where you're planning to install Spark.
- Extract the `hadoop-2.8.2` tar ball in a separate directory. Copy the path to this directory.
- Create a directory called `bin` inside the directory where `spark-2.1.2-bin-without-hadoop` was unzipped. Then move all the dependency jar files (downloaded in previous step) in this directory.

## 3. Start Spark-Shell

Navigate to the directory where you extracted `spark-2.1.2-bin-without-hadoop`, and set the following environment variables:

```sh
export HADOOP_HOME=/path/to/hadoop-2.8.2
export PATH=$PATH:$HADOOP_HOME/bin
export SPARK_DIST_CLASSPATH=$(hadoop classpath)
```

Then, open the file `$HADOOP_HOME/etc/hadoop/core-site.xml` for editing. In this example Minio server is running at `http://127.0.0.1:9000` with access key `minio` and secret key `minio123`. Make sure to update relevant sections with valid Minio server endpoint and credentials.


```xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<configuration>
  <property>
    <name>fs.s3a.endpoint</name>
    <description>AWS S3 endpoint to connect to. An up-to-date list is
      provided in the AWS Documentation: regions and endpoints. Without this
      property, the standard region (s3.amazonaws.com) is assumed.
    </description>
    <value>http://127.0.0.1:9000</value>
  </property>

  <property>
    <name>fs.s3a.access.key</name>
    <description>AWS access key ID.</description>
    <value>minio</value>
  </property>

  <property>
    <name>fs.s3a.secret.key</name>
    <description>AWS secret key.</description>
    <value>minio123</value>
  </property>

  <property>
    <name>fs.s3a.path.style.access</name>
    <value>true</value>
    <description>Enable S3 path style access ie disabling the default virtual hosting behaviour.
      Useful for S3A-compliant storage providers as it removes the need to set up DNS for virtual hosting.
    </description>
  </property>

  <property>
    <name>fs.s3a.impl</name>
    <value>org.apache.hadoop.fs.s3a.S3AFileSystem</value>
    <description>The implementation class of the S3A Filesystem</description>
  </property>
</configuration>

```

Then start Spark-Shell by

```sh
./bin/spark-shell --master local[4] --jars "../bin/hadoop-aws-2.8.2.jar,../bin/httpclient-4.5.3.jar,../bin/aws-java-sdk-core-1.11.234.jar,../bin/aws-java-sdk-kms-1.11.234.jar,../bin/aws-java-sdk-1.11.234.jar,../bin/aws-java-sdk-s3-1.11.234.jar,../bin/joda-time-2.9.9.jar"
```

You should see the prompt

```sh
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /___/ .__/\_,_/_/ /_/\_\   version 2.1.2
      /_/
         
Using Scala version 2.11.8 (OpenJDK 64-Bit Server VM, Java 1.8.0_151)
Type in expressions to have them evaluated.
Type :help for more information.

scala> 
```

## 4. Test if Spark-Shell can communicate with Minio server

### Read

For this recipe, Minio server is running on `http://127.0.0.1:9000`. To test if read works on Spark-Shell, create a bucket called `spark-test` on your Minio server and upload a test file. Here is
how to do this with `mc`

```sh
mc config host add myminio http://127.0.0.1:9000 minio minio123
mc mb myminio/spark-test
mc cp test.json myminio/spark-test/test.json
```

Now, switch to the Spark-Shell terminal and type

```sh
val b1 = sc.textFile("s3a://spark-test/test.json")
b1.collect().foreach(println)
```

You should be able to see the text file you uploaded to Minio server.

### Write

To test if Spark-Shell can write back to Minio server, switch to Spark-Shell terminal and run 

```sh
import spark.implicits._
val data = Array(1, 2, 3, 4, 5)
val distData = sc.parallelize(data)
distData.saveAsTextFile("s3a://spark-test/test-write")
```

You should see a prefix called `test-write` created inside the bucket `spark-test`. The data is written under the `test-write` prefix.

### Minio server configured with HTTPS

In case you are planning to use self-signed certificates for testing purposes, you'll need to add these certificates to local JRE `cacerts`. You can do this using

```sh
keytool -import -trustcacerts -keystore $JAVA_HOME/jre/lib/security/cacerts -storepass changeit -noprompt -alias mycert -file /home/username/.minio/certs/public.crt
```

Also, change the scheme to `https` in `fs.s3a.endpoint` in file `$HADOOP_HOME/etc/hadoop/core-site.xml`.