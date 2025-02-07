.. start-kes-generate-kes-certs-desc

The following commands creates two TLS certificates that expire within 30 days of creation:

- A TLS certificate for KES to secure communications between it and the KMS deployment
- A TLS certificate for MinIO to perform mTLS authentication to KES.

.. admonition:: Use Caution in Production Environments
   :class: important

   **DO NOT** use the TLS certificates generated as part of this procedure for
   any long-term development or production environments. 

   Defer to organization/industry best practices around TLS certificate generation and management. 
   A complete guide to creating valid certificates (for example, well-formed, current, and trusted) is beyond the scope of this procedure.

.. code-block:: powershell
   :class: copyable
   :substitutions:

   # These commands output the certificates to |kescertpath|

   C:\kes.exe identity new \  
     --key  |kescertpath|\kes-server.key \  
     --cert |kescertpath|\kes-server.cert \  
     --ip   "127.0.0.1" \  
     --dns  localhost

   C:\kes.exe identity new \  
     --key  |miniocertpath|\minio-kes.key \  
     --cert |miniocertpath|\minio-kes.cert \  
     --ip   "127.0.0.1" \  
     --dns  localhost

The ``--ip`` and ``--dns`` parameters set the IP and DNS ``SubjectAlternativeName`` for the certificate.
The above example assumes that all components (KMS, MinIO, and KES) deploy on the same local host machine accessible via ``localhost`` or ``127.0.0.1``.
You can specify additional IP or Hostnames based on the network configuration of your local host.

Depending on your KMS configuration, you may need to pass the ``kes-server.cert`` as a trusted Certificate Authority.
Defer to the client documentation for your chosen :kes-docs:`supported KMS target <#supported-kms-targets>` for instructions on trusting a third-party CA.

.. end-kes-generate-kes-certs-desc

.. start-kes-minio-start-server-desc

Run the following command in a terminal or shell to start the MinIO server as a foreground process.

.. code-block:: powershell
   :class: copyable
   :substitutions:

   export MINIO_CONFIG_ENV_FILE=|minioconfigpath|\config\minio
   C:\minio.exe server --console-address :9001

.. end-kes-minio-start-server-desc

.. start-kes-generate-key-desc

MinIO requires that the |EK| exist on the root KMS *before* performing |SSE| operations using that key. 
Use ``kes key create`` *or* :mc-cmd:`mc admin kms key create` to create a new |EK| for use with |SSE|.

The following command uses the ``kes key create`` command to create a new External Key (EK) stored on the root KMS server for use with encrypting the MinIO backend.

.. code-block:: powershell
   :class: copyable
   :substitutions:

   export KES_SERVER=https://127.0.0.1:7373
   export KES_CLIENT_KEY=|miniocertpath|\minio-kes.key
   export KES_CLIENT_CERT=|miniocertpath|\minio-kes.cert

   C:\kes.exe key create -k encrypted-bucket-key

.. end-kes-generate-key-desc

.. start-kes-new-existing-minio-deployment-desc

This procedure provides instructions for modifying the startup environment variables of a MinIO deployment to enable |SSE| via KES and the root KMS.
For instructions on new creating a new deployment, reference the :ref:`Single-Node Single-Drive <minio-snsd>` tutorial.

When creating the environment file for the deployment, pause and switch back to this tutorial to include the necessary environment variables to support |SSE|.

For existing MinIO Deployments, you can modify the existing environment file and restart the deployment as instructed during this procedure.

.. end-kes-new-existing-minio-deployment-desc

.. start-kes-configuration-minio-desc

Add the following lines to the MinIO Environment file on the Windows host.
See the tutorials for :ref:`minio-snsd` for more detailed descriptions of a base MinIO environment file.

This command assumes the ``minio-kes.cert``, ``minio-kes.key``, and ``kes-server.cert`` certificates are accessible at the specified location:

.. code-block:: powershell
   :class: copyable
   :substitutions:

   # Add these environment variables to the existing environment file

   MINIO_KMS_KES_ENDPOINT=https://127.0.0.1:7373
   MINIO_KMS_KES_API_KEY=<API-key-identity-string-from-KES>
   MINIO_KMS_KES_CAPATH=|miniocertpath|\kes-server.cert
   MINIO_KMS_KES_KEY_NAME=minio-backend-default-key


.. note::
   
   - An API key is the preferred way to authenticate with the KES server, as it provides a streamlined and secure authentication process to the KES server.

   - Alternatively, specify the :envvar:`MINIO_KMS_KES_KEY_FILE` and :envvar:`MINIO_KMS_KES_CERT_FILE` instead of :envvar:`MINIO_KMS_KES_API_KEY`.
     
     API keys are mutually exclusive with certificate-based authentication. 
     Specify *either* the API key variable *or* the Key File and Cert File variables.
   
   - The documentation on this site uses API keys.

   .. code-block:: shell
      :substitutions:

      MINIO_KMS_KES_CERT_FILE=|miniocertpath|\minio-kes.cert
      MINIO_KMS_KES_KEY_FILE=|miniocertpath|\minio-kes.key


MinIO uses the :envvar:`MINIO_KMS_KES_KEY_NAME` key for the following cryptographic operations:

- Encrypting the MinIO backend (IAM, configuration, etc.)
- Encrypting objects using :ref:`SSE-KMS <minio-encryption-sse-kms>` if the request does not include a specific |EK|.
- Encrypting objects using :ref:`SSE-S3 <minio-encryption-sse-s3>`.

The ``minio-kes`` certificates enable mTLS between the MinIO deployment and the KES server *only*.
They do not otherwise enable TLS for other client connections to MinIO.

.. end-kes-configuration-minio-desc
