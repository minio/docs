.. _minio-sse-aws:

===============================================
Server-Side Object Encryption with AWS Root KMS
===============================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. |EK|      replace:: :abbr:`EK (External Key)`
.. |SSE|     replace:: :abbr:`SSE (Server-Side Encryption)`
.. |KMS|     replace:: :abbr:`KMS (Key Management System)`
.. |KES-git| replace:: :minio-git:`Key Encryption Service (KES) <kes>`
.. |KES|     replace:: :abbr:`KES (Key Encryption Service)`

MinIO Server-Side Encryption (SSE) protects objects as part of write operations,
allowing clients to take advantage of server processing power to secure objects
at the storage layer (encryption-at-rest). SSE also provides key functionality
to regulatory and compliance requirements around secure locking and erasure.

MinIO SSE uses |KES-git| and an
external root Key Management Service (KMS) for performing secured cryptographic
operations at scale. The root KMS provides stateful and secured storage of 
External Keys (EK) while |KES| is stateless and derives additional cryptographic
keys from the root-managed |EK|. 

This procedure does the following:

- Configure |KES| to use  
  `AWS Secrets Manager <https://aws.amazon.com/secrets-manager/>`__ as the root 
  |KMS|.

- Configure MinIO to use the |KES| instance for supporting |SSE|.
  
- Configure automatic bucket-default 
  :ref:`SSE-KMS <minio-encryption-sse-kms>` and 
  :ref:`SSE-S3 <minio-encryption-sse-s3>`.

Prerequisites
-------------

.. _minio-sse-aws-prereq-aws:

AWS Key Management Service
~~~~~~~~~~~~~~~~~~~~~~~~~~

This procedure assumes familiarity with 
`AWS Key Management Service <https://aws.amazon.com/kms/>`__ and
`AWS Secrets Manager <https://aws.amazon.com/secrets-manager/>`__. 
The `Getting Started with AWS Key Management Service
<https://aws.amazon.com/kms/getting-started/>`__
provides a sufficient foundation for the purposes of this procedure.

MinIO specifically requires the following AWS settings or
configurations:

- A new AWS 
  :aws-docs:`Programmatic Access <IAM/latest/UserGuide/id_users_create.html>`
  user  with corresponding access key and secret key.

- A policy that grants the created user access to AWS Secrets Manager and 
  AWS KMS. The following policy grants the minimum necessary permissions:

  .. code-block:: json
     :class: copyable

     {
       "Version": "2012-10-17",
       "Statement": [
         {
           "Sid": "minioSecretsManagerAccess",
           "Action": [
             "secretsmanager:CreateSecret",
             "secretsmanager:DeleteSecret",
             "secretsmanager:GetSecretValue",
             "secretsmanager:ListSecrets"
           ],
           "Effect": "Allow",
           "Resource": "*"
         },
         {
           "Sid": "minioKmsAccess",
           "Action": [
             "kms:Decrypt",
             "kms:DescribeKey",
             "kms:Encrypt"
           ],
           "Effect": "Allow",
           "Resource": "*"
         }
       ]
     }

  
  AWS provides the ``SecretsManagerReadWrite`` and
  ``AWSKeyManagementServicePowerUser`` canned roles that meet and exceed the
  minimum required permissions.

Network Encryption (TLS)
~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-kes.rst
   :start-after: start-kes-network-encryption-desc
   :end-before: end-kes-network-encryption-desc

Podman Container Manager
~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-kes.rst
   :start-after: start-kes-podman-desc
   :end-before: end-kes-podman-desc

Enable MinIO Server-Side Encryption with AWS Root KMS
-----------------------------------------------------

The following steps deploy |KES-git| configured to use an existing AWS KMS and
Secrets Manager deployment as the root KMS for supporting |SSE|. These steps
assume the AWS components meet the :ref:`prerequisites
<minio-sse-aws-prereq-aws>`.

Prior to starting these steps, create the following folders:

.. code-block:: shell
   :class: copyable

   mkdir -P ~/kes/certs ~/kes/config

1) Download the MinIO Key Encryption Service
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-kes.rst
   :start-after: start-kes-download-desc
   :end-before: end-kes-download-desc

2) Generate the TLS Private and Public Key for KES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-kes.rst
   :start-after: start-kes-generate-kes-certs-desc
   :end-before: end-kes-generate-kes-certs-desc

3) Generate the TLS Private and Public Key for MinIO
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-kes.rst
   :start-after: start-kes-generate-minio-certs-desc
   :end-before: end-kes-generate-minio-certs-desc

4) Create the KES Configuration File
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

|KES| uses a YAML-formatted configuration file. The following example YAML
specifies the minimum required fields for enabling |SSE| using AWS Secrets
Manager:

.. code-block:: shell
   :class: copyable

   address: 0.0.0.0:7373

   # Disable the root identity, as we do not need that level of access for
   # supporting SSE operations.
   root: disabled

   # Specify the TLS keys generated in the previous step here
   # For production environments, use keys signed by a known and trusted
   # Certificate Authority (CA).
   tls:
     key:  /data/certs/server.key
     cert: /data/certs/server.cert

   # Create a policy named 'minio' that grants access to the 
   # /create, /generate, and /decrypt KES APIs for any key name
   # KES uses mTLS to grant access to this policy, where only the client 
   # whose TLS certificate hash matches one of the "identities" can
   # use this policy. Specify the hash of the MinIO server TLS certificate
   # hash here.
   policy:
     minio:
       allow:
       - /v1/key/create/*
       - /v1/key/generate/*
       - /v1/key/decrypt/*
       identities:
       - ${MINIO_IDENTITY_HASH} # Replace with the output of 'kes tool identity of minio-kes.cert'

   # Specify the connection information for the KMS and Secrets Manager endpoint.
   # The endpoint should be resolvable from the host.
   # This example assumes that the associated AWS account has the necessary
   # access key and secret key
   keystore:
     secretsmanager:
       endpoint: secretsmanager.REGION.amazonaws # use the Secrets Manager endpoint for your region
       region: REGION # e.g. us-east-1
       kmskey: "" # Optional. The root AWS KMS key to use for cryptographic operations. Formerly described as the "Customer Master Key".
       credentials:
         accesskey: "${AWSACCESSKEY}" # AWS Access Key
         secretkey: "${AWSSECRETKEY}" # AWS Secret Key


Save the configuration file as ``~/kes/config/kes-config.yaml``. Any field with
value ``${VARIABLE}`` uses the environment variable with matching name as the
value. You can use this functionality to set credentials without writing them to
the configuration file.

- Set ``MINIO_IDENTITY_HASH`` to the output of 
  ``kes tool identity of minio-kes.cert``.

- Replace the ``REGION`` with the appropriate region for AWS Secrets Manager.
  The value **must** match for both ``endpoint`` and ``region``.

- Set ``AWSACCESSKEY`` and ``AWSSECRETKEY`` to the appropriate
  :ref:`AWS Credentials <minio-sse-aws-prereq-aws>`.

5) Start KES
~~~~~~~~~~~~

.. include:: /includes/common-minio-kes.rst
   :start-after: start-kes-run-server-desc
   :end-before: end-kes-run-server-desc

6) Generate a Cryptographic Key
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


.. include:: /includes/common-minio-kes.rst
   :start-after: start-kes-generate-key-desc
   :end-before: end-kes-generate-key-desc

7) Configure MinIO to connect to KES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-kes.rst
   :start-after: start-kes-configure-minio-desc
   :end-before: end-kes-configure-minio-desc

8) Enable Automatic Server-Side Encryption
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. tab-set::

   .. tab-item:: SSE-KMS

      The following command enables SSE-KMS on all objects written to the
      specified bucket:

      .. code-block:: shell
         :class: copyable

         mc mb ALIAS/encryptedbucket
         mc encrypt set SSE-KMS encrypted-bucket-key ALIAS/encryptedbucket

      Replace ``ALIAS`` with the :mc:`alias <mc alias>` of the MinIO
      deployment configured in the previous step.

      Write a file to the bucket using :mc:`mc cp` or any S3-compatible
      SDK with a ``PutObject`` function. You can then run :mc:`mc stat` 
      on the file to confirm the associated encryption metadata.

   .. tab-item:: SSE-S3

      The following command enables SSE-S3 on all objects written to the
      specified bucket. MinIO uses the :envvar:`MINIO_KMS_KES_KEY_NAME` 
      key for performing |SSE|.

      .. code-block:: shell
         :class: copyable

         mc mb ALIAS/encryptedbucket
         mc encrypt set SSE-S3 ALIAS/encryptedbucket

      Replace ``ALIAS`` with the :mc:`alias <mc alias>` of the MinIO
      deployment configured in the previous step.

      Write a file to the bucket using :mc:`mc cp` or any S3-compatible
      SDK with a ``PutObject`` function. You can then run :mc:`mc stat` 
      on the file to confirm the associated encryption metadata.

Configuration Reference for AWS Root KMS
----------------------------------------

The following section describes each of the |KES-git| configuration settings for
using AWS Secrets Manager and AWS KMS as the root Key Management Service
(KMS) for |SSE|:

.. tab-set::

   .. tab-item:: YAML Overview

      The following YAML describes the minimum required fields for configuring
      AWS Secrets Manager as an external KMS for supporting |SSE|. 

      Any field with value ``${VARIABLE}`` uses the environment variable 
      with matching name as the value. You can use this functionality to set
      credentials without writing them to the configuration file.

      .. code-block:: yaml

         address: 0.0.0.0:7373
         root: ${ROOT_IDENTITY}

         tls:
           key: kes-server.key
           cert: kes-server.cert

         policy:
           minio-server:
             allow:
               - /v1/key/create/*
               - /v1/key/generate/*
               - /v1/key/decrypt/*
             identities:
             - ${MINIO_IDENTITY}
         
         keys:
           - name: "minio-encryption-key-alpha"
           - name: "minio-encryption-key-baker"
           - name: "minio-encryption-key-charlie"

         keystore:
           secretsmanager:
             endpoint: secretsmanager.REGION.amazonaws 
             region: REGION
             kmskey: "" 
             credentials:
               accesskey: "${AWS_ACCESS_KEY}" 
               secretkey: "${AWS_SECRET_KEY}" 

   .. tab-item:: Reference

      .. list-table::
         :header-rows: 1
         :widths: 30 70
         :width: 100%

         * - Key
           - Description

         * - ``address``
           - .. include:: /includes/common-minio-kes.rst
                :start-after: start-kes-conf-address-desc
                :end-before: end-kes-conf-address-desc

         * - ``root``
           - .. include:: /includes/common-minio-kes.rst
                :start-after: start-kes-conf-root-desc
                :end-before: end-kes-conf-root-desc

         * - ``tls``
           - .. include:: /includes/common-minio-kes.rst
                :start-after: start-kes-conf-tls-desc
                :end-before: end-kes-conf-tls-desc

         * - ``policy``
           - .. include:: /includes/common-minio-kes.rst
                :start-after: start-kes-conf-policy-desc
                :end-before: end-kes-conf-policy-desc

         *  - ``keys``
            - .. include:: /includes/common-minio-kes.rst
                 :start-after: start-kes-conf-keys-desc
                 :end-before: end-kes-conf-keys-desc

         * - ``keystore.secretsmanager``
           - The configuration for the AWS Secrets Manager and AWS KMS. 

             - ``endpoint`` - The endpoint for the Secrets Manager service,
               including the region. 

             - ``approle`` - The AWS region to use for other AWS services.

             - ``kmskey`` - The root KMS Key to use for cryptographic 
               operations. Formerly known as the Customer Master Key.

             - ``credentials`` - The AWS Credentials to use for performing
               authenticated operations against Secrets Manager and KMS.

               The specified credentials *must* have the appropriate
               :ref:`permissions <minio-sse-aws-prereq-aws>`
