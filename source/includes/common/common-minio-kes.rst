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

.. start-kes-encrypted-backend-desc

Enabling |SSE| on a MinIO deployment automatically encrypts the backend data for that deployment using the default encryption key.

MinIO *requires* access to KES *and* the root KMS to decrypt the backend and start normally.
You cannot disable KES later or "undo" the |SSE| configuration at a later point.

.. end-kes-encrypted-backend-desc

.. start-kes-new-existing-minio-deployment

This procedure provides instructions for modifying the startup environment variables of a MinIO deployment to enable |SSE| via KES and the root KMS.

For instructions on new production deployments, reference the :ref:`Multi-Node Multi-Drive (Distributed) <minio-mnmd>` tutorial.
For instructions on new local or evaluation deployments, reference the :ref:`Single-Node Single-Drive <minio-snsd>` tutorial.

When creating the environment file for the deployment, pause and switch back to this tutorial to include the necessary environment variables to support |SSE|.

For existing MinIO Deployments, you can modify the existing environment file and restart the deployment as instructed during this procedure.

.. end-kes-new-existing-minio-deployment

.. start-kes-generate-kes-certs-desc

The following commands creates two TLS certificates that expire within 30 days of creation:

- A TLS certificate for KES to secure communications between it and the Vault deployment
- A TLS certificate for MinIO to perform mTLS authentication to KES.

For production environments, use certificates signed by a trusted Certificate Authority (CA). 
**DO NOT** use certificates generated using these instructions in production environments.

.. code-block:: shell
   :class: copyable

   kes tool identity new                             \
     --key  ~/minio-kes-vault/certs/kes-server.key   \
     --cert ~/minio-kes-vault/certs/kes-server.cert  \
     --ip   "127.0.0.1"                              \
     --dns  localhost

   kes tool identity new                            \
     --key  ~/minio-kes-vault/certs/minio-kes.key   \
     --cert ~/minio-kes-vault/certs/minio-kes.cert  \
     --ip   "127.0.0.1"                             \
     --dns  localhost

These commands outputs the keys to the ``~/minio-kes-vault/certs`` directory on the host operating system.

The ``--ip`` and ``--dns`` parameters set the IP and DNS ``SubjectAlternativeName`` for the certificate.
The above example assumes that all components (Vault, MinIO, and KES) deploy on the same local host machine accessible via ``localhost`` or ``127.0.0.1``.
You can specify additional IP or Hostnames based on the network configuration of your local host.

Depending on your Vault configuration, you may need to pass the ``kes-server.cert`` as a trusted Certificate Authority. See the `Hashicorp Server Configuration Documentation <https://www.vaultproject.io/docs/configuration/listener/tcp#tls_client_ca_file>`__ for more information.

Clients may need to add the ``kes-server.cert`` as a trusted CA to successfully validate the KES certificates and establish a TLS-secured connection.
Defer to the client documentation for instructions on trusting a third-party CA.

The ``minio-kes`` certificates are used only for mTLS between the MinIO deployment and the KES server, and do not otherwise enable TLS for other connections to the MinIO deployment.

.. end-kes-generate-kes-certs-desc

.. start-kes-run-server-desc

The first command allows |KES| to use the `mlock <http://man7.org/linux/man-pages/man2/mlock.2.html>`__ system call without running as root. 
``mlock`` ensures the OS does not write in-memory data to disk (swap memory) and mitigates the risk of cryptographic operations being written to unsecured disk at any time.

The second command starts the KES server in the foreground using the configuration file created in the last step. 
The ``--auth=off`` disables strict validation of client TLS certificates and is required if either the MinIO client or the root KMS server uses self-signed certificates.

.. code-block:: shell
   :class: copyable

   sudo setcap cap_ipc_lock=+ep $(readlink -f $(which kes))

   kes server --mlock                            \
               --config=~/kes/config/server-config.yaml  \
               --auth=off

|KES| listens on port ``7373`` by default. 
You can monitor the server logs from the terminal session. 
If you run |KES| without tying it to the current shell session (e.g. with ``nohup``), use that methods associated logging system (e.g. ``nohup.txt``).

.. end-kes-run-server-desc

.. start-kes-generate-key-desc

MinIO requires that the |EK| exist on the root KMS *before* performing |SSE| operations using that key. 
Use ``kes key create`` *or* :mc:`mc admin kms key create` to create a new |EK| for use with |SSE|.

The following command uses the ``kes key create`` command to create a new External Key (EK) stored on the root KMS server for use with encrypting the MinIO backend.

.. code-block:: shell
   :class: copyable

   export KES_SERVER=https://127.0.0.1:7373
   export KES_CLIENT_KEY=~/minio-kes-vault/minio-kes.key
   export KES_CLIENT_CERT=~/minio-kes-vault/minio-kes.cert

   kes key create -k encrypted-bucket-key

.. end-kes-generate-key-desc

.. start-kes-configuration-minio-desc

Add the following lines to the MinIO Environment file on each MinIO host.
See the tutorials for :ref:`minio-snsd`, :ref:`minio-snmd`, or :ref:`minio-mnmd` for complete descriptions of a base MinIO environment file.

This command assumes the ``minio-kes.cert``, ``minio-kes.key``, and ``kes-server.cert`` certificates are accessible at the specified location:

.. code-block:: shell
   :class: copyable

   # Add these environment variables to the existing environment file

   MINIO_KMS_KES_ENDPOINT=https://HOSTNAME:7373
   MINIO_KMS_KES_CERT_FILE=~/minio-kes.cert
   MINIO_KMS_KES_KEY_FILE=~/minio-kes.key
   MINIO_KMS_KES_CAPATH=~/server.cert
   MINIO_KMS_KES_KEY_NAME=minio-backend-default-key

   minio server [ARGUMENTS]

- Replace ``HOSTNAME`` with the IP address or the hostname for the host machine running the KES server or pod started in the previous step. 

  For distributed KES deployments, use the address of the load balancer or reverse proxy responsible for managing connections to the KES hosts.

MinIO uses the :envvar:`MINIO_KMS_KES_KEY_NAME` key for the following cryptographic operations:

- Encrypting the MinIO backend (IAM, configuration, etc.)
- Performing :ref:`SSE-KMS <minio-encryption-sse-kms>` if the request does not 
  include a specific |EK|.
- Performing :ref:`SSE-S3 <minio-encryption-sse-s3>`.

.. end-kes-configuration-minio-desc

.. start-kes-enable-sse-kms-desc

You can use either the MinIO Console or the MinIO :mc:`mc` CLI to enable bucket-default SSE-KMS with the generated key:

.. tab-set::

   .. tab-item:: MinIO Console

      Open the MinIO Console by navigating to http://127.0.0.1:9090 in your preferred browser and logging in with the root credentials specified to the MinIO container.

      Once logged in, create a new Bucket and name it to your preference.
      Select the Gear :octicon:`gear` icon to open the management view.

      Select the pencil :octicon:`pencil` icon next to the :guilabel:`Encryption` field to open the modal for configuring a bucket default SSE scheme.

      Select :guilabel:`SSE-KMS`, then enter the name of the key created in the previous step.

      Once you save your changes, try to upload a file to the bucket. 
      When viewing that file in the object browser, note that in the sidebar the metadata includes the SSE encryption scheme and information on the key used to encrypt that object.
      This indicates the successful encrypted state of the object.

   .. tab-item:: MinIO CLI

      The following commands:
      
      - Create a new :ref:`alias <alias>` for the MinIO deployment
      - Create a new bucket for storing encrypted data
      - Enable SSE-KMS encryption on that bucket

      .. code-block:: shell
         :class: copyable

         mc alias set local http://127.0.0.1:9000 ROOTUSER ROOTPASSWORD

         mc mb local/encryptedbucket
         mc encrypt set SSE-KMS encrypted-bucket-key ALIAS/encryptedbucket

      Write a file to the bucket using :mc:`mc cp` or any S3-compatible SDK with a ``PutObject`` function. 
      You can then run :mc:`mc stat` on the file to confirm the associated encryption metadata.

.. end-kes-enable-sse-kms-desc

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