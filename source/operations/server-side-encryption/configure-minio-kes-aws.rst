.. _minio-sse-aws:

===============================================================
Server-Side Object Encryption with AWS Secrets Manager Root KMS
===============================================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. |EK|            replace:: :abbr:`EK (External Key)`
.. |SSE|           replace:: :abbr:`SSE (Server-Side Encryption)`
.. |KMS|           replace:: :abbr:`KMS (Key Management System)`
.. |KES-git|       replace:: :minio-git:`Key Encryption Service (KES) <kes>`
.. |KES|           replace:: :abbr:`KES (Key Encryption Service)`
.. |rootkms|       replace:: `AWS Secrets Manager <https://aws.amazon.com/secrets-manager/>`__
.. |rootkms-short| replace:: AWS Secrets Manager

MinIO Server-Side Encryption (SSE) protects objects as part of write operations, allowing clients to take advantage of server processing power to secure objects at the storage layer (encryption-at-rest). 
SSE also provides key functionality to regulatory and compliance requirements around secure locking and erasure.

MinIO SSE uses |KES-git| and an external root Key Management Service (KMS) for performing secured cryptographic operations at scale. 
The root KMS provides stateful and secured storage of External Keys (EK) while |KES| is stateless and derives additional cryptographic keys from the root-managed |EK|. 

.. Conditionals to handle the slight divergences in procedures between platforms.

.. cond:: linux

   This procedure provides guidance for deploying and configuring KES at scale for a supporting |SSE| on a production MinIO deployment, with |rootkms| as the external root |KMS|.
   You can also use this procedure for deploying to local environments for testing and evaluation.

   As part of this procedure, you will:

   #. Deploy one or more |KES| servers configured to use |rootkms| as the root |KMS|.
      You may optionally deploy a load balancer for managing connections to those KES servers.

   #. Create a new |EK| on |rootkms-short| for use with |SSE|.

   #. Create or modify a MinIO deployment with support for |SSE| using |KES|.
      Defer to the :ref:`Deploy Distributed MinIO <minio-mnmd>` tutorial for guidance on production-ready MinIO deployments.

   #. Configure automatic bucket-default :ref:`SSE-KMS <minio-encryption-sse-kms>`

   For production orchestrated environments, use the MinIO Kubernetes Operator to deploy a tenant with |SSE| enabled and configured for use with |rootkms-short|.

.. cond:: macos or windows

   This procedure assumes a single local host machine running the MinIO and KES processes, with |rootkms| as the external root |KMS|..
   As part of this procedure, you will:

   #. Deploy a |KES| server configured to use |rootkms| as the root |KMS|.

   #. Create a new |EK| on Vault for use with |SSE|.

   #. Deploy a MinIO server in :ref:`Single-Node Single-Drive mode <minio-snsd>` configured to use the |KES| container for supporting |SSE|.

   #. Configure automatic bucket-default :ref:`SSE-KMS <minio-encryption-sse-kms>`.

   For production orchestrated environments, use the MinIO Kubernetes Operator to deploy a tenant with |SSE| enabled and configured for use with |rootkms-short|.

   For production baremetal environments, see the MinIO on Linux documentation for tutorials on configuring MinIO with KES and |rootkms-short|.

.. cond:: container

   This procedure assumes a single host machine running the MinIO and KES containers, with |rootkms| as the external root |KMS|..
   As part of this procedure, you will:

   #. Deploy a |KES| container configured to use |rootkms| as the root |KMS|.

   #. Create a new |EK| on Vault for use with |SSE|.

   #. Deploy a MinIO Server container in :ref:`Single-Node Single-Drive mode <minio-snsd>` configured to use the |KES| container for supporting |SSE|.

   #. Configure automatic bucket-default :ref:`SSE-KMS <minio-encryption-sse-kms>`.

   For production orchestrated environments, use the MinIO Kubernetes Operator to deploy a tenant with |SSE| enabled and configured for use with |rootkms-short|.

   For production baremetal environments, see the MinIO on Linux documentation for tutorials on configuring MinIO with KES and |rootkms-short|.

.. cond:: k8s

   This procedure assumes you have access to a Kubernetes cluster with an active MinIO Operator installation, with a cluster-accessible |rootkms| service as the external root |KMS|.
   As part of this procedure, you will:

   #. Use the MinIO Operator Console to create or manage a MinIO Tenant.
   #. Access the :guilabel:`Encryption` settings for that tenant and configure |SSE| using |rootkms| as the root |KMS|.
   #. Create a new |EK| on Vault for use with |SSE|.
   #. Configure automatic bucket-default :ref:`SSE-KMS <minio-encryption-sse-kms>`.

   For production baremetal environments, see the MinIO on Linux documentation for tutorials on configuring MinIO with KES and |rootkms-short|.

.. important::

   .. include:: /includes/common/common-minio-kes.rst
      :start-after: start-kes-encrypted-backend-desc
      :end-before: end-kes-encrypted-backend-desc

Prerequisites
-------------

.. cond:: k8s

   MinIO Kubernetes Operator and Plugin
   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

   The procedures on this page *requires* a valid installation of the MinIO Kubernetes Operator and assumes the local host has a matching installation of the MinIO Kubernetes Operator. 
   This procedure assumes the latest stable Operator and Plugin version |operator-version-stable|.

   See :ref:`deploy-operator-kubernetes` for complete documentation on deploying the MinIO Operator.

.. _minio-sse-aws-prereq-aws:

Ensure Access to the AWS Secrets Manager and Key Management Service
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This procedure assumes access to and familiarity with |rootkms| and `|rootkms-short| <https://aws.amazon.com/kms/>`__.

.. cond:: k8s

   This procedure assumes your Kubernetes cluster configuration allows for cluster-internal pods and services to resolve and connect to endpoints outside of the cluster, such as the public internet.
   

MinIO specifically requires the following AWS settings or configurations:

- A new AWS :aws-docs:`Programmatic Access <IAM/latest/UserGuide/id_users_create.html>` user  with corresponding access key and secret key.

- A policy that grants the created user access to AWS Secrets Manager and |rootkms-short|. 
  The following policy grants the minimum necessary permissions:

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


.. cond:: linux or macos or windows

   Deploy or Ensure Access to a MinIO Deployment
   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

   .. include:: /includes/common/common-minio-kes.rst
      :start-after: start-kes-new-existing-minio-deployment-desc
      :end-before: end-kes-new-existing-minio-deployment-desc

.. cond:: container

   Install Podman or a Similar Container Management Interface
   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

   .. include:: /includes/container/common-deploy.rst
      :start-after: start-common-prereq-container-management-interface
      :end-before: end-common-prereq-container-management-interface

.. The included file has the correct header structure.
   There are slight divergences between platforms so this ends up being easier compared to cascading conditionals to handle little nitty-gritty differences.

.. |namespace| replace:: minio-kes-aws

.. cond:: k8s

   .. include:: /includes/k8s/steps-configure-minio-kes-aws.rst

.. cond:: container

   .. |kescertpath|        replace:: ~/minio-kes-aws/certs
   .. |kesconfigpath|      replace:: ~/minio-kes-aws/config
   .. |kesconfigcertpath|  replace:: /certs/
   .. |miniocertpath|      replace:: ~/minio-kes-aws/certs
   .. |minioconfigpath|    replace:: ~/minio-kes-aws/config
   .. |miniodatapath|      replace:: ~/minio-kes-aws/minio

   .. include:: /includes/container/steps-configure-minio-kes-aws.rst

.. cond:: linux

   .. |kescertpath|        replace:: /opt/kes/certs
   .. |kesconfigpath|      replace:: /opt/kes/config
   .. |kesconfigcertpath|  replace:: /opt/kes/certs/
   .. |miniocertpath|      replace:: /opt/minio/certs
   .. |minioconfigpath|    replace:: /opt/minio/config
   .. |miniodatapath|      replace:: ~/minio


   .. include:: /includes/linux/steps-configure-minio-kes-aws-quick.rst

   .. include:: /includes/linux/steps-configure-minio-kes-aws.rst

.. cond:: macos

   .. |kescertpath|        replace:: ~/minio-kes-aws/certs
   .. |kesconfigpath|      replace:: ~/minio-kes-aws/config
   .. |kesconfigcertpath|  replace:: ~/minio-kes-aws/certs/
   .. |miniocertpath|      replace:: ~/minio-kes-aws/certs
   .. |minioconfigpath|    replace:: ~/minio-kes-aws/config
   .. |miniodatapath|      replace:: ~/minio-kes-aws/minio

   .. include:: /includes/macos/steps-configure-minio-kes-aws.rst

.. cond:: windows

   .. |kescertpath|        replace:: C:\\minio-kes-aws\\certs
   .. |kesconfigpath|      replace:: C:\\minio-kes-aws\\config
   .. |kesconfigcertpath|  replace:: C:\\minio-kes-aws\\certs\\
   .. |miniocertpath|      replace:: C:\\minio-kes-aws\\certs
   .. |minioconfigpath|    replace:: C:\\minio-kes-aws\\config
   .. |miniodatapath|      replace:: C:\\minio-kes-aws\\minio

   .. include:: /includes/windows/steps-configure-minio-kes-aws.rst

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
           - .. include:: /includes/common/common-minio-kes.rst
                :start-after: start-kes-conf-address-desc
                :end-before: end-kes-conf-address-desc

         * - ``root``
           - .. include:: /includes/common/common-minio-kes.rst
                :start-after: start-kes-conf-root-desc
                :end-before: end-kes-conf-root-desc

         * - ``tls``
           - .. include:: /includes/common/common-minio-kes.rst
                :start-after: start-kes-conf-tls-desc
                :end-before: end-kes-conf-tls-desc

         * - ``policy``
           - .. include:: /includes/common/common-minio-kes.rst
                :start-after: start-kes-conf-policy-desc
                :end-before: end-kes-conf-policy-desc

         *  - ``keys``
            - .. include:: /includes/common/common-minio-kes.rst
                 :start-after: start-kes-conf-keys-desc
                 :end-before: end-kes-conf-keys-desc

         * - ``keystore.aws.secretsmanager``
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
