This procedure assumes a single local host machine running the MinIO and KES processes.
As part of this procedure, you will:

- Deploy a |KES| server configured to use `Hashicorp Vault <https://www.vaultproject.io/>`__ as the root |KMS|.

- Create a new |EK| on Vault for use with |SSE|.

- Deploy a MinIO server configured to use the |KES| container for supporting |SSE|.

- Configure automatic bucket-default :ref:`SSE-KMS <minio-encryption-sse-kms>`.

For production environments, MinIO recommends using Linux hosts. 
See the MinIO on Linux documentation for configuring MinIO with KES and Hashicorp Vault.

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

Deploy or Ensure Access to a MinIO Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common/common-minio-kes.rst
   :start-after: start-kes-new-existing-minio-deployment
   :end-before: end-kes-new-existing-minio-deployment

Deploy MinIO and KES to Enable Server-Side Encryption with Hashicorp Vault
--------------------------------------------------------------------------

Prior to starting these steps, create the following folders:

.. code-block:: shell
   :class: copyable

   mkdir -P ~/minio-kes-vault/certs ~/minio-kes-vault/minio ~/minio-kes-vault/config

1) Download KES and Create the Service File
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/macos/common-minio-kes.rst
   :start-after: start-kes-download-desc
   :end-before: end-kes-download-desc

2) Generate TLS Certificates for KES and MinIO
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common/common-minio-kes.rst
   :start-after: start-kes-generate-kes-certs-desc
   :end-before: end-kes-generate-kes-certs-desc

3) Create the KES and MinIO Configurations
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

         kes tool identity of ~/minio-kes-vault/certs/minio-kes.cert

   - Replace the ``vault.endpoint`` with the hostname of the Vault server(s).

   - Replace the ``VAULTAPPID`` and ``VAULTAPPSECRET`` with the appropriate :ref:`Vault AppRole credentials <minio-sse-vault-prereq-vault>`.


b. Create the MinIO Environment File

   .. include:: /includes/common/common-minio-kes.rst
      :start-after: start-kes-configuration-minio-desc
      :end-before: end-kes-configuration-minio-desc

4) Start KES and MinIO
~~~~~~~~~~~~~~~~~~~~~~

You must start KES *before* starting MinIO. 
The MinIO deployment requires access to KES as part of its startup.

a. Start the KES Server

   .. include:: /includes/macos/common-minio-kes.rst
      :start-after: start-kes-start-server-desc
      :end-before: end-kes-start-server-desc

b. Start the MinIO Server

   .. include:: /includes/macos/common-minio-kes.rst
      :start-after: start-kes-minio-start-server-desc
      :end-before: end-kes-minio-start-server-desc

5) Generate a New Encryption Key
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common/common-minio-kes.rst
   :start-after: start-kes-generate-key-desc
   :end-before: end-kes-generate-key-desc

6) Enable SSE-KMS for a Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common/common-minio-kes.rst
   :start-after: start-kes-enable-sse-kms-desc
   :end-before: end-kes-enable-sse-kms-desc
