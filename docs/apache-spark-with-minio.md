# Apache Spark with MinIO Server [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

Apache Spark is a fast and general engine for large-scale data processing. In this recipe we'll see how to launch jobs on Apache Spark-Shell that reads/writes data to a MinIO server.

## 1. Prerequisites

- Install MinIO Server from [here](https://docs.min.io/docs/minio-quickstart-guide).
- Download Apache Spark version `spark-2.4.4-bin-without-hadoop` from [here](https://www.apache.org/dyn/closer.lua/spark/spark-2.4.4/spark-2.4.4-bin-without-hadoop.tgz).
- Download Apache Hadoop version `hadoop-2.8.2` from [here](https://archive.apache.org/dist/hadoop/core/hadoop-2.8.2/hadoop-2.8.2.tar.gz).
- Download other dependencies
  - [`Hadoop 2.8.2`](https://mvnrepository.com/artifact/org.apache.hadoop/hadoop-aws/2.8.2)
  - [`HttpClient 4.5.3`](https://mvnrepository.com/artifact/org.apache.httpcomponents/httpclient/4.5.3)
  - [`Joda Time 2.9.9`](https://mvnrepository.com/artifact/joda-time/joda-time/2.9.9)
  - [`AWS SDK For Java Core 1.11.712`](https://mvnrepository.com/artifact/com.amazonaws/aws-java-sdk-core/1.11.712)
  - [`AWS SDK For Java 1.11.712`](https://mvnrepository.com/artifact/com.amazonaws/aws-java-sdk/1.11.712)
  - [`AWS Java SDK For AWS KMS 1.11.712`](http://mvnrepository.com/artifact/com.amazonaws/aws-java-sdk-kms/1.11.712)
  - [`AWS Java SDK For Amazon S3 1.11.712`](https://mvnrepository.com/artifact/com.amazonaws/aws-java-sdk-s3/1.11.712)

## 2. Installation

- Extract the `spark-2.4.4-bin-without-hadoop` tar ball in the directory where you're planning to install Spark.
- Extract the `hadoop-2.8.2` tar ball in a separate directory. Copy the path to this directory.
- Move all the dependency jar files (downloaded in previous step) in `/path/to/.spark-2.4.4-bin-without-hadoop/jars` directory.

## 3. Start Spark-Shell

Navigate to the directory where you extracted `spark-2.4.4-bin-without-hadoop`, and set the following environment variables:

```sh
export SPARK_HOME=/path/to/spark-2.4.4-bin-without-hadoop
export PATH=$PATH:$SPARK_HOME/bin
export HADOOP_HOME=/path/to/hadoop-2.8.2
export PATH=$PATH:$HADOOP_HOME/bin
export LD_LIBRARY_PATH=$HADOOP_HOME/lib/native
export SPARK_DIST_CLASSPATH=$(hadoop classpath)
```

Now, assuming your MinIO Server is running at `http://localhost:9000`, and Access Key, Secret Key are `minio` and `minio123` respectively, start Spark-Shell

```sh
./bin/spark-shell \
--conf spark.hadoop.fs.s3a.endpoint=http://localhost:9000 \
--conf spark.hadoop.fs.s3a.access.key=minio \
--conf spark.hadoop.fs.s3a.secret.key=minio123 \
--conf spark.hadoop.fs.s3a.path.style.access=true \
--conf spark.hadoop.fs.s3a.impl=org.apache.hadoop.fs.s3a.S3AFileSystem
```

You should see the prompt

```sh
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /___/ .__/\_,_/_/ /_/\_\   version 2.4.4
      /_/

Using Scala version 2.11.12 (Java HotSpot(TM) 64-Bit Server VM, Java 1.8.0_221)
Type in expressions to have them evaluated.
Type :help for more information.

scala>
```

Remember to update the `s3a` related args as per your actual MinIO deployment values.

## 4. Test if Spark-Shell can communicate with MinIO server

### Read Test

For this recipe, MinIO server is running on `http://127.0.0.1:9000`. To test if read works on Spark-Shell, create a bucket called `spark-test` on your MinIO server and upload a test file. Here is how to do this with `mc`

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

You should be able to see the text file you uploaded to MinIO server.

### Write Test

To test if Spark-Shell can write back to MinIO server, switch to Spark-Shell terminal and run

```sh
import spark.implicits._
val data = Array(1, 2, 3, 4, 5)
val distData = sc.parallelize(data)
distData.saveAsTextFile("s3a://spark-test/test-write")
```

You should see a prefix called `test-write` created inside the bucket `spark-test`. The data is written under the `test-write` prefix.

## 5. (Optional) Start Spark-History server

[Spark History Server](https://spark.apache.org/docs/latest/monitoring.html) provides web UI for completed and running Spark applications. Once Spark jobs are configured to log events, the history server displays both completed and incomplete Spark jobs. If an application makes multiple attempts after failures, the failed attempts will be displayed, as well as any ongoing incomplete attempt or the final successful attempt.

MinIO can be used as the storage back-end for Spark history using the `s3a` file system. To enable this, setup the `conf/spark-defaults.conf` file so history server uses `s3a` to store the files. By default the `conf` directory has a `spark-defaults.conf.template` file, make a copy of the template file and rename it to `spark-defaults.conf`. Then add the below content to the file

```sh
spark.jars.packages                 net.java.dev.jets3t:jets3t:0.9.4,com.google.guava:guava:14.0.1,com.amazonaws:aws-java-sdk:1.11.712,org.apache.hadoop:hadoop-aws:2.8.2
spark.eventLog.enabled              true
spark.eventLog.dir                  s3a://spark/
spark.history.fs.logDirectory       s3a://spark/
```

Next step is to add jar files specified under the `spark.jars.packages` section to the `jars` directory. Once the files are added, create a new bucket called `spark` in the MinIO instance. This is because we specified the log directory as `s3a://spark/`. Finally start Spark history server using

```sh
./sbin/start-history-server.sh
```

If everything works fine you should be able to see the console on `http://localhost:18080/`.

## 6. (Optional) MinIO with DeltaLake

Delta Lake provides ACID transactions, scalable metadata handling, and unifies streaming and batch data processing. Delta Lake runs on top of existing data lake (like MinIO) and is fully compatible with Apache Spark APIs. Specifically, Delta Lake offers ACID transactions on Spark, Schema enforcement, Time travel and more. Read details [here](https://docs.delta.io/latest/delta-intro.html).

You can create, read, and write Delta tables on MinIO using the `s3a` connector. To setup Delta Lake with MinIO, you can use the below command

```sh
./bin/spark-shell --packages io.delta:delta-core_2.11:0.5.0 \
--conf spark.delta.logStore.class=org.apache.spark.sql.delta.storage.S3SingleDriverLogStore \
--conf spark.hadoop.fs.s3a.endpoint=http://localhost:9000 \
--conf spark.hadoop.fs.s3a.access.key=minio \
--conf spark.hadoop.fs.s3a.secret.key=minio123 \
--conf spark.hadoop.fs.s3a.path.style.access=true \
--conf spark.hadoop.fs.s3a.impl=org.apache.hadoop.fs.s3a.S3AFileSystem
```

Here, we are using Delta Lake release `0.5.0` with Scala `2.11` release, while the `s3a` fields are based on the MinIO cluster. After you run this and get the Spark console, you can run delta and Spark APIs. Refer Delta Lake [storage configuration docs](https://docs.delta.io/latest/delta-storage.html) here. To test if you can use the delta API, use the commands given below in spark console

```sh
spark.range(5).write.format("delta").save("s3a://spark-test/delta")
```

To check if the reads are working fine, attempt reading the file we created in write test.

```sh
val df = spark.read.format("delta").load("s3a://spark-test/delta")
df.show()
```

## 7. Configuration Notes

### MinIO server configured with HTTPS

In case you are planning to use self-signed certificates for testing purposes, you'll need to add these certificates to local JRE `cacerts`. You can do this using

```sh
keytool -import -trustcacerts -keystore $JAVA_HOME/jre/lib/security/cacerts -storepass changeit -noprompt -alias mycert -file /home/username/.minio/certs/public.crt
```

Also, change the scheme to `https` in `spark.hadoop.fs.s3a.endpoint` field while passing to `spark-shell`.

### MinIO server with custom region

If you're using MinIO with a custom region (instead of default region `us-east-1`), you'll need to use endpoint with relevant region added. For example, if your MinIO server is running with region `ap-southeast-1` at `http://localhost:9000`, then `spark.hadoop.fs.s3a.endpoint` flag should be set to `http://s3.ap-southeast-1.localhost:9000`.

However, please do note that this approach will not work if you're passing MinIO server's IP address in the `spark.hadoop.fs.s3a.endpoint` flag.
