# AWS Go SDK for Minio Server [![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/minio/minio?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

`aws-sdk-go` is the official AWS SDK for the Go programming language. In this recipe we will learn how to use `aws-sdk-go` with Minio server.


## 1. Prerequisites

Install Minio Server from [here](http://docs.minio.io/docs/minio).
 
## 2. Installation

Install `aws-sdk-go` by: 

```sh


$ go get github.com/aws/aws-sdk-go/...


```

## 3. Example

Access credentials shown in this example belong to https://play.minio.io:9000.
These credentials are open to public. Feel free to use this service for testing and development. Replace with your own Minio keys in deployment.

List all buckets on minio server using aws-sdk-go.

```go

package main

import (
	"fmt"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/credentials"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
)

func main() {
	newSession := session.New()

  // Configure to use Minio Server
	s3Config := &aws.Config{
		Credentials:      credentials.NewStaticCredentials("Q3AM3UQ867SPQQA43P2F", "zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG", ""),
		Endpoint:         aws.String("https://play.minio.io:9000"),
		Region:           aws.String("us-east-1"),
		DisableSSL:       aws.Bool(true),
		S3ForcePathStyle: aws.Bool(true),
	}
  
	// Create an S3 service object in the default region.
	s3Client := s3.New(newSession, s3Config)

	cparams := &s3.CreateBucketInput{
		Bucket: aws.String("newbucket"), // Required
	}
    
  // Create a new bucket using the CreateBucket call.
	_, err := s3Client.CreateBucket(cparams)
	if err != nil {
		// Message from an error.
		fmt.Println(err.Error())
		return
	}

	var lparams *s3.ListBucketsInput
	
  // Call the ListBuckets() Operation
	resp, err := s3Client.ListBuckets(lparams)
	if err != nil {
		// Message from an error.
		fmt.Println(err.Error())
		return
	}

	// Pretty-print the response data.
	fmt.Println(resp)
}

```

## 3. Run the Program

```sh

$ go run aws-sdk-minio.go
{
  Buckets: [{
      CreationDate: 2015-10-22 01:46:04 +0000 UTC,
      Name: "newbucket"
    }],
  Owner: {
    DisplayName: "minio",
    ID: "minio"
  }
}

```
