# 部署Apache Spark结合MinIO Server [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)
Apache Spark是用于快速处理大规模数据的通用引擎。 在本文中，我们将学习如何在Apache Spark-Shell上启动作业，将数据读写到MinIO Server。

## 1. 前提条件
- 从[这里](https://docs.min.io/docs/minio-quickstart-guide)下载并安装MinIO Server。
- 从[这里](https://www.apache.org/dist/spark/spark-2.1.2/spark-2.1.2-bin-without-hadoop.tgz)下载Apache Spark版本 `spark-2.1.2-bin-without-hadoop`。
- 从[这里](https://www.apache.org/dist/hadoop/core/hadoop-2.8.2/hadoop-2.8.2.tar.gz)下载Apache Hadoop版本 `hadoop-2.8.2`。
- 下载其它依赖
  - [`Hadoop 2.8.2`](https://mvnrepository.com/artifact/org.apache.hadoop/hadoop-aws/2.8.2)
  - [`HttpClient 4.5.3`](https://mvnrepository.com/artifact/org.apache.httpcomponents/httpclient/4.5.3)
  - [`Joda Time 2.9.9`](https://mvnrepository.com/artifact/joda-time/joda-time/2.9.9)
  - [`AWS SDK For Java Core 1.11.234`](https://mvnrepository.com/artifact/com.amazonaws/aws-java-sdk-core/1.11.234)
  - [`AWS SDK For Java 1.11.234`](https://mvnrepository.com/artifact/com.amazonaws/aws-java-sdk/1.11.234)
  - [`AWS Java SDK For AWS KMS 1.11.234`](http://mvnrepository.com/artifact/com.amazonaws/aws-java-sdk-kms/1.11.234)
  - [`AWS Java SDK For Amazon S3 1.11.234`](https://mvnrepository.com/artifact/com.amazonaws/aws-java-sdk-s3/1.11.234)

## 2. 安装

- 将`spark-2.1.2-bin-without-hadoop`解压到你想安装Spark的目录。
- 将`hadoop-2.8.2`解压到另外的目录，拷贝该目录的路径。
- 在`spark-2.1.2-bin-without-hadoop`的解压目录下创建一个`bin`的子目录，然后将之前步骤下载的所有的依赖jar包拷贝到该目录下。

## 3. 启动Spark-Shell

进入`spark-2.1.2-bin-without-hadoop`的解压目录，设置以下环境变量：

```sh
export HADOOP_HOME=/path/to/hadoop-2.8.2
export PATH=$PATH:$HADOOP_HOME/bin
export SPARK_DIST_CLASSPATH=$(hadoop classpath)
```

然后打开`$HADOOP_HOME/etc/hadoop/core-site.xml`进行编辑。在本示例中，MinIO Server运行在`http://127.0.0.1:9000`，access key是`minio`,secret key是`minio123`，请根据你的实际值进行修改。


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

然后启动Spark-Shell

```sh
./bin/spark-shell --master local[4] --jars "../bin/hadoop-aws-2.8.2.jar,../bin/httpclient-4.5.3.jar,../bin/aws-java-sdk-core-1.11.234.jar,../bin/aws-java-sdk-kms-1.11.234.jar,../bin/aws-java-sdk-1.11.234.jar,../bin/aws-java-sdk-s3-1.11.234.jar,../bin/joda-time-2.9.9.jar"
```

你应该看到如下提示信息

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

## 4. 测试Spark-Shell是否能操作MinIO server

### 读

在本示例中，MinIO Server是运行在`http://127.0.0.1:9000`.要测试Spark-Shell是否可以正常读，请在你的MinIO Server上创建一个名为`spark-test`的存储桶，然后上传一个测试文件。以下是使用`mc`操作的示例

```sh
mc config host add myminio http://127.0.0.1:9000 minio minio123
mc mb myminio/spark-test
mc cp test.json myminio/spark-test/test.json
```

然后，切换到Spark-Shell terminal，输入

```sh
val b1 = sc.textFile("s3a://spark-test/test.json")
b1.collect().foreach(println)
```

你应该可以看到你刚上传的文本文件。

### 写

为了测试Spark-Shell是否可以写数据到MinIO Server,请切换到Spark-Shell terminal,然后运行

```sh
import spark.implicits._
val data = Array(1, 2, 3, 4, 5)
val distData = sc.parallelize(data)
distData.saveAsTextFile("s3a://spark-test/test-write")
```

你应该可以看见在`spark-test`存储桶下创建一了一个名为`test-write`的对象，数据是写入到该文件中。

### MinIO server使用HTTPS

如果你想使用自签名的证书来进行测试，你需要将这些证书添加到本地的JRE `cacerts`目录下。请参考以下脚本

```sh
keytool -import -trustcacerts -keystore $JAVA_HOME/jre/lib/security/cacerts -storepass changeit -noprompt -alias mycert -file /home/username/.minio/certs/public.crt
```

然后，将文件`$HADOOP_HOME/etc/hadoop/core-site.xml`中`fs.s3a.endpoint`的scheme改为`https`。
