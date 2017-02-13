# How to use AWS SDK for .NET with Minio Server [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

`aws-sdk-dotnet` is the official AWS SDK for the .NET Framework. In this recipe we will learn how to use `aws-sdk-dotnet` with Minio server.

## 1. Prerequisites

Install Minio Server from [here](http://docs.minio.io/docs/minio).
Install Visual Studio 2015 or Visual Studio 2017. Find installation of Visual Studio 2015 Community edition [here](https://www.visualstudio.com/downloads/).
 
## 2. Installation

`aws-sdk-dotnet` installation is available as [Nuget package](https://www.nuget.org/packages/AWSSDK.S3/). This package contains only libraries that are necessary for work with AWS S3. 
Installation of the Nuget package is performed using "Manage Nuget Packages..." UI or by using Nuget Manager Console by typing ``Install-Package AWSSDK.S3``. The installation will automatically download the library for the .NET platform which is compatible with your project. The package exists for .NET Frameworks 3.5 and 4.5 and also for .NET Core 1.1.
The older (version 2) package is also [available](https://www.nuget.org/packages/AWSSDK/), but it delivers _all_ libraries and not only S3 specific modules.

## 3. Example

The example is intended to run under VisualStudio development environment. Create a simple console project and replace ``Program.cs`` with code below and update ``ServiceURL``,``accessKey``,``secretKey``,``bucketName`` and ``keyName`` with your local setup. 

Example below shows getting a list of buckets and objects from Minio server using aws-sdk-dotnet.

```dotnet
using Amazon.S3;
using System;

class Program
{
    private const string accessKey = "PLACE YOUR ACCESS KEY HERE";
    private const string secretKey = "PLACE YOUR SECRET KEY HERE"; // do not store secret key hardcoded in your production source code!
    
    static void Main(string[] args)
    {
        var amazonS3Client = new AmazonS3Client(accessKey, secretKey, new AmazonS3Config { ServiceURL = "http://localhost:9000", ForcePathStyle = true }); // replace http://localhost:9000 with URL of your minio server

        // uncomment the following line if you like to troubleshoot communication with S3 storage and implement private void OnAmazonS3Exception(object sender, Amazon.Runtime.ExceptionEventArgs e)
        // amazonS3Client.ExceptionEvent += OnAmazonS3Exception;

        var task = amazonS3Client.ListBucketAsync();
        task.Wait();

        foreach(var bucket in task.Result.Buckets)
        {
            Console.Out.WriteLine("bucket '" + bucket.BucketName + "' created at " + bucket.CreationTime);
        }
        if (task.Result.Buckets.Count > 0)
        {
            var bucketName = task.Result.Buckets[0].BucketName;

            var task2 = amazonS3Client.ListObjectsAsync(bucketName);
            task2.Wait();

            foreach(var obj in task2.Result.S3Objects)
            {
                Console.Out.WriteLine("key = '" + obj.Key+ "' | size = " + obj.Size + " | tags = '" + obj.ETag + "' | modified = " + obj.LastModified);
            }
        }
    }
}

```
The above example is using asynchronous API synchronously for the matter of example. The ``AmazonS3Config`` setting ``ForcePathStyle = true`` is essential in order to work correctly with Minio server.

## 5. Explore Further

* [AWS SDK for .NET](https://aws.amazon.com/sdk-for-net/)
* [Configuring AWS SDK with .NET Core](https://aws.amazon.com/blogs/developer/configuring-aws-sdk-with-net-core/)
* [Amazon S3 for DotNet documentation](http://docs.aws.amazon.com/sdkfornet/v3/apidocs/Index.html)
