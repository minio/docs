# 如何使用MinIO Server做为[Laravel](https://laravel.com)自定义文件存储

`Laravel`有一个可定制的文件存储系统，能够为它创建自定义的磁盘。在本文中，我们将实现一个自定义文件系统磁盘来使用MinIO服务器来管理文件。

## 1. 前提条件
从[这里](https://www.min.io/download)下载并安装MinIO Server。

## 2. 给Laravel安装必要的依赖

为[`aws-s3`](https://github.com/coraxster/flysystem-aws-s3-v3-minio) 安装`league/flysystem`包：fork基于https://github.com/thephpleague/flysystem-aws-s3-v3

```
composer require coraxster/flysystem-aws-s3-v3-minio
```


## 3. 创建MinIO Storage ServiceProvider
在`app/Providers/`文件下创建`MinIOStorageServiceProvider.php`文件，内容如下：

```php
<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;

use Aws\S3\S3Client;
use League\Flysystem\AwsS3v3\AwsS3Adapter;
use League\Flysystem\Filesystem;
use Storage;

class MinIOStorageServiceProvider extends ServiceProvider
{
    /**
     * Bootstrap the application services.
     *
     * @return void
     */
    public function boot()
    {
      Storage::extend('minio', function ($app, $config) {
          $client = new S3Client([
              'credentials' => [
                  'key'    => $config["key"],
                  'secret' => $config["secret"]
              ],
              'region'      => $config["region"],
              'version'     => "latest",
              'bucket_endpoint' => false,
              'use_path_style_endpoint' => true,
              'endpoint'    => $config["endpoint"],
          ]);
          $options = [
              'override_visibility_on_copy' => true
          ];
          return new Filesystem(new AwsS3Adapter($client, $config["bucket"], '', $options));
      });
    }

    /**
     * 注册应用服务
     *
     * @return void
     */
    public function register()
    {

    }
}
```

通过在`providers`部分的`config/app.php`中添加这一行来注册服务提供者：

```php
App\Providers\MinIOStorageServiceProvider::class
```

在`config/filesystems.php`文件的`disks`部分添加minio配置：

```php
  'disks' => [
    // 其它磁盘

    'minio' => [
        'driver' => 'minio',
        'key' => env('MINIO_KEY', 'your minio server key'),
        'secret' => env('MINIO_SECRET', 'your minio server secret'),
        'region' => 'us-east-1',
        'bucket' => env('MINIO_BUCKET','your minio bucket name'),
        'endpoint' => env('MINIO_ENDPOINT','http://localhost:9000')
    ]

  ]
```
注意 : `region`并不是必须的，而且可以设置成任何值。

## 4. 在Laravel中使用MinIO存储
现在你可以用`disk`方法来使用minio磁盘。

```php
Storage::disk('minio')->put('avatars/1', $fileContents);
```
或者你可以在`filesystems.php`配置文件中将`minio`设为默认云盘：

```php
'cloud' => env('FILESYSTEM_CLOUD', 'minio'),
```

## 示例工程
如果你想的话，你可以自己研究[laravel-minio-sample](https://github.com/m2sh/laravel-minio-sample)项目和[unit tests](https://github.com/m2sh/laravel-minio-sample/blob/master/tests/Unit/MinIOStorageTest.php)，来加深对Laravel结合MinIO Server使用的理解。
