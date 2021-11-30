
.. The following sections are common installation instructions for the KES
   server. These are used in the following pages:

   - /source/security/server-side-encryption/configure-minio-kes-hashicorp.rst
   - /source/security/server-side-encryption/configure-minio-kes-aws.rst
   - /source/security/server-side-encryption/configure-minio-kes-azure.rst
   - /source/security/server-side-encryption/configure-minio-kes-gcp.rst

.. start-kes-network-encryption-desc

MinIO |KES-git| relies on mutual TLS (mTLS) for authentication and
authorization. Enabling |SSE| therefore *requires* that the MinIO server, |KES|,
and the root |KMS| enforce TLS.

The instructions on this page include creation of TLS certificates for
supporting mTLS between MinIO and the KES instance. These certificates are
appropriate for early development and evaluation environments **only**.

For instructions on enabling TLS on the MinIO server, see :ref:`minio-tls`.

.. admonition:: Use Caution in Production Environments
   :class: important

   **DO NOT** use the TLS certificates generated as part of this procedure for
   any long-term development or production environments. 

   Defer to organization/industry best practices around TLS certificate
   generation and management. A complete guide to creating valid certificates
   (e.g. well-formed, current, and trusted) is beyond the scope of this
   procedure.

.. end-kes-network-encryption-desc

.. start-kes-podman-desc

The procedures on this page use the |podman| daemonless container engine for
running OCI containers. Podman is a drop-in replacement for Docker.

This procedure assues running Podman in
:podman-git:`"rootless" <blob/main/docs/tutorials/rootless_tutorial.md>`. 
Defer to the Podman documentation for installing and configuring Podman to 
run in rootless mode.


.. end-kes-podman-desc

.. start-kes-download-desc

You can download the KES binary for running in baremetal environments,
*or* use the KES container image for running in an orchestrated environment:

.. tab-set::

   .. tab-item:: CLI
      :sync: cli

      Download the latest stable release (|kes-stable|) of KES from 
      :minio-git:`github.com/minio/kes <kes/releases/latest>`.

      Select the binary appropriate for the host OS architecture. For example, 
      hosts running X86-64 (Intel/AMD64) should download the ``kes-linux-amd64`` 
      package.

      The following example code downloads the latest Linux AMD64-compatible
      binary and moves it to the system ``PATH``:

      .. code-block:: shell
         :class: copyable
         :substitutions:

         wget https://github.com/minio/kes/releases/download/v|kes-stable|/kes-linux-amd64 -O /tmp/kes && \
         chmod +x /tmp/kes && \
         sudo mv /tmp/kes /usr/local/bin

         kes --version


   .. tab-item:: Container
      :sync: container

      The following command uses |podman| to download the latest stable KES 
      (|kes-stable|) as a container image:

      .. code-block:: shell
         :class: copyable
         :substitutions:

         podman pull quay.io/minio/kes/v|kes-stable|

      You can validate the container downloaded correctly by running the 
      following command:

      .. code-block:: shell
         :class: copyable

         podman run kes --version

      The output should reflect |kes-stable|.

.. end-kes-download-desc

.. start-kes-generate-kes-certs-desc

This step creates a self-signed TLS certificate for use with KES in evaluation
or early development environments. The certificate expires within 30 days of
creation.

For production environments, use certificates signed by a trusted Certificate
Authority (CA). **DO NOT** use certificates generated using these instructions
in production environments.

.. tab-set::

   .. tab-item:: CLI
      :sync: cli

      The following command creates the self-signed private and public key files
      using the ``kes tool identity new`` command:

      .. code-block:: shell
         :class: copyable

         kes tool identity new --server \
                               --key  ~/kes/certs/server.key  \
                               --cert ~/kes/certs/server.cert \
                               --ip   "127.0.0.1"             \
                               --dns  localhost

   .. tab-item:: Container
      :sync: container

      The following command creates the self-signed private and public key files
      using the ``kes tool identity new`` command. ``podman run --rm``
      automatically removes the container when the command exists

      .. code-block:: shell
         :class: copyable

         podman run --rm -v ~/kes/certs:/data/certs                      \
                    kes tool identity new --server                       \
                                          --key  /data/certs/server.key  \
                                          --cert /data/certs/server.cert \
                                          --ip   "127.0.0.1"             \
                                          --dns  localhost

      This command outputs the keys to the ``~/kes/certs`` directory on the host
      operating system.

.. end-kes-generate-kes-certs-desc

.. start-kes-generate-minio-certs-desc

KES uses mTLS for authorizing a connecting client to perform a requested
cryptographic operation. This step creates a new TLS identity for the MinIO
deployment to use in performing secure cryptographic operations on KES. The
certificate expires within 30 days of creation.

For production environments, use certificates signed by a trusted Certificate
Authority (CA). **DO NOT** use certificates generated using these instructions
in production environments.

.. tab-set::

   .. tab-item:: CLI
      :sync: cli

      The following command creates the self-signed private and public key files
      using the ``kes tool identity new`` command:

      .. code-block:: shell
         :class: copyable

         kes tool identity new --server \
                               --key  ~/kes/certs/minio-kes.key  \
                               --cert ~/kes/certs/minio-kes.cert \
                               --ip   "127.0.0.1"             \
                               --dns  localhost

      The command outputs the keys to the ``~/kes/certs`` directory.

      Use the ``kes tool identity of`` command to compute the identity hash for
      the certificate. This hash is required for configuring access to the KES
      server in a later step:

      .. code-block:: shell
         :class: copyable
         
         kes tool identify of ~/kes/certs/minio-kes.cert

   .. tab-item:: Container
      :sync: container

      The following command creates the self-signed private and public key files
      using the ``kes tool identity new`` command. ``podman run --rm``
      automatically removes the container when the command exists

      .. code-block:: shell
         :class: copyable

         podman run --rm -v ~/kes/certs:/data/certs                     \
                kes tool identity new --key  /data/certs/minio-kes.key  \
                                      --cert /data/certs/minio-kes.cert

      This command outputs the keys to the ``~/kes/certs`` directory on the host
      operating system.

      Use the ``kes tool identity of`` command to compute the identity hash for
      the certificate. This hash is required for configuring access to the KES
      server in a later step:

      .. code-block:: shell
         :class: copyable

         sudo podman run --rm --v ~/kes/certs:/data/certs                \
                         kes tool identity of /data/certs/minio-kes.cert

.. end-kes-generate-minio-certs-desc

.. start-kes-run-server-desc

.. tab-set::

   .. tab-item:: CLI
      :sync: cli

      The first command allows |KES| to use the `mlock
      <http://man7.org/linux/man-pages/man2/mlock.2.html>`__ system call without
      running as root. ``mlock`` ensures the OS does not write in-memory data to
      disk (swap memory) and mitigates the risk of cryptographic operations 
      being written to unsecured disk at any time.
      
      The second command starts the KES server in the foreground using the
      configuration file created in the last step. The ``--auth=off`` disables
      strict validation of client TLS certificates and is required if either the
      MinIO client or the root KMS server uses self-signed certificates.

      .. code-block:: shell
         :class: copyable

         sudo setcap cap_ipc_lock=+ep $(readlink -f $(which kes))

         kes server --mlock                            \
                    --config=~/kes/config/server-config.yaml  \
                    --auth=off

      |KES| listens on port ``7373`` by default. You can monitor the server
      logs from the terminal session. If you run |KES| without tying it to
      the current shell session (e.g. with ``nohup``), use that methods
      associated logging system (e.g. ``nohup.txt``).
      
   .. tab-item:: Container
      :sync: container

      The following command starts the KES server using the configuration file
      created in the last step. The command includes the necessary extensions
      that allow |KES| to use the `mlock
      <http://man7.org/linux/man-pages/man2/mlock.2.html>`__ system call without
      running as root. ``mlock`` ensures the OS does not write in-memory data to
      disk (swap memory) and mitigates the risk of cryptographic operations
      being written to unsecured disk at any time.

      .. code-block:: shell
         :class: copyable

         podman run --rm -idt --cap-add=IPC_LOCK                         \
                    --name kes-server                                    \
                    -v ~/kes/certs:/data/certs                           \
                    -v ~/kes/config:/data/config                         \
                    -p 7373:7373                                         \
                    kes server --mlock                                   \
                               --config=/data/config/server-config.yaml  \
                               --auth=off

      The container starts using the specified configuration file and begins
      listening for client connections at por ``7373``. The server attempts to
      connect to the root KMS deployment specified in the server configuration
      file.

.. end-kes-run-server-desc

.. start-kes-generate-key-desc

.. tab-set::

   .. tab-item:: CLI
      :sync: cli

      MinIO requires that the |EK| exist on the root KMS *before* performing
      |SSE| operations using that key. Use ``kes key create`` *or*
      :mc:`mc admin kms key create` to create a new |EK| for use with |SSE|.

      The following command uses the ``kes key create`` command to create a new
      External Key (EK) stored on the root KMS server for use with encrypting
      the MinIO backend.

      .. code-block:: shell
         :class: copyable

         export KES_SERVER=https://127.0.0.1:7373
         export KES_CLIENT_KEY=~/kes/minio-kes.key
         export KES_CLIENT_CERT=~/kes/minio-kes.cert

         kes key create -k minio-backend-default-key

   .. tab-item:: Container
      :sync: container

      MinIO requires that the |EK| exist on the root KMS *before* performing
      |SSE| operations using that key. Use ``kes key create`` *or*
      :mc:`mc admin kms key create` to create a new |EK| for use with |SSE|.

      The following command uses the ``kes key create`` command to create a new
      External Key (EK) stored on the root KMS server for use with encrypting
      the MinIO backend.

      .. code-block:: shell
         :class: copyable

         sudo podman exec -it kes-server /bin/bash
         
         [root@ID /]# /kes key create -k                                      \
                                      -e KES_SERVER=https://127.0.0.1:7373    \
                                      -e KES_CLIENT_KEY=/data/minio-kes.key   \
                                      -e KES_CLIENT_CERT=/data/minio-kes.cert \
                                      minio-backend-default-key

.. end-kes-generate-key-desc

.. start-kes-configure-minio-desc

Set the following environment variables to configure MinIO to connect to the
KES server. Set these variables on *all* hosts running MinIO servers in the
deployment. This command assumes the ``minio-kes.cert``, ``minio-kes.key``, and
``server.cert`` certificates are accessible at the specified location:

.. code-block:: shell
   :class: copyable

   export MINIO_KMS_KES_ENDPOINT=https://HOSTNAME:7373
   export MINIO_KMS_KES_CERT_FILE=~/minio-kes.cert
   export MINIO_KMS_KES_KEY_FILE=~/minio-kes.key
   export MINIO_KMS_KES_CAPATH=~/server.cert
   export MINIO_KMS_KES_KEY_NAME=minio-backend-default-key

   minio server [ARGUMENTS]

- Replace ``HOSTNAME`` with the IP address or the hostname for the host machine
  running the KES server or pod started in the previous step. 

- Replace the ``minio server [ARGUMENTS]`` to match the command used to
  start the MinIO server on that host.

- Add all other environment variables as required by the deployment.

MinIO uses the :envvar:`MINIO_KMS_KES_KEY_NAME` key for the following
cryptographic operations:

- Encrypting the MinIO backend (IAM, configuration, etc.)
- Performing :ref:`SSE-KMS <minio-encryption-sse-kms>` if the request does not 
  include a specific |EK|.
- Performing :ref:`SSE-S3 <minio-encryption-sse-s3>`.

.. end-kes-configure-minio-desc

.. -----------------------------------------------------------------------------

.. The following sections are common descriptors associated to the KES 
   configuration. These are used in the following pages:

   - /source/security/server-side-encryption/configure-minio-kes-hashicorp.rst
   - /source/security/server-side-encryption/configure-minio-kes-aws.rst
   - /source/security/server-side-encryption/configure-minio-kes-azure.rst
   - /source/security/server-side-encryption/configure-minio-kes-gcp.rst

.. start-kes-conf-address-desc

The network address and port on which the KES server listens to on startup.
Defaults to port ``7373`` on all host network interfaces.

.. end-kes-conf-address-desc


.. start-kes-conf-root-desc

The identity for the KES superuser (root) identity. Clients connecting
with a TLS certificate whose hash (``kes tool identity of client.cert``) 
matches this value have access to all KES API operations.

You can specify ``'disabled'`` to disable this identity and limit access 
based on the ``policy`` configuration. 

.. end-kes-conf-root-desc


.. start-kes-conf-tls-desc

The TLS private key and certificate used by KES for establishing 
TLS-secured communications. Specify the full path to both the private ``.key``
and public ``.cert`` to the ``key`` and ``cert`` fields respectively.

.. end-kes-conf-tls-desc

.. start-kes-conf-policy-desc

Specify one or more 
:minio-git:`policies <kes/wiki/Configuration#policy-configuration>` to
control access to the KES server.

MinIO |SSE| requires access to only the following KES cryptographic APIs:

- ``/v1/key/create/*``
- ``/v1/key/generate/*``
- ``/v1/key/decrypt/*``

You can restrict the range of key names MinIO can create as part of performing
|SSE| by specifying a prefix to replace the ``*``. For example, 
``minio-sse-*`` only grants access to create, generate, or decrypt keys using
that prefix.

|KES| uses mTLS to authorize connecting clients by comparing the 
hash of the TLS certificate against the ``identities`` of each configured
policy. Use the ``kes tool identity of`` command to compute the identity of the
MinIO mTLS certificate and add it to the ``policy.<NAME>.identities`` array
to associate MinIO to the ``<NAME>`` policy. 

.. end-kes-conf-policy-desc

.. start-kes-conf-keys-desc

Specify an array of keys which *must* exist on the root KMS for |KES| to 
successfully start. KES attempts to create the keys if they do not exist and
exits with an error if it fails to create any key. KES does not accept any
client requests until it completes validation of all specified keys.

.. end-kes-conf-keys-desc

.. -----------------------------------------------------------------------------

.. The following sections include common admonitions/notes across all KES
   properties. These are used in the following pages:

   - /source/security/server-side-encryption/server-side-encryption-sse-kms.rst
   - /source/security/server-side-encryption/server-side-encryption-sse-s3.rst
   - /source/security/server-side-encryption/server-side-encryption-sse-c.rst

.. start-kes-play-sandbox-warning

.. important::

   The MinIO KES ``Play`` sandbox is public and grants root access to all
   created External Keys (EK). Any |EK| stored on the ``Play`` sandbox may be
   accessed or destroyed at any time, rendering protected data vulnerable or
   permanently unreadable. 
   
   - **Never** use the ``Play`` sandbox to protect data you cannot afford to
     lose or reveal.

   - **Never** generate |EK| using names that reveal private, confidential, or
     internal naming conventions for your organization.

   - **Never** use the ``Play`` sandbox for production environments.

.. end-kes-play-sandbox-warning
