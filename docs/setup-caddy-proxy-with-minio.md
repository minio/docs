# Set Up a Caddy Proxy with Minio Server  [![Slack](https://slack.minio.io/slack?type=svg)](https://slack.minio.io)

Caddy is a web server, similar to Apache, NGINX, or lighttpd, that streamlines development, deployment, and hosting of websites.

This quickstart guide describes how to set up a Caddy proxy for Minio Server. These are the steps you will follow:

1. [Install Minio Server](#installminio) 
2. [Install Caddy](#installcaddy) 
3. [Configure Caddy](#configurecaddy) 
4. [Start Minio Server](#startminio) 
5. [Start the Caddy Server](#startcaddy)

## <a name="installminio"></a>1. Install Minio Server

Install Minio Server using the instructions in the [Minio Quickstart Guide](http://docs.minio.io/docs/minio-quickstart-guide).

## <a name="installcaddy"></a>2. Install Caddy

Install the Caddy web server using these instructions: [https://caddyserver.com/download](https://caddyserver.com/download).

## <a name="configurecaddy"></a>3. Configure Caddy
### 3.1 Create a Caddy Configuration File:
Open a text editor and create a configuration file with the following content:

```sh
your.public.com

proxy / localhost:9000 {
    header_upstream X-Forwarded-Proto {scheme}
    header_upstream X-Forwarded-Host {host}
    header_upstream Host {host}
    health_check /minio/health/ready
}
```

### 3.2 Change the IP Addresses
Change the DNS entry and IP address/port in the configuration file according to your Minio and DNS configuration, and save the file. The example above defaults to `your.public.com` and `localhost:9000`, respectively.

## <a name="startminio"></a>4. Start Minio Server
Start Minio Server and replace `<your_export_dir>` with the name of the directory where data is stored:

```sh
./minio --address localhost:9000 server <your_export_dir>
```

## <a name="startcaddy"></a>5. Start the Caddy Server
Start the Caddy web server and replace `<your_configuration_file>` with the name of the configuration file created above:

```sh
./caddy -conf ./path/to/<your_configuration_file>
```

You should see a response similar to this one:

```sh
Activating privacy features... done.
your.public.com:443
your.public.com:80
```

