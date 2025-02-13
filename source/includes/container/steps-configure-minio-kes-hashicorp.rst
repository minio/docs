Deploy MinIO and KES with Server-Side Encryption
------------------------------------------------

Prior to starting these steps, create the following folders:

.. code-block:: shell
   :class: copyable
   :substitutions:

   mkdir -p |kescertpath|
   mkdir -p |kesconfigpath|
   mkdir -p |miniodatapath|

For Windows hosts, substitute the paths with Windows-style paths, e.g. ``C:\minio-kes-vault\``.


Prerequisite
~~~~~~~~~~~~

Depending on your chosen :kes-docs:`supported KMS target <#supported-kms-targets>` configuration, you may need to pass the ``kes-server.cert`` as a trusted Certificate Authority (CA).
Defer to the client documentation for instructions on trusting a third-party CA.

1) Create the KES and MinIO Configurations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

a. Create the KES Configuration File

   Create the configuration file using your preferred text editor.
   The following example uses ``nano``:

   .. code-block:: shell
      :substitutions:

      nano |kesconfigpath|/kes-config.yaml

   .. include:: /includes/common/common-minio-kes-hashicorp.rst
      :start-after: start-kes-configuration-hashicorp-vault-desc
      :end-before: end-kes-configuration-hashicorp-vault-desc

   - Set ``MINIO_IDENTITY_HASH`` to the identity hash of the MinIO mTLS certificate.

      The following command computes the necessary hash:

      .. code-block:: shell
         :class: copyable
         :substitutions:

         podman run --rm                                             \
            -v |kescertpath|/certs:/certs                                \
            kes:|kes-stable| tool identity of /certs/minio-kes.cert

   - Refer to the instructions for setting up KES for your :kes-docs:`supported KMS solution <#kes-supported-targets>` for additional variables to define specific to your chosen KMS target.

b. Create the MinIO Environment File

   Create the environment file using your preferred text editor.
   The following example uses ``nano``:

   .. code-block:: shell
      :substitutions:

      nano |minioconfigpath|/minio

   .. include:: /includes/container/common-minio-kes.rst
      :start-after: start-kes-configuration-minio-desc
      :end-before: end-kes-configuration-minio-desc

2) Create Pod and Containers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/container/common-minio-kes.rst
   :start-after: start-common-deploy-create-pod-and-containers
   :end-before: end-common-deploy-create-pod-and-containers

3) Generate a New Encryption Key
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/container/common-minio-kes.rst
   :start-after: start-kes-generate-key-desc
   :end-before: end-kes-generate-key-desc

4) Enable SSE-KMS for a Bucket
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
