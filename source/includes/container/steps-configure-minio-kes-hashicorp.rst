This procedure assumes a single local host machine running the MinIO and KES processes as containers.
As part of this procedure, you will:

- Deploy a |KES| container configured to use `Hashicorp Vault <https://www.vaultproject.io/>`__ as the root |KMS|.

- Create a new |EK| on Vault for use with |SSE|.

- Deploy a MinIO container configured to use the |KES| container for supporting |SSE|.

- Configure automatic bucket-default :ref:`SSE-KMS <minio-encryption-sse-kms>`.

You can use the guidance in this tutorial for deploying MinIO with |SSE| enabled for other container-based topologies.

For production orchestrated environments, use the MinIO Kubernetes Operator to deploy a tenant with |SSE| enabled and configured for use with Hashicorp Vault.

.. important::

   .. include:: /includes/common/common-minio-kes.rst
      :start-after: start-kes-encrypted-backend-desc
      :end-before: end-kes-encrypted-backend-desc

Prerequisites
-------------

.. _minio-sse-vault-prereq-vault:

Deploy or Ensure Access to a Hashicorp Vault Service
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common/common-minio-kes-hashicorp.rst
   :start-after: start-kes-prereq-hashicorp-vault-desc
   :end-before: end-kes-prereq-hashicorp-vault-desc

Install Podman or a Similar Container Management Interface
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/container/common-deploy.rst
   :start-after: start-common-prereq-container-management-interface
   :end-before: end-common-prereq-container-management-interface

Use Podman to Deploy MinIO and KES with Hashicorp Vault for SSE
---------------------------------------------------------------

Prior to starting these steps, create the following folders:

.. code-block:: shell
   :class: copyable

   mkdir -P ~/minio-kes-vault/certs ~/minio-kes-vault/minio ~/minio-kes-vault/config

For Windows hosts, substitute the paths with Windows-style paths, e.g. ``C:\minio-kes-vault\``.


1) Generate TLS Certificates for KES and MinIO
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/container/common-minio-kes.rst
   :start-after: start-kes-generate-kes-certs-desc
   :end-before: end-kes-generate-kes-certs-desc


2) Create the KES and MinIO Configurations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

a. Create the KES Configuration File

   .. include:: /includes/common/common-minio-kes-hashicorp.rst
      :start-after: start-kes-configuration-hashicorp-vault-desc
      :end-before: end-kes-configuration-hashicorp-vault-desc

   Save the configuration file as ``~/minio-kes-vault/config/kes-config.yaml``. 

   - Set ``MINIO_IDENTITY_HASH`` to the identity hash of the MinIO mTLS certificate.

     The following command computes the necessary hash:

     .. code-block:: shell
        :class: copyable
        :substitutions:

        podman run --rm                                            \
           -v ~/minio-kes-vault/certs:/certs                        \
           kes:v|kes-stable| tool identity of /certs/minio-kes.cert

   - Replace the ``vault.endpoint`` with the hostname of the Vault server(s).

   - Replace the ``VAULTAPPID`` and ``VAULTAPPSECRET`` with the appropriate :ref:`Vault AppRole credentials <minio-sse-vault-prereq-vault>`.


b. Create the MinIO Environment File

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
