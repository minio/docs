.. start-common-deploy-create-pod-and-containers

The commands in this section create the following resources:

- A Podman :podman-docs:`Pod <markdown/podman-pod.1.html>` to facilitate container communications
- A Container for the KES Server configured to use the chosen supported |KMS| solution.
- A Container for a MinIO Server running in :ref:`Single-Node Single-Drive Mode <minio-snsd>`.

.. code-block:: shell
   :class: copyable
   :substitutions:

   sudo podman pod create  \
     -p 9000:9000 -p 9001:9001 -p 7373:7373  \
     -v |kescertpath|:/certs  \
     -v |miniodatapath|:/mnt/minio  \
     -v |kesconfigpath|:/etc/default/  \
     -n |namespace|

   sudo podman run -dt  \
     --cap-add IPC_LOCK  \
     --name kes-server  \
     --pod "|namespace|"  \
     -e KES_SERVER=https://127.0.0.1:7373  \
     -e KES_CLIENT_KEY=/certs/kes-server.key  \
     -e KES_CLIENT_CERT=/certs/kes-server.cert  \
     quay.io/minio/kes:|kes-stable| server  \
       --auth  \
       --config=/etc/default/kes-config.yaml  \

   sudo podman run -dt  \
     --name minio-server  \
     --pod "|namespace|"  \
     -e "MINIO_CONFIG_ENV_FILE=/etc/default/minio"  \
     quay.io/minio/minio:|minio-latest| server  \
       --console-address ":9001"

You can verify the status of the containers using the following commands:

.. code-block:: shell
   :class: copyable

   # Should show three pods - one for the Pod, one for KES, and one for MinIO
   sudo podman container ls

If all pods are operational, you can connect to the MinIO deployment by opening your browser to http://127.0.0.1:9000 and logging in with the root credentials specified in the MinIO environment file.

.. end-common-deploy-create-pod-and-containers

.. start-kes-generate-kes-certs-desc

The following commands create two TLS certificates that expire within 30 days of creation:

- A TLS certificate to secure communications between KES and the |KMS| service.
- A TLS certificate for MinIO to perform mTLS authentication to KES.

.. admonition:: Use Caution in Production Environments
   :class: important

   **DO NOT** use the TLS certificates generated as part of this procedure for any long-term development or production environments. 

   Defer to organization/industry best practices around TLS certificate generation and management. 
   A complete guide to creating valid certificates (for example, well-formed, current, and trusted) is beyond the scope of this procedure.

.. code-block:: shell
    :class: copyable
    :substitutions:

    # These commands output keys to |kescertpath| and |miniocertpath| on the host operating system

    podman run --rm  \
      -v |kescertpath|:/certs  \
      quay.io/minio/kes:|kes-stable| identity new  kes_server \
        --key  /certs/kes-server.key  \
        --cert /certs/kes-server.cert  \
        kes-server

    podman run --rm  \
      -v |miniocertpath|:/certs  \
      quay.io/minio/kes:|kes-stable| identity new minio_server \
        --key  /certs/minio-kes.key  \
        --cert /certs/minio-kes.cert  \
        minio-server

.. end-kes-generate-kes-certs-desc


.. start-kes-configuration-minio-desc

This command assumes the ``minio-kes.cert``, ``minio-kes.key``, and ``kes-server.cert`` certificates are accessible at the specified location:

.. code-block:: shell
   :class: copyable

   MINIO_ROOT_USER=myminioadmin
   MINIO_ROOT_PASSWORD=minio-secret-key-change-me
   MINIO_VOLUMES="/mnt/data"

   # KES Configurations

   MINIO_KMS_KES_ENDPOINT=https://127.0.0.1:7373
   MINIO_KMS_KES_API_KEY=<API-key-identity-string-from-KES> # Replace with the key string for your credentials
   MINIO_KMS_KES_CAPATH=/certs/server.cert
   MINIO_KMS_KES_KEY_NAME=minio-backend-default-key

.. note::
   
   - An API key is the preferred way to authenticate with the KES server, as it provides a streamlined and secure authentication process to the KES server.

   - Alternatively, specify the :envvar:`MINIO_KMS_KES_KEY_FILE` and :envvar:`MINIO_KMS_KES_CERT_FILE` instead of :envvar:`MINIO_KMS_KES_API_KEY`.
     
     API keys are mutually exclusive with certificate-based authentication. 
     Specify *either* the API key variable *or* the Key File and Cert File variables.
   
   - The documentation on this site uses API keys.

MinIO uses the :envvar:`MINIO_KMS_KES_KEY_NAME` key for the following cryptographic operations:

- Encrypting the MinIO backend (IAM, configuration, etc.)
- Encrypting objects using :ref:`SSE-KMS <minio-encryption-sse-kms>` if the request does not include a specific |EK|.
- Encrypting objects using :ref:`SSE-S3 <minio-encryption-sse-s3>`.

The ``minio-kes`` certificates enable for mTLS between the MinIO deployment and the KES server *only*.
They do not otherwise enable TLS for other client connections to MinIO.

KES automatically creates this key if it does not already exist on the root KMS.

.. end-kes-configuration-minio-desc

.. start-kes-generate-key-desc

.. admonition:: Unseal Vault Before Creating Key
   :class: important

   If required for your chosen provider, you must unseal the backing |KMS| instance before creating new encryption keys.
   Refer to the documentation for your chosen KMS solution for more information.

MinIO requires that the |EK| exist on the root KMS *before* performing |SSE| operations using that key. 
Use :kes-docs:`kes key create <cli/kes-key/create/>` *or* :mc-cmd:`mc admin kms key create` to create a new |EK| for use with |SSE|.

The following command uses the :kes-docs:`kes key create <cli/kes-key/create/>` command to add a new External Key (EK) stored on the root KMS server for use with encrypting the MinIO backend.

.. code-block:: shell
   :class: copyable
   :substitutions:

   sudo podman run --rm  \
     -v |kescertpath|:/certs  \
     -e KES_SERVER=https://127.0.0.1:7373  \
     -e KES_CLIENT_KEY=/certs/minio-kes.key  \
     -e KES_CLIENT_CERT=/certs/minio-kes.cert  \
     kes:|kes-stable| key create -k my-new-encryption-key

You can specify any key name as appropriate for your use case, such as a bucket-specific key ``minio-mydata-key``.

.. end-kes-generate-key-desc
