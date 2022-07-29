.. start-common-deploy-create-pod-and-containers

Use the following commands to create the following resources:

- A Podman :podman-docs:`Pod <markdown/podman-pod.1.html>` to facilitate container communications
- A Container for the KES Server configured to use Hashicorp Vault as the Root |KMS|.
- A Container for a MinIO Server running in :ref:`Single-Node Single-Drive Mode <minio-snsd>`.

.. code-block:: shell
   :class: copyable
   :substitutions:

   sudo podman pod create                      \
     -p 9000:9000 -p 9090:9090 -p 7373:7373    \
     -v ~/minio-kes-vault/certs:/certs         \
     -v ~/minio-kes-vault/minio:/mnt/minio     \
     -v ~/minio-kes-vault/config:/etc/default/ \
     -n minio-kes-vault

   sudo podman run -dt                               \
     --cap-add IPC_LOCK                              \
     --name kes-server                               \
     --pod "minio-kes-vault"                         \
     -e KES_SERVER=https://127.0.0.1:7373            \
     -e KES_CLIENT_KEY=/certs/kes-server.key         \
     -e KES_CLIENT_CERT=/certs/kes-server.cert       \
     quay.io/minio/kes:|kes-stable| server          \
       --mlock --auth                                \
       --config=/etc/default/kes-server-config.yaml  \

   sudo podman run -dt                              \
     --name minio-server                            \
     --pod "minio-kes-vault"                        \
     -e "MINIO_CONFIG_ENV_FILE=/etc/default/minio"  \
     quay.io/minio/minio:|minio-latest| server      \
       --console-address ":9090"

You can verify the status of the containers using the following commands:

.. code-block:: shell
   :class: copyable

   # Should show three pods - one for the Pod, one for KES, and one for MinIO
   sudo podman container ls

If all pods are operational, you can connect to the MinIO deployment by opening your browser to http://127.0.0.1:9000 and logging in with the root credentials specified in the MinIO environment file.

.. end-common-deploy-create-pod-and-containers

.. start-kes-generate-kes-certs-desc

The following commands creates two TLS certificates:

- A TLS certificate for KES to secure communications between it and the Vault deployment
- A TLS certificate for MinIO to perform mTLS authentication to KES.

The certificates expires within 30 days of creation.
For production environments, use certificates signed by a trusted Certificate Authority (CA). 
**DO NOT** use certificates generated using these instructions in production environments.

.. code-block:: shell
    :class: copyable
    :substitutions:

    podman run --rm                                    \
      -v ~/minio-kes-vault/certs:/certs                \
      quay.io/minio/kes:|kes-stable| identity new     \
        --key  /certs/kes-server.key                   \
        --cert /certs/kes-server.cert                  \
        kes-server

    podman run --rm                                    \
      -v ~/minio-kes-vault/certs:/certs                \
      quay.io/minio/kes:|kes-stable| identity new     \
        --key  /certs/minio-kes.key                    \
        --cert /certs/minio-kes.cert                   \
        minio-server

These commands outputs the keys to the ``~/minio-kes-vault/certs`` directory on the host operating system.

Depending on your Vault configuration, you may need to pass the ``kes-server.cert`` as a trusted Certificate Authority. See the `Hashicorp Vault Configuration Docs <https://www.vaultproject.io/docs/configuration/listener/tcp#tls_client_ca_file>`__ for more information.

Clients may need to add the ``kes-server.cert`` as a trusted CA to successfully validate the KES certificates and establish a TLS-secured connection.
Defer to the client documentation for instructions on trusting a third-party CA.

The ``minio-kes`` certificates are used only for mTLS between the MinIO deployment and the KES server, and do not otherwise enable TLS for other connections to MinIO.

.. end-kes-generate-kes-certs-desc


.. start-kes-configuration-minio-desc

Create the MinIO Environment file at  ``~/minio-kes-vault/config/minio``.
See the tutorial for :ref:`minio-snsd`  for complete descriptions of a base MinIO environment file.

This command assumes the ``minio-kes.cert``, ``minio-kes.key``, and ``kes-server.cert`` certificates are accessible at the specified location:

.. code-block:: shell
   :class: copyable

   MINIO_ROOT_USER=myminioadmin
   MINIO_ROOT_PASSWORD=minio-secret-key-change-me
   MINIO_VOLUMES="/mnt/data"

   # KES Configurations

   MINIO_KMS_KES_ENDPOINT=https://127.0.0.1:7373
   MINIO_KMS_KES_CERT_FILE=~/minio-kes.cert
   MINIO_KMS_KES_KEY_FILE=~/minio-kes.key
   MINIO_KMS_KES_CAPATH=~/server.cert
   MINIO_KMS_KES_KEY_NAME=minio-backend-default-key

MinIO uses the :envvar:`MINIO_KMS_KES_KEY_NAME` key for the following cryptographic operations:

- Encrypting the MinIO backend (IAM, configuration, etc.)
- Performing :ref:`SSE-KMS <minio-encryption-sse-kms>` if the request does not 
  include a specific |EK|.
- Performing :ref:`SSE-S3 <minio-encryption-sse-s3>`.

KES automatically creates this key if it does not already exist on the root KMS.

.. end-kes-configuration-minio-desc

.. start-kes-run-server-vault-desc

The following commands do the following:

- Create a Pod for the MinIO and KES containers
- Start the KES Container attached to the Pod
- Start the MinIO Container attached to the Pod

The commands include setting an environment variable for the Vault :ref:`Vault AppRole credentials <minio-sse-vault-prereq-vault>`.
These values automatically substitute into the configuration file when running the container.

All commands assume starting the container in "Rootfull" mode. 
"Rootless" configurations may work depending on your local host configuration.

.. code-block:: shell
   :class: copyable
   :substitutions:

   # Creates the Pod named 'minio-kes-vault'
   # Exposes ports for MinIO, KES, and Vault for all containers attached to the pod
   # Attaches local host volumes to any container in the Pod at the specified paths

   sudo podman pod create \
     -p 9000:9000 -p 9090:9090 -p 7373:7373 -p 8200:8200 \
     -v ~/pods/minio-sse-local/minio:/mnt/data \
     -v ~/pods/minio-sse-local/certs:/certs \
     -v ~/pods/minio-sse-local/keys:/keys \
     -v ~/pods/minio-sse-local/config:/etc/default \
     -n minio-kes-vault 

   # Runs the KES container attached to the `minio-kes-vault` Pod
   # Sets environment variables to allow accessing the KES server using the container KES client
   # Disables verification of TLS certificates to allow using self-signed client certs
   # Enables ``mlock`` system call for better security
   # Disables verification of client TLS certificates to support self-signed certs

   sudo podman run -t \
   --cap-add IPC_LOCK \
   --name kes-server \
   --pod "minio-kes-vault" \
   -e KES_SERVER=https://127.0.0.1:7373 \
   -e KES_CLIENT_KEY=/certs/minio-kes.key \
   -e KES_CLIENT_CERT=/certs/minio-kes.cert \
   -e VAULTAPPID="vault-app-id" \
   -e VAULTAPPSECRET="vault-app-secret"
   kes:|kes-stable| server \
      --mlock \
      --config=/etc/default/kes-server-config.yaml \
      --auth=off

   # Runs the MinIO container attached to the `minio-kes-vault` Pod
   # Sets an environment variable pointing to the MinIO Environment file
   # Starts the server with a dedicated console port of ``9090``

   sudo podman run -t \
     -e "MINIO_CONFIG_ENV_FILE=/etc/default/minio" \
     --name "minio" \
     --pod "minio-kes-vault" \
     minio:|minio-latest| server --console-address ":9090"

You can verify the installation by opening your Internet Browser and navigating to http://127.0.0.1:9090 and logging in with your MinIO Root Credentials.

.. end-kes-run-server-vault-desc

.. start-kes-generate-key-desc

MinIO requires that the |EK| exist on the root KMS *before* performing
|SSE| operations using that key. Use ``kes key create`` *or*
:mc:`mc admin kms key create` to create a new |EK| for use with |SSE|.

The following command uses the ``kes key create`` command to create a new
External Key (EK) stored on the root KMS server for use with encrypting
the MinIO backend.

.. code-block:: shell
   :class: copyable
   :substitutions:

   sudo podman run --rm \
     -e KES_SERVER=https://127.0.0.1:7373 \
     -e KES_CLIENT_KEY=~/minio-kes-vault/certs/minio-kes.key \
     -e KES_CLIENT_CERT=~/minio-kes-vault/certs/minio-kes.cert \
     kes:|kes-stable| key create -k my-new-encryption-key

You can specify any key name as appropriate for your use case, such as a bucket-specific key ``minio-mydata-key``.

.. end-kes-generate-key-desc
