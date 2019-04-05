# 如何使用AWS SDK for Go操作MinIO Server [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

`aws-sdk-go`是GO语言版本的官方AWS SDK。本文将学习如何使用`aws-sdk-go`来操作MinIO Server。

## 1. 前提条件

从[这里](https://docs.min.io/docs/minio-quickstart-guide)下载并安装MinIO Server。
 
## 2. 安装

从[AWS SDK for GO官方文档](https://aws.amazon.com/sdk-for-go/)下载将安装`aws-sdk-go`。

## 3. 示例

替换``example.go``文件中的``Endpoint``,``Credentials``, ``Bucket``配置成你的本地配置。

下面的示例讲的是如何使用aws-sdk-go从MinIO Server上putObject和getObject。

```go
package main

import (
	"fmt"
	"os"
	"strings"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/credentials"
	"github.com/aws/aws-sdk-go/service/s3/s3manager"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
)

func main() {
	bucket := aws.String("newbucket")
	key := aws.String("testobject")
	
	//  配置成使用MinIO Server。
	s3Config := &aws.Config{
		Credentials:      credentials.NewStaticCredentials("YOUR-ACCESSKEYID", "YOUR-SECRETACCESSKEY", ""),
		Endpoint:         aws.String("http://localhost:9000"),
		Region:           aws.String("us-east-1"),
		DisableSSL:       aws.Bool(true),
		S3ForcePathStyle: aws.Bool(true),
	}
	newSession := session.New(s3Config)

	s3Client := s3.New(newSession)

	cparams := &s3.CreateBucketInput{
		Bucket: bucket, // 必须
	}

	// 调用CreateBucket创建一个新的存储桶。
	_, err := s3Client.CreateBucket(cparams)
	if err != nil {
		// 错误信息
		fmt.Println(err.Error())
		return
	}

	// 上传一个新的文件"testobject"到存储桶"newbucket",内容是"Hello World!" 。
	_, err = s3Client.PutObject(&s3.PutObjectInput{
		Body:   strings.NewReader("Hello from MinIO!!"),
		Bucket: bucket,
		Key:    key,
	})
	if err != nil {
		fmt.Printf("Failed to upload data to %s/%s, %s\n", *bucket, *key, err.Error())
		return
	}
	fmt.Printf("Successfully created bucket %s and uploaded data with key %s\n", *bucket, *key)

	// 从 "newbucket"里获取文件"testobject"，并保存到本地文件"testobject_local"。
	file, err := os.Create("testobject_local")
	if err != nil {
	    fmt.Println("Failed to create file", err)
		return
	}
	defer file.Close()
	
	downloader := s3manager.NewDownloader(newSession)
	numBytes, err := downloader.Download(file,
	&s3.GetObjectInput{
		Bucket: bucket,
		Key:    key,
	})
	if err != nil {
		fmt.Println("Failed to download file", err)
		return
	}
	fmt.Println("Downloaded file", file.Name(), numBytes, "bytes")
}
```

## 4. 运行程序

```sh
go run example.go
Successfully created bucket newbucket and uploaded data with key testobject
Downloaded file testobject_local 18 bytes
```
