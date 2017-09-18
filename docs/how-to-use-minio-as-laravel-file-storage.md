# How to use Minio Server as [Laravel](https://laravel.com) Custom File Storage 

`Laravel` has a customable file storage system with ability to create custom drivers for it. In this recipe we will implement a custom file system driver to use Minio server for managing files.

## 1. Prerequisites

Install Minio Server from [here](http://docs.minio.io/docs/minio).

## 2. Install Required Dependency for Laravel

Install `league/flysystem` package for [`aws-s3`](https://github.com/thephpleague/flysystem-aws-s3-v3) :

```
composer require league/flysystem-aws-s3-v3
```


## 3. Create Minio Storage ServiceProvider 
Create `MinioStorageServiceProvider.php` file in `app/Providers/` directory with this content:

```php
<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;

use Aws\S3\S3Client;
use League\Flysystem\AwsS3v3\AwsS3Adapter;
use League\Flysystem\Filesystem;
use Storage;

class MinioStorageServiceProvider extends ServiceProvider
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
          return new Filesystem(new AwsS3Adapter($client, $config["bucket"]));
      });
    }

    /**
     * Register the application services.
     *
     * @return void
     */
    public function register()
    {

    }
}
```

Register service provider by adding this line in `config/app.php` on `providers` section :  
```php
App\Providers\MinioStorageServiceProvider::class
```

Add config for minio in `disks` section of `config/filesystems.php` file :

```php
  'disks' => [
    // other disks

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
Note : `region` is not required & can be sets to anything.

## 4. Use Storage with Minio in Laravel
Now you can use `disk` method on storage facade to use minio driver :  
```php
Storage::disk('minio')->put('avatars/1', $fileContents);
```
Or you can set default cloud driver to `minio` in `filesystems.php` config file :
```php
'cloud' => env('FILESYSTEM_CLOUD', 'minio'),
```
