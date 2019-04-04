# Generate Let's Encrypt certificate using Certbot for MinIO [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)
[Let’s Encrypt](https://letsencrypt.org/) is a new free, automated, and open source, Certificate Authority.

[Certbot](https://certbot.eff.org/) is a console based certificate generation tool for Let's Encrypt.

In this recipe, we will generate a Let's Encypt certificate using Certbot. This certificate will then be deployed for use in the MinIO server.

## 1. Prerequisites
- Install MinIO Server from [here](https://docs.minio.io/docs/minio-quickstart-guide).
- Install Certbot from [here](https://certbot.eff.org/)

## 2. Dependencies
- Port 443 for https needs to be open and available at time of executing `certbot`.
- Certbot needs root access while executing because only root is allowed to bind to any port below 1024.
- We will be using our own domain ``myminio.com``  as an example in this recipe. Replace with your own domain under your setup.

## 3. Recipe Steps

### Step 1: Install Certbot
Install Certbot by following the documentation at https://certbot.eff.org/

### Step 2: Generate Let's Encrypt cert
```sh
# certbot certonly --standalone -d myminio.com --staple-ocsp -m test@yourdomain.io --agree-tos
```

### Step 3: Verify Certificates
List your certs saved in `/etc/letsencrypt/live/myminio.com` directory.
```sh
$ ls -l /etc/letsencrypt/live/myminio.com
total 4
lrwxrwxrwx 1 root root  37 Aug  2 09:58 cert.pem -> ../../archive/myminio.com/cert4.pem
lrwxrwxrwx 1 root root  38 Aug  2 09:58 chain.pem -> ../../archive/myminio.com/chain4.pem
lrwxrwxrwx 1 root root  42 Aug  2 09:58 fullchain.pem -> ../../archive/myminio.com/fullchain4.pem
lrwxrwxrwx 1 root root  40 Aug  2 09:58 privkey.pem -> ../../archive/myminio.com/privkey4.pem
-rw-r--r-- 1 root root 543 May 10 22:07 README
```

### Step 4: Set up SSL on MinIO Server with the certificates.
The certificate and key generated via Certbot needs to be placed inside user's home directory.
```sh
$ cp /etc/letsencrypt/live/myminio.com/fullchain.pem /home/user/.minio/certs/public.crt
$ cp /etc/letsencrypt/live/myminio.com/privkey.pem /home/user/.minio/certs/private.key
```

### Step 5: Change ownership of certificates.
```sh
$ sudo chown user:user /home/user/.minio/certs/private.key
$ sudo chown user:user /home/user/.minio/certs/public.crt
```

### Step 6: Start MinIO Server using HTTPS.

If you are not going to run MinIO with `root` privileges, you will need to give MinIO the capability of listening on ports less than 1024 using the following command:

```sh
sudo setcap 'cap_net_bind_service=+ep' ./minio
```

Now, you can start MinIO Server on port "443".

```sh
$ ./minio server --address ":443" /mnt/data
```

If you are using dockerized version of MinIO then you would need to
```sh
$ sudo docker run -p 443:443 -v /home/user/.minio:/root/.minio/ -v /home/user/data:/data minio/minio server --address ":443" /data
```

### Step 7: Visit <https://myminio.com> in the browser.
![Letsencrypt](https://github.com/minio/cookbook/blob/master/docs/screenshots/letsencrypt-certbot-minio.jpg?raw=true)
