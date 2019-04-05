# 如何使用AWS SDK for .NET操作MinIO Server [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

`aws-sdk-dotnet`是.NET Framework的官方AWS开发工具包。在本文中，我们将学习如何使用`aws-sdk-dotnet`来操作MinIO Server。

## 1. 前提条件

从[这里](https://docs.min.io/docs/minio-quickstart-guide)下载并安装MinIO Server。

如果在本地运行MinIO Server,必须要设置`MINIO_REGION`环境变量。

安装Visual Studio 2015,  Visual Studio 2017或者Visual Studio Code。从[这里](https://www.visualstudio.com/downloads/)查找Visual Studio的安装版本。

## 2. 安装

`aws-sdk-dotnet`有[Nuget](https://www.nuget.org/packages/AWSSDK.S3/)包。此软件包仅包含使用AWS S3所必需的库。Nuget包的安装可以使用"Manage Nuget Packages..." UI，或者使用Nuget管理控制台，输入``Install-Package AWSSDK.S3``。安装程序将自动下载与你的项目兼容的.NET平台的库。.NET Frameworks 3.5、 4.5 以及 .NET Core 1.1都有这个包。

老版本（version 2）的包在[这里](https://www.nuget.org/packages/AWSSDK/)，不过不建议使用，因为它会下载所有的AWS SDK库，而不是只下载S3模块。

## 3. 示例

下面示例的代码应该直接复制，而不是用自动生成的``Program.cs``文件里的代码。在Visual Studio IDE中创建一个控制台项目，并用下面的代码替换生成的``Program.cs``。更新``ServiceURL``,``accessKey`` 和 ``secretKey``成你的MinIO Server的配置。

下面的示例采用`aws-sdk-dotnet`以列举的方式打印出MinIO Server里所有的存储桶和第一个存储桶里的所有对象。

```csharp
using Amazon.S3;
using System;
using System.Threading.Tasks;
using Amazon;

class Program
{
    private const string accessKey = "PLACE YOUR ACCESS KEY HERE";
    private const string secretKey = "PLACE YOUR SECRET KEY HERE"; // 不要把你的秘钥硬编码到你的代码中。

    static void Main(string[] args)
    {
        Task.Run(MainAsync).GetAwaiter().GetResult();
    }

    private static async Task MainAsync()
    {
        var config = new AmazonS3Config
        {
            RegionEndpoint = RegionEndpoint.USEast1, // 必须在设置ServiceURL前进行设置，并且需要和`MINIO_REGION`环境变量一致。
            ServiceURL = "http://localhost:9000", // 替换成你自己的MinIO Server的URL
            ForcePathStyle = true // 必须设为true
        })
        var amazonS3Client = new AmazonS3Client(accessKey, secretKey, config); 

        // 如果你想调试与S3存储的通信的话，可以把下一行代码取消注释，并且实现 private void OnAmazonS3Exception(object sender, Amazon.Runtime.ExceptionEventArgs e)
        // amazonS3Client.ExceptionEvent += OnAmazonS3Exception;

        var listBucketResponse = await amazonS3Client.ListBucketsAsync();

        foreach (var bucket in listBucketResponse.Buckets)
        {
            Console.Out.WriteLine("bucket '" + bucket.BucketName + "' created at " + bucket.CreationDate);
        }
        if (listBucketResponse.Buckets.Count > 0)
        {
            var bucketName = listBucketResponse.Buckets[0].BucketName;

            var listObjectsResponse = await amazonS3Client.ListObjectsAsync(bucketName);

            foreach (var obj in listObjectsResponse.S3Objects)
            {
                Console.Out.WriteLine("key = '" + obj.Key + "' | size = " + obj.Size + " | tags = '" + obj.ETag + "' | modified = " + obj.LastModified);
            }
        }
    }
}
```

## 5. 了解更多

* [AWS SDK for .NET](https://aws.amazon.com/sdk-for-net/)
* [配置 AWS SDK with .NET Core](https://aws.amazon.com/blogs/developer/configuring-aws-sdk-with-net-core/)
* [Amazon S3 for DotNet文档](http://docs.aws.amazon.com/sdkfornet/v3/apidocs/Index.html)
