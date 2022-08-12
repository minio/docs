# MinIO Haskell SDK API Reference

## Initialize MinIO Client object.

### MinIO - for public Play server

```haskell
minioPlayCI :: ConnectInfo
minioPlayCI

```

### AWS S3

```haskell
awsCI :: ConnectInfo
awsCI { connectAccesskey = "your-access-key"
      , connectSecretkey = "your-secret-key"
      }

```

| Bucket operations                                 | Object Operations                             | Presigned Operations                              |
|:--------------------------------------------------|:----------------------------------------------|:--------------------------------------------------|
| [`listBuckets`](#listBuckets)                     | [`getObject`](#getObject)                     | [`presignedGetObjectUrl`](#presignedGetObjectUrl) |
| [`makeBucket`](#makeBucket)                       | [`putObject`](#putObject)                     | [`presignedPutObjectUrl`](#presignedPutObjectUrl) |
| [`removeBucket`](#removeBucket)                   | [`fGetObject`](#fGetObject)                   | [`presignedPostPolicy`](#presignedPostPolicy)     |
| [`listObjects`](#listObjects)                     | [`fPutObject`](#fPutObject)                   |                                                   |
| [`listObjectsV1`](#listObjectsV1)                 | [`copyObject`](#copyObject)                   |                                                   |
| [`listIncompleteUploads`](#listIncompleteUploads) | [`removeObject`](#removeObject)               |                                                   |
| [`bucketExists`](#bucketExists)                   | [`selectObjectContent`](#selectObjectContent) |                                                   |

## 1. Connecting and running operations on the storage service

The Haskell MinIO SDK provides high-level functionality to perform
operations on a MinIO server or any AWS S3-like API compatible storage
service.

### The `ConnectInfo` type

The `ConnectInfo` record-type contains connection information for a
particular server. It is recommended to construct the `ConnectInfo`
value using one of the several smart constructors provided by the
library, documented in the following subsections.

The library automatically discovers the region of a bucket by
default. This is especially useful with AWS, where buckets may be in
different regions. When performing an upload, download or other
operation, the library requests the service for the location of a
bucket and caches it for subsequent requests.

#### awsCI :: ConnectInfo

`awsCI` is a value that provides connection information for AWS
S3. Credentials can be supplied by overriding a couple of fields like
so:

``` haskell
awsConn = awsCI {
    connectAccessKey = "my-AWS-access-key"
  , connectSecretKey = "my-AWS-secret-key"
  }
```

#### awsWithRegionCI :: Region -> Bool -> ConnectInfo

This constructor allows to specify the initial region and a Boolean to
enable/disable the automatic region discovery behaviour.

The parameters in the expression `awsWithRegion region autoDiscover` are:

| Parameter      | Type                        | Description                                                                                                                |
|:---------------|:----------------------------|:---------------------------------------------------------------------------------------------------------------------------|
| `region`       | _Region_ (alias for `Text`) | The region to connect to by default for all requests.                                                                      |
| `autoDiscover` | _Bool_                      | If `True`, region discovery will be enabled. If `False`, discovery is disabled, and all requests go the given region only. |

#### minioPlayCI :: ConnectInfo

This constructor provides connection and authentication information to
connect to the public MinIO Play server at
`https://play.min.io/`.

#### minioCI :: Text -> Int -> Bool -> ConnectInfo

Use to connect to a MinIO server.

The parameters in the expression `minioCI host port isSecure` are:

| Parameter  | Type   | Description                                             |
|:-----------|:-------|:--------------------------------------------------------|
| `host`     | _Text_ | Hostname of the MinIO or other S3-API compatible server |
| `port`     | _Int_  | Port number to connect to                               |
| `isSecure` | _Bool_ | Does the server use HTTPS?                              |

#### The ConnectInfo fields and Default instance

The following table shows the fields in the `ConnectInfo` record-type:

| Field                       | Type                        | Description                                                                                       |
|:----------------------------|:----------------------------|:--------------------------------------------------------------------------------------------------|
| `connectHost`               | _Text_                      | Host name of the server. Defaults to `localhost`.                                                 |
| `connectPort`               | _Int_                       | Port number on which the server listens. Defaults to `9000`.                                      |
| `connectAccessKey`          | _Text_                      | Access key to use in authentication. Defaults to `minio`.                                         |
| `connectSecretkey`          | _Text_                      | Secret key to use in authentication. Defaults to `minio123`.                                      |
| `connectIsSecure`           | _Bool_                      | Specifies if the server used TLS. Defaults to `False`                                             |
| `connectRegion`             | _Region_ (alias for `Text`) | Specifies the region to use. Defaults to 'us-east-1'                                              |
| `connectAutoDiscoverRegion` | _Bool_                      | Specifies if the library should automatically discover the region of a bucket. Defaults to `True` |

The `def` value of type `ConnectInfo` has all the above default
values.

### The Minio Monad

This monad provides the required environment to perform requests
against a MinIO or other S3 API compatible server. It uses the
connection information from the `ConnectInfo` value provided to it. It
performs connection pooling, bucket location caching, error handling
and resource clean-up actions.

The `runMinio` function performs the provided action in the `Minio`
monad and returns a `IO (Either MinioErr a)` value:

``` haskell
{-# Language OverloadedStrings #-}

import Network.Minio

main :: IO ()
main = do
  result <- runMinio def $ do
    buckets <- listBuckets
    return $ length buckets

  case result of
    Left e -> putStrLn $ "Failed operation with error: " ++ show e
    Right n -> putStrLn $ show n ++ " bucket(s) found."
```

The above performs a `listBuckets` operation and returns the number of
buckets in the server. If there were any errors, they will be returned
as values of type `MinioErr` as a `Left` value.

## 2. Bucket operations

<a name="listBuckets"></a>
### listBuckets :: Minio [BucketInfo]
Lists buckets.

__Return Value__

| Return type          | Description     |
|:---------------------|:----------------|
| _Minio [BucketInfo]_ | List of buckets |


__BucketInfo record type__

| Field            | Type                       | Description                 |
|:-----------------|:---------------------------|:----------------------------|
| `biName`         | _Bucket_ (alias of `Text`) | Name of the bucket          |
| `biCreationDate` | _UTCTime_                  | Creation time of the bucket |


<a name="makeBucket"></a>
### makeBucket :: Bucket -> Maybe Region -> Minio ()

Create a new bucket. If the region is not specified, the region
specified by `ConnectInfo` is used.

__Parameters__

In the expression `makeBucket bucketName region` the arguments are:

| Param        | Type                        | Description                                                                                         |
|--------------|-----------------------------|-----------------------------------------------------------------------------------------------------|
| `bucketName` | _Bucket_ (alias for `Text`) | Name of the bucket                                                                                  |
| `region`     | _Maybe Region_              | Region where the bucket is to be created. If not specified, default to the region in `ConnectInfo`. |

__Example__

``` haskell
{-# Language OverloadedStrings #-}

main :: IO ()
main = do
    res <- runMinio minioPlayCI $ do
        makeBucket bucketName (Just "us-east-1")
    case res of
        Left err -> putStrLn $ "Failed to make bucket: " ++ (show res)
        Right _ -> putStrLn $ "makeBucket successful."

```

<a name="removeBucket"></a>
### removeBucket :: Bucket -> Minio ()

Remove a bucket. The bucket must be empty or an error will be thrown.

__Parameters__

In the expression `removeBucket bucketName` the arguments are:

| Param        | Type                        | Description        |
|--------------|-----------------------------|--------------------|
| `bucketName` | _Bucket_ (alias for `Text`) | Name of the bucket |


__Example__


``` haskell
{-# Language OverloadedStrings #-}

main :: IO ()
main = do
    res <- runMinio minioPlayCI $ do
        removeBucket "mybucket"

    case res of
        Left err -> putStrLn $ "Failed to remove bucket: " ++ (show res)
        Right _ -> putStrLn $ "removeBucket successful."

```


<a name="listObjects"></a>
### listObjects :: Bucket -> Maybe Text -> Bool -> C.ConduitM () ObjectInfo Minio ()

List objects in the given bucket, implements version 2 of AWS S3 API.

__Parameters__

In the expression `listObjects bucketName prefix recursive` the
arguments are:

| Param        | Type                        | Description                                                                                              |
|:-------------|:----------------------------|:---------------------------------------------------------------------------------------------------------|
| `bucketName` | _Bucket_ (alias for `Text`) | Name of the bucket                                                                                       |
| `prefix`     | _Maybe Text_                | Optional prefix that listed objects should have                                                          |
| `recursive`  | _Bool_                      | `True` indicates recursive style listing and `False` indicates directory style listing delimited by '/'. |

__Return Value__

| Return type                         | Description                                                             |
|:------------------------------------|:------------------------------------------------------------------------|
| _C.ConduitM () ObjectInfo Minio ()_ | A Conduit Producer of `ObjectInfo` values corresponding to each object. |

__ObjectInfo record type__

| Field        | Type                        | Description                          |
|:-------------|:----------------------------|:-------------------------------------|
| `oiObject`   | _Object_ (alias for `Text`) | Name of object                       |
| `oiModTime`  | _UTCTime_                   | Last modified time of the object     |
| `oiETag`     | _ETag_ (alias for `Text`)   | ETag of the object                   |
| `oiSize`     | _Int64_                     | Size of the object in bytes          |
| `oiMetadata` | _HashMap Text Text_         | Map of key-value user-metadata pairs |

__Example__

``` haskell
{-# LANGUAGE OverloadedStrings #-}
import           Network.Minio

import           Conduit
import           Prelude


-- | The following example uses MinIO play server at
-- https://play.min.io.  The endpoint and associated
-- credentials are provided via the libary constant,
--
-- > minioPlayCI :: ConnectInfo
--

main :: IO ()
main = do
  let
    bucket = "test"

  -- Performs a recursive listing of all objects under bucket "test"
  -- on play.min.io.
  res <- runMinio minioPlayCI $
    runConduit $ listObjects bucket Nothing True .| mapM_C (\v -> (liftIO $ print v))
  print res
```

<a name="listObjectsV1"></a>
### listObjectsV1 :: Bucket -> Maybe Text -> Bool -> C.ConduitM () ObjectInfo Minio ()

List objects in the given bucket, implements version 1 of AWS S3 API. This API
is provided for legacy S3 compatible object storage endpoints.

__Parameters__

In the expression `listObjectsV1 bucketName prefix recursive` the
arguments are:

| Param        | Type                        | Description                                                                                              |
|:-------------|:----------------------------|:---------------------------------------------------------------------------------------------------------|
| `bucketName` | _Bucket_ (alias for `Text`) | Name of the bucket                                                                                       |
| `prefix`     | _Maybe Text_                | Optional prefix that listed objects should have                                                          |
| `recursive`  | _Bool_                      | `True` indicates recursive style listing and `False` indicates directory style listing delimited by '/'. |

__Return Value__

| Return type                         | Description                                                             |
|:------------------------------------|:------------------------------------------------------------------------|
| _C.ConduitM () ObjectInfo Minio ()_ | A Conduit Producer of `ObjectInfo` values corresponding to each object. |

__ObjectInfo record type__

| Field       | Type                        | Description                      |
|:------------|:----------------------------|:---------------------------------|
| `oiObject`  | _Object_ (alias for `Text`) | Name of object                   |
| `oiModTime` | _UTCTime_                   | Last modified time of the object |
| `oiETag`    | _ETag_ (alias for `Text`)   | ETag of the object               |
| `oiSize`    | _Int64_                     | Size of the object in bytes      |

__Example__

``` haskell
{-# LANGUAGE OverloadedStrings #-}
import           Network.Minio

import           Conduit
import           Prelude


-- | The following example uses MinIO play server at
-- https://play.min.io.  The endpoint and associated
-- credentials are provided via the libary constant,
--
-- > minioPlayCI :: ConnectInfo
--

main :: IO ()
main = do
  let
    bucket = "test"

  -- Performs a recursive listing of all objects under bucket "test"
  -- on play.min.io.
  res <- runMinio minioPlayCI $
    runConduit $ listObjectsV1 bucket Nothing True .| mapM_C (\v -> (liftIO $ print v))
  print res
```

<a name="listIncompleteUploads"></a>
### listIncompleteUploads :: Bucket -> Maybe Prefix -> Bool -> C.Producer Minio UploadInfo

List incompletely uploaded objects.

__Parameters__

In the expression `listIncompleteUploads bucketName prefix recursive`
the parameters are:

| Param        | Type                        | Description                                                                                              |
|:-------------|:----------------------------|:---------------------------------------------------------------------------------------------------------|
| `bucketName` | _Bucket_ (alias for `Text`) | Name of the bucket                                                                                       |
| `prefix`     | _Maybe Text_                | Optional prefix that listed objects should have.                                                         |
| `recursive`  | _Bool_                      | `True` indicates recursive style listing and `Talse` indicates directory style listing delimited by '/'. |

__Return Value__

|Return type   |Description   |
|:---|:---|
| _C.ConduitM () UploadInfo Minio ()_  | A Conduit Producer of `UploadInfo` values corresponding to each incomplete multipart upload |

__UploadInfo record type__

| Field        | Type     | Description                               |
|:-------------|:---------|:------------------------------------------|
| `uiKey`      | _Object_ | Name of incompletely uploaded object      |
| `uiUploadId` | _String_ | Upload ID of incompletely uploaded object |
| `uiSize`     | _Int64_  | Size of incompletely uploaded object      |

__Example__

```haskell
{-# LANGUAGE OverloadedStrings #-}
import           Network.Minio

import           Conduit
import           Prelude

-- | The following example uses MinIO play server at
-- https://play.min.io.  The endpoint and associated
-- credentials are provided via the libary constant,
--
-- > minioPlayCI :: ConnectInfo
--

main :: IO ()
main = do
  let
    bucket = "test"

  -- Performs a recursive listing of incomplete uploads under bucket "test"
  -- on a local MinIO server.
  res <- runMinio minioPlayCI $
    runConduit $ listIncompleteUploads bucket Nothing True .| mapM_C (\v -> (liftIO $ print v))
  print res

```

## 3. Object operations

<a name="getObject"></a>
### getObject :: Bucket -> Object -> GetObjectOptions -> Minio (C.ConduitM () ByteString Minio ())

Get an object from the S3 service, optionally object ranges can be provided as well.

__Parameters__

In the expression `getObject bucketName objectName opts` the parameters
are:

| Param        | Type                        | Description                                                                 |
|:-------------|:----------------------------|:----------------------------------------------------------------------------|
| `bucketName` | _Bucket_ (alias for `Text`) | Name of the bucket                                                          |
| `objectName` | _Object_ (alias for `Text`) | Name of the object                                                          |
| `opts`       | _GetObjectOptions_          | Options for GET requests specifying additional options like If-Match, Range |

__GetObjectOptions record type__

| Field                  | Type                            | Description                                                                                           |
|:-----------------------|:--------------------------------|:------------------------------------------------------------------------------------------------------|
| `gooRange`             | `Maybe ByteRanges`              | Represents the byte range of object. E.g ByteRangeFromTo 0 9 represents first ten bytes of the object |
| `gooIfMatch`           | `Maybe ETag` (alias for `Text`) | (Optional) ETag of object should match                                                                |
| `gooIfNoneMatch`       | `Maybe ETag` (alias for `Text`) | (Optional) ETag of object shouldn't match                                                             |
| `gooIfUnmodifiedSince` | `Maybe UTCTime`                 | (Optional) Time since object wasn't modified                                                          |
| `gooIfModifiedSince`   | `Maybe UTCTime`                 | (Optional) Time since object was modified                                                             |

__Return Value__

The return value can be incrementally read to process the contents of
the object.
| Return type                                 | Description                              |
|:--------------------------------------------|:-----------------------------------------|
| _Minio (C.ConduitM () ByteString Minio ())_ | A Conduit source of `ByteString` values. |

__Example__

```haskell
{-# LANGUAGE OverloadedStrings #-}
import           Network.Minio

import qualified Data.Conduit        as C
import qualified Data.Conduit.Binary as CB

import           Prelude

-- | The following example uses MinIO play server at
-- https://play.min.io.  The endpoint and associated
-- credentials are provided via the libary constant,
--
-- > minioPlayCI :: ConnectInfo
--

main :: IO ()
main = do
  let
      bucket = "my-bucket"
      object = "my-object"
  res <- runMinio minioPlayCI $ do
    src <- getObject bucket object def
    C.connect src $ CB.sinkFileCautious "/tmp/my-object"

  case res of
    Left e  -> putStrLn $ "getObject failed." ++ (show e)
    Right _ -> putStrLn "getObject succeeded."
```

<a name="putObject"></a>
### putObject :: Bucket -> Object -> C.ConduitM () ByteString Minio () -> Maybe Int64 -> PutObjectOptions -> Minio ()
Uploads an object to a bucket in the service, from the given input
byte stream of optionally supplied length. Optionally you can also specify
additional metadata for the object.

__Parameters__

In the expression `putObject bucketName objectName inputSrc` the parameters
are:

| Param        | Type                                | Description                                                       |
|:-------------|:------------------------------------|:------------------------------------------------------------------|
| `bucketName` | _Bucket_ (alias for `Text`)         | Name of the bucket                                                |
| `objectName` | _Object_ (alias for `Text`)         | Name of the object                                                |
| `inputSrc`   | _C.ConduitM () ByteString Minio ()_ | A Conduit producer of `ByteString` values                         |
| `size`       | _Int64_                             | Provide stream size (optional)                                    |
| `opts`       | _PutObjectOptions_                  | Optional parameters to provide additional metadata for the object |

__Example__

```haskell
{-# LANGUAGE OverloadedStrings #-}
import           Network.Minio

import qualified Data.Conduit.Combinators as CC

import           Prelude

-- | The following example uses MinIO play server at
-- https://play.min.io.  The endpoint and associated
-- credentials are provided via the libary constant,
--
-- > minioPlayCI :: ConnectInfo
--

main :: IO ()
main = do
  let
      bucket = "test"
      object = "obj"
      localFile = "/etc/lsb-release"
      kb15 = 15 * 1024

  -- Eg 1. Upload a stream of repeating "a" using putObject with default options.
  res <- runMinio minioPlayCI $
    putObject bucket object (CC.repeat "a") (Just kb15) def
  case res of
    Left e   -> putStrLn $ "putObject failed." ++ show e
    Right () -> putStrLn "putObject succeeded."

```

<a name="fGetObject"></a>
### fGetObject :: Bucket -> Object -> FilePath -> GetObjectOptions -> Minio ()
Downloads an object from a bucket in the service, to the given file

__Parameters__

In the expression `fGetObject bucketName objectName inputFile` the parameters
are:

| Param        | Type                        | Description                                                                 |
|:-------------|:----------------------------|:----------------------------------------------------------------------------|
| `bucketName` | _Bucket_ (alias for `Text`) | Name of the bucket                                                          |
| `objectName` | _Object_ (alias for `Text`) | Name of the object                                                          |
| `inputFile`  | _FilePath_                  | Path to the file to be uploaded                                             |
| `opts`       | _GetObjectOptions_          | Options for GET requests specifying additional options like If-Match, Range |


__GetObjectOptions record type__

| Field                  | Type                            | Description                                                                                           |
|:-----------------------|:--------------------------------|:------------------------------------------------------------------------------------------------------|
| `gooRange`             | `Maybe ByteRanges`              | Represents the byte range of object. E.g ByteRangeFromTo 0 9 represents first ten bytes of the object |
| `gooIfMatch`           | `Maybe ETag` (alias for `Text`) | (Optional) ETag of object should match                                                                |
| `gooIfNoneMatch`       | `Maybe ETag` (alias for `Text`) | (Optional) ETag of object shouldn't match                                                             |
| `gooIfUnmodifiedSince` | `Maybe UTCTime`                 | (Optional) Time since object wasn't modified                                                          |
| `gooIfModifiedSince`   | `Maybe UTCTime`                 | (Optional) Time since object was modified                                                             |

``` haskell

{-# Language OverloadedStrings #-}
import Network.Minio

import Data.Conduit (($$+-))
import Data.Conduit.Binary (sinkLbs)
import Prelude

-- | The following example uses MinIO play server at
-- https://play.min.io.  The endpoint and associated
-- credentials are provided via the libary constant,
--
-- > minioPlayCI :: ConnectInfo
--

main :: IO ()
main = do
  let
      bucket = "my-bucket"
      object = "my-object"
      localFile = "/etc/lsb-release"

  res <- runMinio minioPlayCI $ do
    src <- fGetObject bucket object localFile def
    (src $$+- sinkLbs)

  case res of
    Left e -> putStrLn $ "fGetObject failed." ++ (show e)
    Right _ -> putStrLn "fGetObject succeeded."
```

<a name="fPutObject"></a>
### fPutObject :: Bucket -> Object -> FilePath -> Minio ()
Uploads an object to a bucket in the service, from the given file

__Parameters__

In the expression `fPutObject bucketName objectName inputFile` the parameters
are:

| Param        | Type                        | Description                     |
|:-------------|:----------------------------|:--------------------------------|
| `bucketName` | _Bucket_ (alias for `Text`) | Name of the bucket              |
| `objectName` | _Object_ (alias for `Text`) | Name of the object              |
| `inputFile`  | _FilePath_                  | Path to the file to be uploaded |

__Example__

```haskell
{-# Language OverloadedStrings #-}
import Network.Minio
import qualified Data.Conduit.Combinators as CC

main :: IO ()
main = do
  let
    bucket = "mybucket"
    object = "myobject"
    localFile = "/etc/lsb-release"

  res <- runMinio minioPlayCI $ do
           fPutObject bucket object localFile

  case res of
    Left e -> putStrLn $ "Failed to fPutObject " ++ show bucket ++ "/" ++ show object
    Right _ -> putStrLn "fPutObject was successful"
```

<a name="copyObject"></a>
### copyObject :: DestinationInfo -> SourceInfo -> Minio ()
Copies content of an object from the service to another

__Parameters__

In the expression `copyObject dstInfo srcInfo` the parameters
are:

| Param     | Type              | Description                                               |
|:----------|:------------------|:----------------------------------------------------------|
| `dstInfo` | _DestinationInfo_ | A value representing properties of the destination object |
| `srcInfo` | _SourceInfo_      | A value representing properties of the source object      |


__SourceInfo record type__

| Field                  | Type                   | Description                                                                                               |
|:-----------------------|:-----------------------|:----------------------------------------------------------------------------------------------------------|
| `srcBucket`            | `Bucket`               | Name of source bucket                                                                                     |
| `srcObject`            | `Object`               | Name of source object                                                                                     |
| `srcRange`             | `Maybe (Int64, Int64)` | (Optional) Represents the byte range of source object. (0, 9) represents first ten bytes of source object |
| `srcIfMatch`           | `Maybe Text`           | (Optional) ETag source object should match                                                                |
| `srcIfNoneMatch`       | `Maybe Text`           | (Optional) ETag source object shouldn't match                                                             |
| `srcIfUnmodifiedSince` | `Maybe UTCTime`        | (Optional) Time since source object wasn't modified                                                       |
| `srcIfModifiedSince`   | `Maybe UTCTime`        | (Optional) Time since source object was modified                                                          |

__Destination record type__

| Field       | Type     | Description                                          |
|:------------|:---------|:-----------------------------------------------------|
| `dstBucket` | `Bucket` | Name of destination bucket in server-side copyObject |
| `dstObject` | `Object` | Name of destination object in server-side copyObject |

__Example__

```haskell
{-# Language OverloadedStrings #-}
import Network.Minio

main :: IO ()
main = do
  let
    bucket = "mybucket"
    object = "myobject"
    objectCopy = "obj-copy"

  res <- runMinio minioPlayCI $ do
           copyObject def { dstBucket = bucket, dstObject = objectCopy } def { srcBucket = bucket, srcObject = object }

  case res of
    Left e -> putStrLn $ "Failed to copyObject " ++ show bucket ++ show "/" ++ show object
    Right _ -> putStrLn "copyObject was successful"
```

<a name="removeObject"></a>
### removeObject :: Bucket -> Object -> Minio ()
Removes an object from the service

__Parameters__

In the expression `removeObject bucketName objectName` the parameters
are:

| Param        | Type                        | Description        |
|:-------------|:----------------------------|:-------------------|
| `bucketName` | _Bucket_ (alias for `Text`) | Name of the bucket |
| `objectName` | _Object_ (alias for `Text`) | Name of the object |

__Example__

```haskell
{-# Language OverloadedStrings #-}
import Network.Minio

main :: IO ()
main = do
  let
    bucket = "mybucket"
    object = "myobject"

  res <- runMinio minioPlayCI $ do
           removeObject bucket object

  case res of
    Left e -> putStrLn $ "Failed to remove " ++ show bucket ++ "/" ++ show object
    Right _ -> putStrLn "Removed object successfully"
```

<a name="removeIncompleteUpload"></a>
### removeIncompleteUpload :: Bucket -> Object -> Minio ()
Removes an ongoing multipart upload of an object from the service

__Parameters__

In the expression `removeIncompleteUpload bucketName objectName` the parameters
are:

| Param        | Type                        | Description        |
|:-------------|:----------------------------|:-------------------|
| `bucketName` | _Bucket_ (alias for `Text`) | Name of the bucket |
| `objectName` | _Object_ (alias for `Text`) | Name of the object |

__Example__

```haskell
{-# Language OverloadedStrings #-}
import Network.Minio

main :: IO ()
main = do
  let
    bucket = "mybucket"
    object = "myobject"

  res <- runMinio minioPlayCI $
           removeIncompleteUpload bucket object

  case res of
    Left _ -> putStrLn $ "Failed to remove " ++ show bucket ++ "/" ++ show object
    Right _ -> putStrLn "Removed incomplete upload successfully"
```

<a name="selectObjectContent"></a>
### selectObjectContent :: Bucket -> Object -> SelectRequest -> Minio (ConduitT () EventMessage Minio ())
Removes an ongoing multipart upload of an object from the service

__Parameters__

In the expression `selectObjectContent bucketName objectName selReq`
the parameters are:

| Param        | Type                        | Description               |
|:-------------|:----------------------------|:--------------------------|
| `bucketName` | _Bucket_ (alias for `Text`) | Name of the bucket        |
| `objectName` | _Object_ (alias for `Text`) | Name of the object        |
| `selReq`     | _SelectRequest_             | Select request parameters |

__SelectRequest record__

This record is created using `selectRequest`. Please refer to the Haddocks for further information.

__Return Value__

The return value can be used to read individual `EventMessage`s in the response. Please refer to the Haddocks for further information.

|Return type | Description |
|:---|:---|
| _Minio (C.conduitT () EventMessage Minio ())_ | A Conduit source of `EventMessage` values. |

__Example__

```haskell
{-# Language OverloadedStrings #-}
import Network.Minio

import qualified Conduit              as C

main :: IO ()
main = do
  let
    bucket = "mybucket"
    object = "myobject"

  res <- runMinio minioPlayCI $ do
    let sr = selectRequest "Select * from s3object"
             defaultCsvInput defaultCsvOutput
    res <- selectObjectContent bucket object sr
    C.runConduit $ res C..| getPayloadBytes C..| C.stdoutC

  case res of
    Left _ -> putStrLn "Failed!"
    Right _ -> putStrLn "Success!"
```


<a name="BucketExists"></a>
### bucketExists :: Bucket -> Minio Bool
Checks if a bucket exists.

__Parameters__

In the expression `bucketExists bucketName` the parameters are:

| Param        | Type                        | Description        |
|:-------------|:----------------------------|:-------------------|
| `bucketName` | _Bucket_ (alias for `Text`) | Name of the bucket |


## 4. Presigned operations

<a name="presignedGetObjectUrl"></a>
### presignedGetObjectUrl :: Bucket -> Object -> UrlExpiry -> Query -> RequestHeaders -> Minio ByteString

Generate a URL with authentication signature to GET (download) an
object. All extra query parameters and headers passed here will be
signed and are required when the generated URL is used. Query
parameters could be used to change the response headers sent by the
server. Headers can be used to set Etag match conditions among others.

For a list of possible request parameters and headers, please refer
to the GET object REST API AWS S3 documentation.

__Parameters__

In the expression `presignedGetObjectUrl bucketName objectName expiry queryParams headers`
the parameters are:

| Param         | Type                                                           | Description                                     |
|:--------------|:---------------------------------------------------------------|:------------------------------------------------|
| `bucketName`  | _Bucket_ (alias for `Text`)                                    | Name of the bucket                              |
| `objectName`  | _Object_ (alias for `Text`)                                    | Name of the object                              |
| `expiry`      | _UrlExpiry_ (alias for `Int`)                                  | Url expiry time in seconds                      |
| `queryParams` | _Query_ (from package `http-types:Network.HTTP.Types`)         | Query parameters to add to the URL              |
| `headers`     | _RequestHeaders_ (from package `http-types:Network.HTTP.Types` | Request headers that would be used with the URL |

__Return Value__

Returns the generated URL - it will include authentication
information.

| Return type  | Description             |
|:-------------|:------------------------|
| _ByteString_ | Generated presigned URL |

__Example__

```haskell
{-# Language OverloadedStrings #-}

import Network.Minio
import qualified Data.ByteString.Char8 as B

main :: IO ()
main = do
  let
    bucket = "mybucket"
    object = "myobject"

  res <- runMinio minioPlayCI $ do
           -- Set a 7 day expiry for the URL
           presignedGetObjectUrl bucket object (7*24*3600) [] []

  -- Print the URL on success.
  putStrLn $ either
    (("Failed to generate URL: " ++) . show)
    B.unpack
    res
```

<a name="presignedPutObjectUrl"></a>
### presignedPutObjectUrl :: Bucket -> Object -> UrlExpiry -> RequestHeaders -> Minio ByteString

Generate a URL with authentication signature to PUT (upload) an
object. Any extra headers if passed, are signed, and so they are
required when the URL is used to upload data. This could be used, for
example, to set user-metadata on the object.

For a list of possible headers to pass, please refer to the PUT object
REST API AWS S3 documentation.

__Parameters__

In the expression `presignedPutObjectUrl bucketName objectName expiry headers`
the parameters are:

| Param        | Type                                                           | Description                                     |
|:-------------|:---------------------------------------------------------------|:------------------------------------------------|
| `bucketName` | _Bucket_ (alias for `Text`)                                    | Name of the bucket                              |
| `objectName` | _Object_ (alias for `Text`)                                    | Name of the object                              |
| `expiry`     | _UrlExpiry_ (alias for `Int`)                                  | Url expiry time in seconds                      |
| `headers`    | _RequestHeaders_ (from package `http-types:Network.HTTP.Types` | Request headers that would be used with the URL |

__Return Value__

Returns the generated URL - it will include authentication
information.

| Return type  | Description             |
|:-------------|:------------------------|
| _ByteString_ | Generated presigned URL |

__Example__

```haskell
{-# Language OverloadedStrings #-}

import Network.Minio
import qualified Data.ByteString.Char8 as B

main :: IO ()
main = do
  let
    bucket = "mybucket"
    object = "myobject"

  res <- runMinio minioPlayCI $ do
           -- Set a 7 day expiry for the URL
           presignedPutObjectUrl bucket object (7*24*3600) [] []

  -- Print the URL on success.
  putStrLn $ either
    (("Failed to generate URL: " ++) . show)
    B.unpack
    res
```

<a name="presignedPostPolicy"></a>
### presignedPostPolicy :: PostPolicy -> Minio (ByteString, HashMap Text ByteString)

Generate a presigned URL and POST policy to upload files via a POST
request. This is intended for browser uploads and generates form data
that should be submitted in the request.

The `PostPolicy` argument is created using the `newPostPolicy` function:

#### newPostPolicy :: UTCTime -> [PostPolicyCondition] -> Either PostPolicyError PostPolicy

In the expression `newPostPolicy expirationTime conditions` the parameters are:

| Param            | Type                                              | Description                                  |
|:-----------------|:--------------------------------------------------|:---------------------------------------------|
| `expirationTime` | _UTCTime_ (from package `time:Data.Time.UTCTime`) | The expiration time for the policy           |
| `conditions`     | _[PostPolicyConditions]_                          | List of conditions to be added to the policy |

The policy conditions are created using various helper functions -
please refer to the Haddocks for details.

Since conditions are validated by `newPostPolicy` it returns an
`Either` value.

__Return Value__

`presignedPostPolicy` returns a 2-tuple - the generated URL and a map
containing the form-data that should be submitted with the request.

__Example__

```haskell
{-# Language OverloadedStrings #-}

import Network.Minio

import qualified Data.ByteString       as B
import qualified Data.ByteString.Char8 as Char8
import qualified Data.HashMap.Strict   as H
import qualified Data.Text.Encoding    as Enc
import qualified Data.Time             as Time

main :: IO ()
main = do
  now <- Time.getCurrentTime
  let
    bucket = "mybucket"
    object = "myobject"

    -- set an expiration time of 10 days
    expireTime = Time.addUTCTime (3600 * 24 * 10) now

    -- create a policy with expiration time and conditions - since the
    -- conditions are validated, newPostPolicy returns an Either value
    policyE = newPostPolicy expireTime
              [ -- set the object name condition
                ppCondKey "photos/my-object"
                -- set the bucket name condition
              , ppCondBucket "my-bucket"
                -- set the size range of object as 1B to 10MiB
              , ppCondContentLengthRange 1 (10*1024*1024)
                -- set content type as jpg image
              , ppCondContentType "image/jpeg"
                -- on success set the server response code to 200
              , ppCondSuccessActionStatus 200
              ]

  case policyE of
    Left err -> putStrLn $ show err
    Right policy -> do
      res <- runMinio minioPlayCI $ do
        (url, formData) <- presignedPostPolicy policy

        -- a curl command is output to demonstrate using the generated
        -- URL and form-data
        let
          formFn (k, v) = B.concat ["-F ", Enc.encodeUtf8 k, "=",
                                    "'", v, "'"]
          formOptions = B.intercalate " " $ map formFn $ H.toList formData


        return $ B.intercalate " " $
          ["curl", formOptions, "-F file=@/tmp/photo.jpg", url]

      case res of
        Left e -> putStrLn $ "post-policy error: " ++ (show e)
        Right cmd -> do
          putStrLn $ "Put a photo at /tmp/photo.jpg and run command:\n"

          -- print the generated curl command
          Char8.putStrLn cmd
```

<!-- ## 5. Bucket policy/notification operations -->

<!-- TODO -->

<!-- ## 6. Explore Further -->

<!-- TODO -->
