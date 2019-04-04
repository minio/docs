# How to use AWS SDK for iOS(swift-3) with MinIO Server [![Slack](https://slack.min.io/slack?type=svg)](https://slack.min.io)

In this recipe we will learn how to use `AWSS3` for iOS with MinIO server. `AWSS3` is the official AWS S3 SDK for the swift/objective-c programming language.

## 1. Prerequisites

Install MinIO Server from [here](https://docs.min.io/docs/minio-quickstart-guide).

To get latest `AWSS3` SDK v2.5.5 working with minio/minio:edge, you have to modify file `AWSSignature.m` from `AWSS3` SDK, remove line `[urlRequest setValue:@"Chunked" forHTTPHeaderField:@"Transfer-Encoding"];`, keep track on [aws-sdk-ios #638](https://github.com/aws/aws-sdk-ios/pull/638)

## 2. Installation

Setup `AWSS3` for iOS from the official AWS iOS SDK docs [here](http://docs.aws.amazon.com/mobile/sdkforios/developerguide/setup-aws-sdk-for-ios.html)

we only need 'AWSS3'

## 3. Example

Please replace `accessKey`, `secretKey`, and `url`, change the region base on what you need, service must set to `.S3`

(`AWSS3` will auto remove port number if you type `xxxx:9000` in `url`, currently it only support full url without port, so please make sure you have a domain map to port 9000, you may need refer to this [Setup Nginx proxy with MinIO Server](https://docs.min.io/docs/setup-nginx-proxy-with-minio))

``` swift
let accessKey = "XXXXXXX"
let secretKey = "XXXXXXX"

let credentialsProvider = AWSStaticCredentialsProvider(accessKey: accessKey, secretKey: secretKey)
let configuration = AWSServiceConfiguration(region: .USEast1, endpoint: AWSEndpoint(region: .USEast1, service: .S3, url: URL(string:"XXXXXX")),credentialsProvider: credentialsProvider)

AWSServiceManager.default().defaultServiceConfiguration = configuration

let S3BucketName = "images"
let remoteName = "prefix_test.jpg"
let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(remoteName)
let image = UIImage(named: "test")
let data = UIImageJPEGRepresentation(image!, 0.9)
do {
    try data?.write(to: fileURL)
}
catch {}

let uploadRequest = AWSS3TransferManagerUploadRequest()!
uploadRequest.body = fileURL
uploadRequest.key = remoteName
uploadRequest.bucket = S3BucketName
uploadRequest.contentType = "image/jpeg"
uploadRequest.acl = .publicRead

let transferManager = AWSS3TransferManager.default()

transferManager.upload(uploadRequest).continueWith { (task: AWSTask<AnyObject>) -> Any? in
  ...
}
```

[Full example project here](https://github.com/atom2ueki/minio-ios-example)

## 4. Run the Program

for example if you running that eample project
1. Run the xcode project on your phone or simulator
2. Click upload button on screen
<img src="/docs/screenshots/iOS-test-app.png" alt="screenshot" height="250">

3. Check on `MinIO Browser`, inside images bucket, there should be an image there called prefix_test.jpg, means you susccessful upload the image
