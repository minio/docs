# MinIO做为Eucalyptus ObjectStorage后端存储

[MinIO](https://www.min.io/)是一种新的用Go编写的云存储，可以将任何数据存储为对象，还有另外一个强大的功能，它兼容AWS S3，这使得MinIO结合Eucalyptus使用非常有用。

[Eucalyptus](http://www.eucalyptus.com)支持多个ObjectStorage后端，Riak CS（云存储），Ceph RGW，而且Eucalyptus已经有S3兼容的Walrus。Eucalyptus ObjectStorage充当后端服务的网关。Eucalyptus仍然处理所有AWS兼容的身份认证和访问管理。由于MinIO与AWS S3兼容，我们实际上也可以将其与Eucalyptus一起使用。但是，即使可以使用任何与AWS S3兼容的对象存储后端，除非在Eucalyptus网站/文档中另行指定，否则不支持这些后端。

第一步是启动MinIO服务器。

部署基本的MinIO Server非常简单。在本示例中，我使用了运行Ubuntu 16.04.1 LTS（Xenial Xerus）的Eucalyptus实例（虚拟机）。


```
$ wget https://dl.min.io/server/minio/release/linux-amd64/minio
$ chmod +x minio
$ ./minio server ~/MinIOBackend
```

我们应该看到如下非常有用的输出信息，

```
Endpoint:  http://172.31.21.31:9000  http://127.0.0.1:9000
AccessKey: GFQX5XMP1DSTIQ8JKRXN
SecretKey: aFLQegoeIgzF/hK+Xymba7JwSANfn98ANNcKXz+S
Region:    us-east-1
SqsARNs:

Browser Access:
   http://172.31.21.31:9000  http://127.0.0.1:9000

Command-line Access: https://docs.min.io/docs/minio-client-quickstart-guide
   $ mc config host add myminio http://172.31.21.31:9000 GFQX5XMP1DSTIQ8JKRXN aFLQegoeIgzF/hK+Xymba7JwSANfn98ANNcKXz+S

Object API (Amazon S3 compatible):
   Go:         https://docs.min.io/docs/golang-client-quickstart-guide
   Java:       https://docs.min.io/docs/java-client-quickstart-guide
   Python:     https://docs.min.io/docs/python-client-quickstart-guide
   JavaScript: https://docs.min.io/docs/javascript-client-quickstart-guide
```

MinIO还附带了一个有用的Web UI，一旦我们运行MinIO，就可以访问它。

下一步将看看我们如何在Eucalyptus中添加一个新的提供者客户端。这听起来绝对容易，相信我，都是搞IT的，我不会骗你们的:)

如果我们尝试重置ObjectStorage的值，它应该向我们显示可用的受支持的对象存储S3提供者客户端，或者这些值也可以在运行面向用户的服务的cloud-output.log中找到，

```
# euctl -r objectstorage.providerclient
euctl: error (ModifyPropertyValueType): Cannot modify \
objectstorage.providerclient.providerclient new value \
is not a valid value.  Legal values are: walrus,ceph-rgw,riakcs
```

所以，现在我们必须为MinIO添加另一个提供者客户端。从技术上讲，我们可以使用riakcs，如果你已经使用packages部署了Eucalyptus，但是在这种情况下我不会这样做，因为我已经有了source build cloud。

本文假定你已经知道如何通过源码来build Eucalyptus,不会花篇幅来介绍细节。请到[这里](https://github.com/eucalyptus/eucalyptus/blob/master/INSTALL)来参考如何通过源码安装Eucalyptus。本文的目的是介绍如何添加第三方对象存储（比如MinIO）到Eucalyptus。不过再重申一下，如果你想用package installation，以及用riakcs做为提供者客户端，使用MinIO的endpoint和用户凭据，我们绝不拦着。

为了添加minio做为提供者客户端，首先我们需要创建一个叫MinIOProviderClient.java的文件，

```
/**
* Location: eucalyptus/clc/modules/object-storage/src/main/java/com/eucalyptus/objectstorage/providers/s3/MinIOProviderClient.java
*/

package com.eucalyptus.objectstorage.providers.s3;

import com.eucalyptus.objectstorage.providers.ObjectStorageProviders.ObjectStorageProviderClientProperty;

@ObjectStorageProviderClientProperty("minio")
public class MinIOProviderClient extends S3ProviderClient {
}
```

构建并安装所有的eucalyptus源码或者只是构建相应的jar。

停止eucalyptus-cloud服务并将eucalyptus-object-storage-4.4.0.jar复制到面向用户的服务正在运行的/usr/share/eucalyptus目录中。重新启动eucalyptus-cloud服务。

如果一切顺利，启用服务时，我们现在可以再次检查受支持的对象存储提供程序。

```
# euctl -r objectstorage.providerclient
euctl: error (ModifyPropertyValueType): Cannot modify \
objectstorage.providerclient.providerclient new value \
is not a valid value.  Legal values are: walrus,ceph-rgw,minio,riakcs
```

看起来minio现在是Eucalyptus对象存储支持的提供者客户端之一。有没有简单到你大吃一惊！:)

现在，我们应该能够将minio设置为Eucalyptus对象存储的提供者客户端。

```
# euctl objectstorage.providerclient=minio
objectstorage.providerclient = minio
```

现在配置Eucalyptus ObjectStorage服务来使用我们的MinIO部署的endpoint（公共IP地址/主机名）和证书，

```
# euctl objectstorage.s3provider.s3endpoint=10.116.159.114:9000
# euctl objectstorage.s3provider.s3accesskey=GFQX5XMP1DSTIQ8JKRXN
# euctl objectstorage.s3provider.s3secretkey=aFLQegoeIgzF/hK+Xymba7JwSANfn98ANNcKXz+S
```

Eucalyptus ObjectStorage网关使用提供的S3 endpoint进行连接检查，以启用Eucalyptus的对象存储服务。基本上，它需要S3 endpoint有一个HTTP响应代码，这个响应代码可以在后端配置，因为不同的后端可以发送不同的响应代码。显然，MinIO会返回404。所以，要使其工作，我们需要将值设置为404（虽然感到奇怪）。

```
# euctl objectstorage.s3provider.s3endpointheadresponse=404
```

在几秒钟内，我们应该看到对象存储已启用。我们可以运行以下命令来检查对象存储的服务状态，

```
# euserv-describe-services --filter service-type=objectstorage
```

现在我们应该可以使用MinIO作为对象存储后端。

这个是MinIO的issue请求: <https://github.com/minio/minio/issues/3284>
以及针对Eucalyptus的AWS Java SDK更新: <https://eucalyptus.atlassian.net/browse/EUCA-12955>
