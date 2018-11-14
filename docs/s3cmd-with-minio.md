# S3cmd with Minio Server [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

`S3cmd` is an open source CLI client for managing data in AWS S3, Google Cloud Storage, or any cloud storage service provider that uses the **s3** protocol. `S3cmd` is distributed under the [GPLv2 License](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html).

This guide describes how to configure `S3cmd` and use it to manage data on Minio Server. These are the steps you will follow:

[1. Install Minio Server](#installminioserver) 
[2. Install `S3cmd`](#installs3cmd) 
[3. Configure `S3cmd`](#configures3cmd) 
[4. Examples of Typical `S3cmd` Commands](#runs3cmdcommands)


## <a name="installminioserver"></a>1. Install Minio Server

Install Minio Server using the instructions in the [Minio Quickstart Guide](http://docs.minio.io/docs/minio-quickstart-guide).

## <a name="installs3cmd"></a>2. Install `S3cmd`

Install `S3cmd` using these instructions: <http://s3tools.org/s3cmd>.

## <a name="configures3cmd"></a>3. Configure `S3cmd`

### 3.1 Generate a Configuration file
`S3cmd` uses a configuration file called **.s3cfg** to access cloud storage. Use the following command to generate the initial version of **.s3cfg**:

```sh
 `./S3cmd --configure`
```

**Note:** Accept the defaults when prompted.

### 3.2 Edit the Configuration File
Modify the configuration file to enable `S3cmd` to manage buckets on https://play.minio.io:9000:

#### 3.2.1. Navigate to **/users/<your user name>** and open **.s3cfg** in a text editor.
#### 3.2.2. Edit the following fields in **.s3cfg** to configure the endpoint:

```sh
bucket_location = us-east-1
host_base = play.minio.io:9000
host_bucket = play.minio.io:9000
use_https = True
```

#### 3.3.3. Edit the following fields in **.s3cfg** to set the access keys:

```sh
access_key =  Q3AM3UQ867SPQQA43P2F
secret_key = zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG
```

#### 3.3.4. Edit the following fields in **.s3cfg** to enable S3 v4 signature APIs:

```sh
signature_v2 = False
```

#### 3.3.5. Save **.s3cfg**.

**Note:** The variables set in this example are for public testing and development on <https://play.minio.io:9000>. Modify these variables as appropriate when developing for your own Minio Server.


## <a name="runs3cmdcommands"></a>4. Examples of Typical `S3cmd` Commands
Navigate to the installation directory for **S3cmd** and invoke the following commands to create and manage a bucket:

### Create a Bucket

```sh
s3cmd mb s3://mybucket
```

You should see a response similar to this one:

```sh
Bucket 's3://mybucket/' created
```

### Copy an Object to the Bucket

```sh
s3cmd put newfile s3://testbucket
```

You should see a response similar to this one:

```sh
upload: 'newfile' -> 's3://testbucket/newfile'  
```

### Copy an Object to the Local File System

```sh
s3cmd get s3://testbucket/newfile
```

You should see a response similar to this one:

```sh
download: 's3://testbucket/newfile' -> './newfile'
```

### Sync a Local File/Directory to a Bucket

```sh
s3cmd sync newdemo s3://testbucket
```

You should see a response similar to this one:

```sh
upload: 'newdemo/newdemofile.txt' -> 's3://testbucket/newdemo/newdemofile.txt'
```

### Sync a Bucket with the Local File System

```sh
s3cmd sync  s3://testbucket otherlocalbucket
```

You should see a response similar to this one:

```sh
download: 's3://testbucket/cat.jpg' -> 'otherlocalbucket/cat.jpg'
```

### List all Buckets

```sh
s3cmd ls s3://
```

You should see a response similar to this one:

```sh
2015-12-09 16:12  s3://testbbucket
```

### List the Contents of a Bucket

```sh
s3cmd ls s3://testbucket/
```

You should see a response similar to this one:

```sh
                                      DIR   s3://testbucket/test/
2015-12-09 16:05    138504   s3://testbucket/newfile
```


### Delete an Object from a Bucket

```sh
s3cmd del s3://testbucket/newfile
```

You should see a response similar to this one:

```sh
delete: 's3://testbucket/newfile'
```

### Delete a Bucket

```sh
s3cmd rb s3://mybucket
```

You should see a response similar to this one:

```sh
Bucket 's3://mybucket/' removed
```

**Note:** The complete usage guide for `S3cmd` is available [here](http://s3tools.org/usage).
