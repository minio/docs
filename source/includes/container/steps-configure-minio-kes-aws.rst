(Podman) Deploy MinIO and KES with Server-Side Encryption using AWS Secrets Manager
-----------------------------------------------------------------------------------

Prior to starting these steps, create the following folders:

.. code-block:: shell
   :class: copyable
   :substitutions:

   mkdir -P |kescertpath|
   mkdir -P |kesconfigpath|
   mkdir -P |miniodatapath|

For Windows hosts, substitute the paths with Windows-style paths, e.g. ``C:\minio-kes-vault\``.


1) Generate TLS Certificates for KES and MinIO
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/container/common-minio-kes.rst
   :start-after: start-kes-generate-kes-certs-desc
   :end-before: end-kes-generate-kes-certs-desc

Depending on your Vault configuration, you may need to pass the ``kes-server.cert`` as a trusted Certificate Authority. See the `Hashicorp Vault Configuration Docs <https://www.vaultproject.io/docs/configuration/listener/tcp#tls_client_ca_file>`__ for more information.
Defer to the client documentation for instructions on trusting a third-party CA.

2) Create the KES and MinIO Configurations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

a. Create the KES Configuration File

   Create the configuration file using your preferred text editor.
   The following example uses ``nano``:

   .. code-block:: shell
      :substitutions:

      nano |kesconfigpath|/kes-config.yaml

   .. include:: /includes/common/common-minio-kes-aws.rst
      :start-after: start-kes-configuration-aws-desc
      :end-before: end-kes-configuration-aws-desc

   - Set ``MINIO_IDENTITY_HASH`` to the identity hash of the MinIO mTLS certificate.

      The following command computes the necessary hash:

      .. code-block:: shell
         :class: copyable
         :substitutions:

         podman run --rm                                             \
            -v |kescertpath|/certs:/certs                                \
            kes:|kes-stable| tool identity of /certs/minio-kes.cert

   - Set ``MINIO_IDENTITY_HASH`` to the identity hash of the MinIO mTLS certificate.

      The following command computes the necessary hash:

      .. code-block:: shell
         :class: copyable
         :substitutions:

         podman run --rm                                             \
            -v |kescertpath|/certs:/certs                                \
            kes:|kes-stable| tool identity of /certs/minio-kes.cert

   - Replace the ``REGION`` with the appropriate region for AWS Secrets Manager.
     The value **must** match for both ``endpoint`` and ``region``.

   - Set ``AWSACCESSKEY`` and ``AWSSECRETKEY`` to the appropriate :ref:`AWS Credentials <minio-sse-aws-prereq-aws>`.

b. Create the MinIO Environment File

   Create the environment file using your preferred text editor.
   The following example uses ``nano``:

   .. code-block:: shell
      :substitutions:

      nano |minioconfigpath|/minio

   .. include:: /includes/container/common-minio-kes.rst
      :start-after: start-kes-configuration-minio-desc
      :end-before: end-kes-configuration-minio-desc

3) Create Pod and Containers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/container/common-minio-kes.rst
   :start-after: start-common-deploy-create-pod-and-containers
   :end-before: end-common-deploy-create-pod-and-containers

4) Generate a New Encryption Key
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/container/common-minio-kes.rst
   :start-after: start-kes-generate-key-desc
   :end-before: end-kes-generate-key-desc

5) Enable SSE-KMS for a Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can use either the MinIO Console or the MinIO :mc:`mc` CLI to enable bucket-default SSE-KMS with the generated key:

.. tab-set::

   .. tab-item:: MinIO Console

      Open the MinIO Console by navigating to http://127.0.0.1:9001 in your preferred browser and logging in with the root credentials specified to the MinIO container.

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
