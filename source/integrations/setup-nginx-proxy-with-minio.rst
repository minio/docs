.. _integrations-nginx-proxy:

======================================
Configure NGINX Proxy for MinIO Server
======================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

The following documentation covers the minimum settings required to configure NGINX to proxy requests to MinIO.

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

      - Proxy requests to the subpath ``https://minio.example.net/minio`` to the MinIO Console listening on ``https://minio.local:9001``.

      The following location blocks provide a template for further customization in your unique environment:

      .. code-block:: nginx
         :class: copyable

         upstream minio {
            least_conn;
            server minio-01.internal-domain.com;
            server minio-02.internal-domain.com;
            server minio-03.internal-domain.com;
            server minio-04.internal-domain.com;
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

               proxy_pass https://minio:9000/; # This uses the upstream directive definition to load balance
            }

            location /minio {
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
               
               chunked_transfer_encoding off;

               proxy_pass https://minio:9001/; # This uses the upstream directive definition to load balance and assumes a static Console port of 9001
            }
         }

      The S3 API signature calculation algorithm does *not* support proxy schemes where you host either the MinIO Server API or Console GUI on a subpath, such as ``example.net/s3/`` or ``example.net/console/``.

   .. tab-item:: Subdomain

      Create or configure separate, unique subdomains for the MinIO Server S3 API and for the MinIO Console Web GUI.

      For example, given the root domain of ``example.net``:

      - Proxy request to the subdomain ``minio.example.net`` to the MinIO Server listening on ``https://minio.local:9000``

      - Proxy requests to the subdomain ``console.example.net`` to the MinIO Console listening on ``https://minio.local:9001``

      The following location blocks provide a template for further customization in your unique environment:

      .. code-block:: nginx
         :class: copyable

         upstream minio {
            least_conn;
            server minio-01.internal-domain.com;
            server minio-02.internal-domain.com;
            server minio-03.internal-domain.com;
            server minio-04.internal-domain.com;
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

               proxy_pass http://minio:9000/; # This uses the upstream directive definition to load balance
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

               proxy_pass http://minio:9001/; # This uses the upstream directive definition to load balance and assumes a static Console port of 9001
            }
         }

      The S3 API signature calculation algorithm does *not* support proxy schemes where you host either the MinIO Server API or Console GUI on a subpath, such as ``minio.example.net/s3/`` or ``console.example.net/gui``.

