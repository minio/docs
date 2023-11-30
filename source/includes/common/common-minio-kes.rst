.. The following sections are common among all KES-related tutorials
.. Use the /includes/<platform>/common-minio-kes.rst file for platform-specific overrides.

.. start-kes-encrypted-backend-desc

Enabling |SSE| on a MinIO deployment automatically encrypts the backend data for that deployment using the default encryption key.

MinIO *requires* access to KES *and* the root KMS to decrypt the backend and start normally.
You cannot disable KES later or "undo" the |SSE| configuration at a later point.

.. end-kes-encrypted-backend-desc

.. start-kes-new-existing-minio-deployment-desc

This procedure provides instructions for modifying the startup environment variables of a MinIO deployment to enable |SSE| via KES and the root KMS.

For instructions on new production deployments, see the :ref:`Multi-Node Multi-Drive (Distributed) <minio-mnmd>` tutorial.
For instructions on new local or evaluation deployments, see the :ref:`Single-Node Single-Drive <minio-snsd>` tutorial.

When creating the environment file for the deployment, pause and switch back to this tutorial to include the necessary environment variables to support |SSE|.

For existing MinIO Deployments, you can modify the existing environment file and restart the deployment as instructed during this procedure.

.. end-kes-new-existing-minio-deployment-desc

.. start-kes-generate-kes-certs-desc

The following commands create two TLS certificates that expire within 30 days of creation:

- A TLS certificate for KES to secure communications between it and the Vault deployment
- A TLS certificate for MinIO to perform mTLS authentication to KES.

.. admonition:: Use Caution in Production Environments
   :class: important

   **DO NOT** use the TLS certificates generated as part of this procedure for
   any long-term development or production environments. 

   Defer to organization/industry best practices around TLS certificate
   generation and management. A complete guide to creating valid certificates
   (e.g. well-formed, current, and trusted) is beyond the scope of this
   procedure.

.. code-block:: shell
   :class: copyable
   :substitutions:

   # These commands output keys to |kescertpath|
   # and |miniocertpath| respectively

   kes identity new kes_server \
     --key  |kescertpath|/kes-server.key  \
     --cert |kescertpath|/kes-server.cert  \
     --ip   "127.0.0.1"  \
     --dns  localhost

   kes identity new minio_server \
     --key  |miniocertpath|/minio-kes.key  \
     --cert |miniocertpath|/minio-kes.cert  \
     --ip   "127.0.0.1"  \
     --dns  localhost

The ``--ip`` and ``--dns`` parameters set the IP and DNS ``SubjectAlternativeName`` for the certificate.
The above example assumes that all components (Vault, MinIO, and KES) deploy on the same local host machine accessible via ``localhost`` or ``127.0.0.1``.
You can specify additional IP or Hostnames based on the network configuration of your local host.

.. end-kes-generate-kes-certs-desc

.. start-kes-minio-start-server-desc

Run the following command in a terminal or shell to start the MinIO server as a foreground process.

.. code-block:: shell
   :class: copyable
   :substitutions:

   export MINIO_CONFIG_ENV_FILE=|minioconfigpath|/minio
   minio server --console-address :9001

.. end-kes-minio-start-server-desc

.. start-kes-start-server-desc

Run the following commands in a terminal or shell to start the KES server as a foreground process:

.. code-block:: shell
   :class: copyable
   :substitutions:

   sudo setcap cap_ipc_lock=+ep $(readlink -f $(which kes))

   kes server --auth=off --config=|kesconfigpath|/kes-config.yaml
               

The first command allows |KES| to use the `mlock <http://man7.org/linux/man-pages/man2/mlock.2.html>`__ system call without running as root. 
``mlock`` ensures the OS does not write in-memory data to a drive (swap memory) and mitigates the risk of cryptographic operations being written to unsecured drive at any time.
KES 0.21.0 and later automatically detect and enable ``mlock`` if supported by the host OS. 
Versions 0.20.0 and earlier required specifying the ``--mlock`` argument to KES.

The second command starts the KES server in the foreground using the configuration file created in the last step. 
The ``--auth=off`` disables strict validation of client TLS certificates.
Using self-signed certificates for either the MinIO client or the root KMS server requires specifying this option.

|KES| listens on port ``7373`` by default. 
You can monitor the server logs from the terminal session. 
If you run |KES| without tying it to the current shell session (e.g. with ``nohup``), use that method's associated logging system (e.g. ``nohup.txt``).


.. end-kes-start-server-desc

.. start-kes-generate-key-desc

MinIO requires that the |EK| exist on the root KMS *before* performing |SSE| operations using that key. 
Use ``kes key create`` *or* :mc-cmd:`mc admin kms key create` to add a new |EK| for use with |SSE|.

The following command uses the :mc-cmd:`mc admin kms key create` command to add a new External Key (EK) stored on the root KMS server for use with encrypting the MinIO backend.

.. code-block:: shell
   :class: copyable

   mc admin kms key create ALIAS KEYNAME

.. end-kes-generate-key-desc

.. start-kes-configuration-minio-desc

Add the following lines to the MinIO Environment file on each MinIO host.
See the tutorials for :ref:`minio-snsd`, :ref:`minio-snmd`, or :ref:`minio-mnmd` for more detailed descriptions of a base MinIO environment file.

.. code-block:: shell
   :class: copyable
   :substitutions:

   # Add these environment variables to the existing environment file

   MINIO_KMS_KES_ENDPOINT=https://HOSTNAME:7373
   MINIO_KMS_KES_API_KEY="kes:v1:ACTpAsNoaGf2Ow9o5gU8OmcaG6Af/VcZ1Mt7ysuKoBjv"

   # Allows validation of the KES Server Certificate (Self-Signed or Third-Party CA)
   # Change this path to the location of the KES CA Path
   MINIO_KMS_KES_CAPATH=|kescertpath|/kes-server.cert

   # Sets the default KMS key for the backend and SSE-KMS/SSE-S3 Operations)
   MINIO_KMS_KES_KEY_NAME=minio-backend-default-key

   # Optional, defines the name for the KES server enclave to use.
   # MINIO_KMS_KES_ENCLAVE=<name>

Replace ``HOSTNAME`` with the IP address or hostname of the KES server.
If the MinIO server host machines cannot resolve or reach the specified ``HOSTNAME``, the deployment may return errors or fail to start.

- If using a single KES server host, specify the IP or hostname of that host
- If using multiple KES server hosts, specify a comma-separated list of IPs or hostnames of each host

MinIO uses the :envvar:`MINIO_KMS_KES_KEY_NAME` key for the following cryptographic operations:

- Encrypting the MinIO backend (IAM, configuration, etc.)
- Encrypting objects using :ref:`SSE-KMS <minio-encryption-sse-kms>` if the request does not 
  include a specific |EK|.
- Encrypting objects using :ref:`SSE-S3 <minio-encryption-sse-s3>`.

MinIO uses the :envvar:`MINIO_KMS_KES_ENCLAVE` key to define the name of the KES enclave to use.

- Replace ``<name>`` with the name of the :term:`enclave` to use.
  If not defined, MinIO does not send any enclave information.
  This may result in using the default enclave for stateful KES servers.

  A KES :term:`enclave` provides an isolated space for its associated keys separate from other enclaves on a stateful KES server.

.. end-kes-configuration-minio-desc

.. start-kes-enable-sse-kms-desc

You can use either the MinIO Console or the MinIO :mc:`mc` CLI to enable bucket-default SSE-KMS with the generated key:

.. tab-set::

   .. tab-item:: MinIO Console

      Open the MinIO Console by navigating to http://127.0.0.1:9001 in your preferred browser and logging in with the root credentials specified to the MinIO container.
      If you deployed MinIO using a different Console listen port, substitute ``9090`` with that port value.

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
   configuration.

.. start-kes-conf-address-desc

The network address and port the KES server listens to on startup.
Defaults to port ``7373`` on all host network interfaces.

.. end-kes-conf-address-desc


.. start-kes-conf-root-desc

The identity for the KES superuser (``root``) identity. 
Clients connecting with a TLS certificate whose hash (``kes identity of client.cert``) matches this value have access to all KES API operations.

Specify ``disabled`` to remove the root identity and rely only on the ``policy`` configuration for controlling identity and access management to KES. 

.. end-kes-conf-root-desc


.. start-kes-conf-tls-desc

The TLS private key and certificate used by KES for establishing TLS-secured communications. 
Specify the full path for both the private ``.key`` and public ``.cert`` to the ``key`` and ``cert`` fields, respectively.

.. end-kes-conf-tls-desc

.. start-kes-conf-policy-desc

Specify one or more :minio-git:`policies <kes/wiki/Configuration#policy-configuration>` to control access to the KES server.

MinIO |SSE| requires access to the following KES cryptographic APIs:

- ``/v1/key/create/*``
- ``/v1/key/generate/*``
- ``/v1/key/decrypt/*``

Specifying additional keys does not expand MinIO |SSE| functionality and may violate security best practices around providing unnecessary client access to cryptographic key operations.

You can restrict the range of key names MinIO can create as part of performing
|SSE| by specifying a prefix before the ``*``. For example, 
``minio-sse-*`` only grants access to create, generate, or decrypt keys using
the ``minio-sse-`` prefix.

|KES| uses mTLS to authorize connecting clients by comparing the 
hash of the TLS certificate against the ``identities`` of each configured
policy. Use the ``kes identity of`` command to compute the identity of the
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