# Minio as Eucalyptus ObjectStorage backend

[Minio|https://www.minio.io/], the new cloud storage written in Go that let's you store any data as objects also has another great feature, it's AWS S3 compatible and that makes Minio really useful with Eucalyptus.

[Eucalyptus|http://www.eucalyptus.com] supports multiple ObjectStorage backends, Riak CS (Cloud Storage), Ceph RGW and Eucalyptus already comes with S3 compatible Walrus. Eucalyptus ObjectStorage service acts as a gateway for the backends. Eucalyptus still handles all the AWS compatible Identity and Access Management stuffs. As Minio is compatible with AWS S3, we can actually use it with Eucalyptus as well. However, even though it is possible to use any object storage backend that is compatible with AWS S3, they are not supported unless specified otherwise on the Eucalyptus website/documentation.

The first step would be to start a Minio server.

Deploying a basic Minio server is super simple. For this demo I have used an Eucalyptus instance (virtual machine) running Ubuntu 16.04.1 LTS (Xenial Xerus).

```
$ wget https://dl.minio.io/server/minio/release/linux-amd64/minio
$ chmod +x minio
$ ./minio server ~/MinioBackend
```

We should see a super helpful output like below,
```
Endpoint:  http://172.31.21.31:9000  http://127.0.0.1:9000
AccessKey: GFQX5XMP1DSTIQ8JKRXN
SecretKey: aFLQegoeIgzF/hK+Xymba7JwSANfn98ANNcKXz+S
Region:    us-east-1
SqsARNs:

Browser Access:
   http://172.31.21.31:9000  http://127.0.0.1:9000

Command-line Access: https://docs.minio.io/docs/minio-client-quickstart-guide
   $ mc config host add myminio http://172.31.21.31:9000 GFQX5XMP1DSTIQ8JKRXN aFLQegoeIgzF/hK+Xymba7JwSANfn98ANNcKXz+S

Object API (Amazon S3 compatible):
   Go:         https://docs.minio.io/docs/golang-client-quickstart-guide
   Java:       https://docs.minio.io/docs/java-client-quickstart-guide
   Python:     https://docs.minio.io/docs/python-client-quickstart-guide
   JavaScript: https://docs.minio.io/docs/javascript-client-quickstart-guide
```

Minio also comes with a helpful web UI which can be accessible once we have Minio running.

Next step would be to see how we can add a new provider client in Eucalyptus. It is definitely easier that it sounds :)

If we try to reset the value for ObjectStorage it should show us the available supported objectstorage S3 provider clients or these values are also available in the cloud-output.log where user-facing services are running,

```
# euctl -r objectstorage.providerclient
euctl: error (ModifyPropertyValueType): Cannot modify \
objectstorage.providerclient.providerclient new value \
is not a valid value.  Legal values are: walrus,ceph-rgw,riakcs
```

So, now we have to add another provider client for Minio. Technically, we can probably use riakcs, if you have deployed Eucalyptus with packages, but I am not gonna do that in this case, since I already have source build cloud.

This post assumes that you know how to build Eucalyptus from source and doesn't go into much detail. The purpose of this post is to show how to add a third-party object storage like Minio with Eucalyptus. But again, feel free to use package installation and use riakcs as provider client, use the Minio's endpoint and user credentials as described below.

To add minio as a provider client, first we need to create a file called MinioProviderClient.java,

```
/**
* Location: eucalyptus/clc/modules/object-storage/src/main/java/com/eucalyptus/objectstorage/providers/s3/MinioProviderClient.java
*/

package com.eucalyptus.objectstorage.providers.s3;

import com.eucalyptus.objectstorage.providers.ObjectStorageProviders.ObjectStorageProviderClientProperty;

@ObjectStorageProviderClientProperty("minio")
public class MinioProviderClient extends S3ProviderClient {
}
```

Build and install all of eucalyptus source or just build the jars.

Stop eucalyptus-cloud service and copy eucalyptus-object-storage-4.4.0.jar to /usr/share/eucalyptus directory where user-facing services are running. Restart eucalyptus-cloud service.

If everything goes well, when the services are enabled, we can now check if the supported object storage providers again.

```
# euctl -r objectstorage.providerclient
euctl: error (ModifyPropertyValueType): Cannot modify \
objectstorage.providerclient.providerclient new value \
is not a valid value.  Legal values are: walrus,ceph-rgw,minio,riakcs
```

Looks like minio is now one of the supported provider client for Eucalyptus object storage. That was easy! :)

At this point we should be able to set minio as a provider client for Eucalyptus object storage.

```
# euctl objectstorage.providerclient=minio
objectstorage.providerclient = minio
```

Now configure Eucalyptus ObjectStorage service to use our Minio deployment endpoint (public IP address/hostname) and credentials,

```
# euctl objectstorage.s3provider.s3endpoint=10.116.159.114:9000
# euctl objectstorage.s3provider.s3accesskey=GFQX5XMP1DSTIQ8JKRXN
# euctl objectstorage.s3provider.s3secretkey=aFLQegoeIgzF/hK+Xymba7JwSANfn98ANNcKXz+S
```

Eucalyptus ObjectStorage gateway does a connectivity check with the provided S3 endpoint to enable the objectstorage service of Eucalyptus. Basically it expects a HTTP response code for HEAD operation on S3 endpoint, which can be configured based on the backend, as different backend can send different response code. Apparently Minio returns 404 on it's endpoint. So, to make it work, we need to set the value to 404 (feels weird though).

```
# euctl objectstorage.s3provider.s3endpointheadresponse=404
```
Within a few seconds we should see the object storage is enabled. We can run the following to check the service status of object storage,

```
# euserv-describe-services --filter service-type=objectstorage
```

Now we can use Minio as an object storage backend. However, while working, I found an issue where any PUT object request that was made through Eucalyptus ends up with a failure. After debugging with Swathi Gangisetty it looks like the AWS Java SDK Eucalyptus using doesn't like the fact that Minio is returning Etag instead of ETag as it is mentioned in the AWS Documentation. To test, we removed Eucalyptus out of the picture and tried to upload an object directly with AWS Java SDK 1.7.1, which also failed in the same way. However, the same upload request works with AWS Java SDK 1.10.x.
So, to use Minio successfully as an Eucalyptus ObjectStorage backend, we either need a fix in Minio where it returns the correct ETag or when Eucalyptus starts using a newer AWS Java SDK in a future release.

Here are the requests for the fix in Minio: https://github.com/minio/minio/issues/3284
and for the AWS Java SDK update in Eucalyptus: https://eucalyptus.atlassian.net/browse/EUCA-12955

Update:
Looks like this was a bug in AWS Java SDK 1.7.1 and fixed in a later release,
https://github.com/aws/aws-sdk-java/pull/590
