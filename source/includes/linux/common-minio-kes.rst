.. start-kes-download-desc

Download the latest stable release (|kes-stable|) of KES from :minio-git:`github.com/minio/kes <kes/releases/latest>`.

Select the binary appropriate for the host OS architecture. 
For example, hosts running X86-64 (Intel/AMD64) should download the ``kes-linux-amd64`` package.

The following example code downloads the latest Linux AMD64-compatible binary and moves it to the system ``PATH``:

.. code-block:: shell
   :class: copyable
   :substitutions:

   wget https://github.com/minio/kes/releases/download/|kes-stable|/kes-linux-amd64 -O /tmp/kes
   chmod +x /tmp/kes
   sudo mv /tmp/kes /usr/local/bin

   kes --version

For distributed KES topologies, repeat this step and all following KES-specific instructions for each host on which you want to deploy KES.
MinIO strongly recommends configuring a load balancer with a "Least Connections" configuration to manage connections to distributed KES hosts.

.. end-kes-download-desc

.. start-kes-service-file-desc

Create the ``/etc/systemd/system/kes.service`` file on all KES hosts:

.. literalinclude:: /extra/kes.service
   :language: shell

You may need to run ``systemctl daemon-reload`` to load the new service file into ``systemctl``.

The ``kes.service`` file runs as the ``kes-user`` User and Group by default.
You can create the user and group using the ``useradd`` and ``groupadd`` commands.
The following example creates the user and group.
These commands typically require root (``sudo``) permissions.

.. code-block:: shell
   :class: copyable

   groupadd -r kes-user
   useradd -M -r -g kes-user kes-user

The ``kes-user`` user and group must have read access to all files used by the KES service:

.. code-block:: shell
   :class: copyable
   :substitutions:

   chown -R kes-user:kes-user /opt/kes
   chown -R kes-user:kes-user /etc/kes

.. end-kes-service-file-desc

.. start-kes-start-service-desc

Run the following command on each KES host to start the service:

.. code-block:: shell
   :class: copyable

   systemctl start kes

You can validate the startup by using ``systemctl status kes``. 
If the service started successfully, use ``journalctl -uf kes`` to check the KES output logs.

.. end-kes-start-service-desc

.. start-kes-minio-start-service-desc

For new MinIO deployments, run the following command on each MinIO host to start the service:

.. code-block:: shell
   :class: copyable

   systemctl start minio

For existing MinIO deployments, run the following command on each MinIO host to restart the service:

.. code-block:: shell
   :class: copyable

   systemctl reload minio
   systemctl restart minio

.. end-kes-minio-start-service-desc

.. start-kes-generate-kes-certs-prod-desc

Enabling connectivity between MinIO and KES requires at minimum one TLS certificate for performing mutual TLS (mTLS) authentication.
Depending on your Vault configuration, you may also need to create a dedicated set of TLS certificates for KES to connect and authenticate to Vault.
Defer to your organizations best practices around generating production-ready TLS certificates.

Place the certificates and corresponding private keys an appropriate directory such that the MinIO and KES service users can access and read their contents.
This procedure assumes a structure similar to the following:

  .. code-block:: shell
     :substitutions:

     # For the MinIO Hosts
     -rw-r--r-- 1 minio-user:minio-user |miniocertpath|/minio-kes.cert
     -rw-r--r-- 1 minio-user:minio-user |miniocertpath|/minio-kes.key

     # If KES certs are self-signed or use a non-global CA
     # Include the CA certs as well
     -rw-r--r-- 1 minio-user:minio-user |miniocertpath|/kes-server.cert

     # For the KES Hosts
     -rw-r--r-- 1 kes-user:kes-user |kescertpath|/kes-server.cert
     -rw-r--r-- 1 kes-user:kes-user |kescertpath|/kes-server.key

If the KES certificates are self-signed *or* signed by Certificate Authority (CA) that is *not* globally trusted, you **must** add the CA certificate to the |miniocertpath|/certs directory such that each MinIO server can properly validate the KES certificates.

.. end-kes-generate-kes-certs-prod-desc

.. start-kes-configuration-minio-desc

Add the following lines to the MinIO Environment file on each MinIO host.
See the tutorials for :ref:`minio-snsd`, :ref:`minio-snmd`, or :ref:`minio-mnmd` for more detailed descriptions of a base MinIO environment file.

This command assumes the ``minio-kes.cert``, ``minio-kes.key``, and ``kes-server.cert`` certificates are accessible at the specified location:

.. code-block:: shell
   :class: copyable
   :substitutions:

   # Add these environment variables to the existing environment file

   MINIO_KMS_KES_ENDPOINT=https://HOSTNAME:7373
   MINIO_KMS_KES_CERT_FILE=|miniocertpath|/minio-kes.cert
   MINIO_KMS_KES_KEY_FILE=|miniocertpath|/minio-kes.key
   MINIO_KMS_KES_CAPATH=|kescertpath|/kes-server.cert
   MINIO_KMS_KES_KEY_NAME=minio-backend-default-key

   minio server [ARGUMENTS]

Replace ``HOSTNAME`` with the IP address or hostname of the KES server.
If the MinIO server host machines cannot resolve or reach the specified ``HOSTNAME``, the deployment may return errors or fail to start.

- If using a single KES server host, specify the IP or hostname of that host
- If using multiple KES server hosts, specify the load balancer or reverse proxy managing connections to those hosts.

MinIO uses the :envvar:`MINIO_KMS_KES_KEY_NAME` key for the following cryptographic operations:

- Encrypting the MinIO backend (IAM, configuration, etc.)
- Encrypting objects using :ref:`SSE-KMS <minio-encryption-sse-kms>` if the request does not 
  include a specific |EK|.
- Encrypting objects using :ref:`SSE-S3 <minio-encryption-sse-s3>`.

The ``minio-kes`` certificates enable mTLS between the MinIO deployment and the KES server *only*.
They do not otherwise enable TLS for other client connections to MinIO.

.. end-kes-configuration-minio-desc

.. start-kes-generate-key-desc

MinIO requires that the |EK| exist on the root KMS *before* performing |SSE| operations using that key. 
Use ``kes key create`` *or* :mc:`mc admin kms key create` to add a new |EK| for use with |SSE|.

The following command uses the ``kes key create`` command to add a new External Key (EK) stored on the root KMS server for use with encrypting the MinIO backend.

.. code-block:: shell
   :class: copyable
   :substitutions:

   export KES_SERVER=https://127.0.0.1:7373
   export KES_CLIENT_KEY=|miniocertpath|/minio-kes.key
   export KES_CLIENT_CERT=|miniocertpath|/minio-kes.cert

   kes key create -k encrypted-bucket-key

.. end-kes-generate-key-desc