.. _integrations-nginx-proxy:

======================================
Configure NGINX Proxy for MinIO Server
======================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

The following documentation provides a baseline for configuring NGINX to proxy requests to MinIO in a Linux environment.
It is not intended as a comprehensive approach to NGINX, proxying, or reverse proxying in general.
Modify the configuration as necessary for your infrastructure.

This documentation assumes the following:

- An existing `NGINX <http://nginx.org/en/download.html>`__ deployment
- An existing :ref:`MinIO <minio-installation>` deployment
- A DNS hostname which uniquely identifies the MinIO deployment

There are two models for proxying requests to the MinIO Server API and the MinIO Console:

.. tab-set::

   .. tab-item:: Dedicated DNS

      Create or configure a dedicated DNS name for the MinIO service.

      For the MinIO Server S3 API, proxy requests to the root of that domain.
      For the MinIO Console Web GUI, proxy requests to the ``/minio`` subpath.

      For example, given the hostname ``minio.example.net``: 
      
      - Proxy requests to the root ``https://minio.example.net`` to the MinIO Server listening on ``https://minio.local:9000``.

      - Proxy requests to the subpath ``https://minio.example.net/minio/ui`` to the MinIO Console listening on ``https://minio.local:9001``.

      The following location blocks provide a template for further customization in your unique environment:

      .. code-block:: nginx
         :class: copyable

         upstream minio_s3 {
            least_conn;
            server minio-01.internal-domain.com:9000;
            server minio-02.internal-domain.com:9000;
            server minio-03.internal-domain.com:9000;
            server minio-04.internal-domain.com:9000;
         }

         upstream minio_console {
            least_conn;
            server minio-01.internal-domain.com:9001;
            server minio-02.internal-domain.com:9001;
            server minio-03.internal-domain.com:9001;
            server minio-04.internal-domain.com:9001;
         }

         server {
            listen       80;
            listen  [::]:80;
            server_name  minio.example.net;

            # Allow special characters in headers
            ignore_invalid_headers off;
            # Allow any size file to be uploaded.
            # Set to a value such as 1000m; to restrict file size to a specific value
            client_max_body_size 0;
            # Disable buffering
            proxy_buffering off;
            proxy_request_buffering off;

            location / {
               proxy_set_header Host $http_host;
               proxy_set_header X-Real-IP $remote_addr;
               proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
               proxy_set_header X-Forwarded-Proto $scheme;

               proxy_connect_timeout 300;
               # Default is HTTP/1, keepalive is only enabled in HTTP/1.1
               proxy_http_version 1.1;
               proxy_set_header Connection "";
               chunked_transfer_encoding off;

               proxy_pass https://minio_s3; # This uses the upstream directive definition to load balance
            }

            location /minio/ui/ {
               rewrite ^/minio/ui/(.*) /$1 break;
               proxy_set_header Host $http_host;
               proxy_set_header X-Real-IP $remote_addr;
               proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
               proxy_set_header X-Forwarded-Proto $scheme;
               proxy_set_header X-NginX-Proxy true;

               # This is necessary to pass the correct IP to be hashed
               real_ip_header X-Real-IP;

               proxy_connect_timeout 300;
               
               # To support websockets in MinIO versions released after January 2023
               proxy_http_version 1.1;
               proxy_set_header Upgrade $http_upgrade;
               proxy_set_header Connection "upgrade";
               # Some environments may encounter CORS errors (Kubernetes + Nginx Ingress)
               # Uncomment the following line to set the Origin request to an empty string
               # proxy_set_header Origin '';
               
               chunked_transfer_encoding off;

               proxy_pass https://minio_console; # This uses the upstream directive definition to load balance
            }
         }

      The S3 API signature calculation algorithm does *not* support proxy schemes where you host the MinIO Server API such as ``example.net/s3/``.

      You must also set the following environment variables for the MinIO deployment:

      - Set the :envvar:`MINIO_BROWSER_REDIRECT_URL` to the proxy host FQDN of the MinIO Console (``https://example.net/minio/ui``)

   .. tab-item:: Subdomain

      Create or configure separate, unique subdomains for the MinIO Server S3 API and for the MinIO Console Web GUI.

      For example, given the root domain of ``example.net``:

      - Proxy request to the subdomain ``minio.example.net`` to the MinIO Server listening on ``https://minio.local:9000``

      - Proxy requests to the subdomain ``console.example.net`` to the MinIO Console listening on ``https://minio.local:9001``

      The following location blocks provide a template for further customization in your unique environment:

      .. code-block:: nginx
         :class: copyable

         upstream minio_s3 {
            least_conn;
            server minio-01.internal-domain.com:9000;
            server minio-02.internal-domain.com:9000;
            server minio-03.internal-domain.com:9000;
            server minio-04.internal-domain.com:9000;
         }

         upstream minio_console {
            least_conn;
            server minio-01.internal-domain.com:9001;
            server minio-02.internal-domain.com:9001;
            server minio-03.internal-domain.com:9001;
            server minio-04.internal-domain.com:9001;
         }

         server {
            listen       80;
            listen  [::]:80;
            server_name  minio.example.net;

            # Allow special characters in headers
            ignore_invalid_headers off;
            # Allow any size file to be uploaded.
            # Set to a value such as 1000m; to restrict file size to a specific value
            client_max_body_size 0;
            # Disable buffering
            proxy_buffering off;
            proxy_request_buffering off;

            location / {
               proxy_set_header Host $http_host;
               proxy_set_header X-Real-IP $remote_addr;
               proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
               proxy_set_header X-Forwarded-Proto $scheme;

               proxy_connect_timeout 300;
               # Default is HTTP/1, keepalive is only enabled in HTTP/1.1
               proxy_http_version 1.1;
               proxy_set_header Connection "";
               chunked_transfer_encoding off;

               proxy_pass http://minio_s3; # This uses the upstream directive definition to load balance
            }
         }

         server {

            listen       80;
            listen  [::]:80;
            server_name  console.example.net;

            # Allow special characters in headers
            ignore_invalid_headers off;
            # Allow any size file to be uploaded.
            # Set to a value such as 1000m; to restrict file size to a specific value
            client_max_body_size 0;
            # Disable buffering
            proxy_buffering off;
            proxy_request_buffering off;

            location / {
               proxy_set_header Host $http_host;
               proxy_set_header X-Real-IP $remote_addr;
               proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
               proxy_set_header X-Forwarded-Proto $scheme;
               proxy_set_header X-NginX-Proxy true;

               # This is necessary to pass the correct IP to be hashed
               real_ip_header X-Real-IP;

               proxy_connect_timeout 300;
               
               # To support websocket
               proxy_http_version 1.1;
               proxy_set_header Upgrade $http_upgrade;
               proxy_set_header Connection "upgrade";
               
               chunked_transfer_encoding off;

               proxy_pass http://minio_console/; # This uses the upstream directive definition to load balance
            }
         }

      The S3 API signature calculation algorithm does *not* support proxy schemes where you host the MinIO Server API on a subpath, such as ``minio.example.net/s3/``.

      You must also set the following environment variables for the MinIO deployment:

      - Set the :envvar:`MINIO_BROWSER_REDIRECT_URL` to the proxy host FQDN of the MinIO Console (``https://console.example.net/``)
