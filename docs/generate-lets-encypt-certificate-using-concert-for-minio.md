# Generate Let's Encrypt certificate using Concert for Minio [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

[Let’s Encrypt](https://letsencrypt.org/) is a new free, automated, and open source, Certificate Authority.

[Concert](https://docs.minio.io/docs/concert) is a console based certificate generation tool for Let’s Encrypt. It is open source & one of the related project from Minio.

In this recipe, we will generate a Let's Encypt certificate using Concert. This certificate will then be deployed for use in the Minio server.

## 1. Prerequisites

* Install Minio Server from [here](https://docs.minio.io/docs/minio).
* Install Golang from [here](https://docs.minio.io/docs/how-to-install-golang).

## 2. Dependencies

* Port 443 for https needs to be open and available at time of executing `concert`.
* Concert needs root access while executing because only root is allowed to bind to any port below 1024.
* We will be using our own domain ``churchofminio.com``  as an example in this recipe. Replace with your own domain for your needs.

## 3. Recipe Steps

### Step 1: Install concert as shown below.

```sh
$ go get -u github.com/minio/concert
```

### Step 2: Generate Let's Encrypt cert.


```sh
$ sudo concert gen --dir my-certs admin@churchofminio.com churchofminio.com
2016/04/04 07:10:01 Generated certificates for churchofminio.com under my-certs will expire in 89 days.
```

### Step 3: Verify Certificates.

List certs saved in `my-certs` directory.

```sh
$ ls -l my-certs/
total 12
-rw------- 1 root root  227 Apr  4 07:10 certs.json
-rw------- 1 root root 1679 Apr  4 07:10 private.key
-rw------- 1 root root 3448 Apr  4 07:10 public.crt
```

### Step 4: Set up SSL on Minio Server with the certificates.

The generated keys via Concert needs to be placed inside users home directory at ``${HOME}/.minio/certs``

```sh
$ cp my-certs/private.key /home/supernova/.minio/certs/
$ cp my-certs/public.crt /home/supernova/.minio/certs/
```

### Step 5: Change ownership of certificates.

```sh
$ sudo chown supernova:supernova /home/supernova/.minio/certs/private.key
$ sudo chown supernova:supernova /home/supernova/.minio/certs/public.crt
```

### Step 6: Start Minio Server using HTTPS.

Start Minio Server as shown below.

```sh
$ ./minio server export/
```

### Step 7: Visit <https://churchofminio.com:9000> in the browser.

![Letsencrypt](https://github.com/minio/cookbook/blob/master/docs/screenshots/letsencrypt-concert-minio.jpg?raw=true)
