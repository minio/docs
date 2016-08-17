# How to use AWS SDK for Go with Minio Server [![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/minio/minio?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

`aws-sdk-go` is the official AWS SDK for the Go programming language. In this recipe we will learn how to use `aws-sdk-go` with Minio server.


## 1. Prerequisites

Install Minio Server from [here](http://docs.minio.io/docs/minio).
 
## 2. Installation

Install ``aws-sdk-go`` from AWS SDK for Go official docs [here](https://aws.amazon.com/sdk-for-go/)


## 3. Example

Please replace ``Endpoint``,``Credentials``, ``Bucket`` with your local setup in this ``example.go`` file.

Example below shows putObject and getObject operations on Minio server using aws-sdk-go.

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
	bucket := "newbucket"
	key := "testobject"
	// Configure to use Minio Server
	s3Config := &aws.Config{
		Credentials:      credentials.NewStaticCredentials("H5K8172RVM311Q2XFEHX", "5bRnl3DGhNM+fRBMxOii11k8iT78cNSIfoqnJfwC", ""),
		Endpoint:         aws.String("http://localhost:9000"),
		Region:           aws.String("us-east-1"),
		DisableSSL:       aws.Bool(true),
		S3ForcePathStyle: aws.Bool(true),
	}
	newSession := session.New(s3Config)

	s3Client := s3.New(newSession)

	cparams := &s3.CreateBucketInput{
		Bucket: &bucket, // Required
	}

	// Create a new bucket using the CreateBucket call.
	_, err := s3Client.CreateBucket(cparams)
	if err != nil {
		// Message from an error.
		fmt.Println(err.Error())
		return
	}

	// Upload a new object "testobject" with the string "Hello World!" to our "newbucket".
	_, err = s3Client.PutObject(&s3.PutObjectInput{
		Body:   strings.NewReader("Hello from Minio!!"),
		Bucket: &bucket,
		Key:    &key,
	})
	if err != nil {
		fmt.Printf("Failed to upload data to %s/%s, %s\n", bucket, key, err.Error())
		return
	}
	fmt.Printf("Successfully created bucket %s and uploaded data with key %s\n", bucket, key)

	// Retrieve our "testobject" from our "newbucket" and store it locally in "testobject_local".
	file, err := os.Create("testobject_local")
	if err != nil {
	    fmt.Println("Failed to create file", err)
		return
	}
	defer file.Close()
	
	downloader := s3manager.NewDownloader(newSession)
	numBytes, err := downloader.Download(file,
	&s3.GetObjectInput{
		Bucket: aws.String(bucket),
		Key:    aws.String(key),
	})
	if err != nil {
		fmt.Println("Failed to download file", err)
		return
	}
	fmt.Println("Downloaded file", file.Name(), numBytes, "bytes")
}
```

## 4. Run the Program

```sh
$ go run example.go
Successfully created bucket newbucket and uploaded data with key testobject
Downloaded file testobject_local 18 bytes
```
