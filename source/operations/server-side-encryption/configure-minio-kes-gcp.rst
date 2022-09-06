.. _minio-sse-gcp:

==============================================================
Server-Side Object Encryption with GCP Secret Manager Root KMS
==============================================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. |EK|            replace:: :abbr:`EK (External Key)`
.. |SSE|           replace:: :abbr:`SSE (Server-Side Encryption)`
.. |KMS|           replace:: :abbr:`KMS (Key Management System)`
.. |KES-git|       replace:: :minio-git:`Key Encryption Service (KES) <kes>`
.. |KES|           replace:: :abbr:`KES (Key Encryption Service)`
.. |rootkms|       replace:: `Google Cloud Platform Secret Manager
  <https://cloud.google.com/secret-manager/>`__
.. |rootkms-short| replace:: GCP Secret Manager

MinIO Server-Side Encryption (SSE) protects objects as part of write operations,
allowing clients to take advantage of server processing power to secure objects
at the storage layer (encryption-at-rest). SSE also provides key functionality
to regulatory and compliance requirements around secure locking and erasure.

MinIO SSE uses |KES-git| and an
external root Key Management Service (KMS) for performing secured cryptographic
operations at scale. The root KMS provides stateful and secured storage of 
External Keys (EK) while |KES| is stateless and derives additional cryptographic
keys from the root-managed |EK|. 

.. Conditionals to handle the slight divergences in procedures between platforms.

.. cond:: linux

   This procedure provides guidance for deploying and configuring KES at scale for a supporting |SSE| on a production MinIO deployment.
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

   This procedure assumes a single local host machine running the MinIO and KES processes.
   As part of this procedure, you will:

   #. Deploy a |KES| server configured to use |rootkms-short| as the root |KMS|.

   #. Create a new |EK| on |rootkms-short| for use with |SSE|.

   #. Deploy a MinIO server in :ref:`Single-Node Single-Drive mode <minio-snsd>` configured to use the |KES| container for supporting |SSE|.

   #. Configure automatic bucket-default :ref:`SSE-KMS <minio-encryption-sse-kms>`.

   For production orchestrated environments, use the MinIO Kubernetes Operator to deploy a tenant with |SSE| enabled and configured for use with |rootkms-short|.

   For production baremetal environments, see the MinIO on Linux documentation for tutorials on configuring MinIO with KES and |rootkms-short|.

.. cond:: container

   This procedure assumes a single host machine running the MinIO and KES containers.
   As part of this procedure, you will:

   #. Deploy a |KES| container configured to use |rootkms-short| as the root |KMS|.

   #. Create a new |EK| on Vault for use with |SSE|.

   #. Deploy a MinIO Server container in :ref:`Single-Node Single-Drive mode <minio-snsd>` configured to use the |KES| container for supporting |SSE|.

   #. Configure automatic bucket-default :ref:`SSE-KMS <minio-encryption-sse-kms>`.

   For production orchestrated environments, use the MinIO Kubernetes Operator to deploy a tenant with |SSE| enabled and configured for use with |rootkms-short|.

   For production baremetal environments, see the MinIO on Linux documentation for tutorials on configuring MinIO with KES and |rootkms-short|.

.. cond:: k8s

   This procedure assumes you have access to a Kubernetes cluster with an active MinIO Operator installation.
   As part of this procedure, you will:

   #. Use the MinIO Operator Console to create or manage a MinIO Tenant.
   #. Access the :guilabel:`Encryption` settings for that tenant and configure |SSE| using |rootkms-short|.
   #. Create a new |EK| on |rootkms-short| for use with |SSE|.
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

   The procedures on this page *requires* a valid installation of the MinIO
   Kubernetes Operator and assumes the local host has a matching installation of
   the MinIO Kubernetes Operator. This procedure assumes the latest stable Operator
   and Plugin version |operator-version-stable|.

   See :ref:`deploy-operator-kubernetes` for complete documentation on deploying the MinIO Operator.

.. _minio-sse-gcp-prereq-gcp:

GCP Secret Manager
~~~~~~~~~~~~~~~~~~

This procedure assumes familiarity with 
`GCP Secret Manager <https://cloud.google.com/secret-manager>`__. 
The `Secret Manager Quickstart
<https://cloud.google.com/secret-manager/docs/quickstart>`__
provides a sufficient foundation for the purposes of this procedure.

.. cond:: k8s

   This procedure assumes your Kubernetes cluster configuration allows for cluster-internal pods and services to resolve and connect to endpoints outside the cluster, such as the public internet.

MinIO specifically requires the following GCP settings or
configurations:

- `Enable Secret Manager <https://cloud.google.com/secret-manager/docs/configuring-secret-manager>`__
  in the project.

- Create a new GCP Service Account for supporting |KES|. Ensure the user has
  a role with *at minimum* the following permissions:

  .. code-block:: text
     :class: copyable

     secretmanager.secrets.create
     secretmanager.secrets.delete
     secretmanager.secrets.get

  The ``Secret manager Admin`` role meets the minimum required permissions.

  GCP should return a set of credentials associated to the new service account,
  including private keys. Copy these credentials to a safe and secure location
  for use with this procedure.

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

.. |namespace| replace:: minio-kes-gcp

.. cond:: container

   .. |kescertpath|        replace:: ~/minio-kes-gcp/certs
   .. |kesconfigpath|      replace:: ~/minio-kes-gcp/config
   .. |kesconfigcertpath|  replace:: /certs/
   .. |miniocertpath|      replace:: ~/minio-kes-gcp/certs
   .. |minioconfigpath|    replace:: ~/minio-kes-gcp/config
   .. |miniodatapath|      replace:: ~/minio-kes-gcp/minio

   .. include:: /includes/container/steps-configure-minio-kes-gcp.rst

.. cond:: linux

   .. |kescertpath|        replace:: /opt/kes/certs
   .. |kesconfigpath|      replace:: /opt/kes/config
   .. |kesconfigcertpath|  replace:: /opt/kes/certs/
   .. |miniocertpath|      replace:: /opt/minio/certs
   .. |minioconfigpath|    replace:: /opt/minio/config
   .. |miniodatapath|      replace:: ~/minio

   .. include:: /includes/linux/steps-configure-minio-kes-gcp-quick.rst

   .. include:: /includes/linux/steps-configure-minio-kes-gcp.rst

.. cond:: macos

   .. |kescertpath|        replace:: ~/minio-kes-gcp/certs
   .. |kesconfigpath|      replace:: ~/minio-kes-gcp/config/
   .. |kesconfigcertpath|  replace:: ~/minio-kes-gcp/certs
   .. |miniocertpath|      replace:: ~/minio-kes-gcp/certs
   .. |minioconfigpath|    replace:: ~/minio-kes-gcp/config
   .. |miniodatapath|      replace:: ~/minio-kes-gcp/minio

   .. include:: /includes/macos/steps-configure-minio-kes-gcp.rst

.. cond:: k8s

   .. include:: /includes/k8s/steps-configure-minio-kes-gcp.rst

.. cond:: windows

   .. |kescertpath|        replace:: C:\\minio-kes-gcp\\certs
   .. |kesconfigpath|      replace:: C:\\minio-kes-gcp\\config
   .. |kesconfigcertpath|  replace:: C:\\minio-kes-gcp\\certs\\
   .. |miniocertpath|      replace:: C:\\minio-kes-gcp\\certs
   .. |minioconfigpath|    replace:: C:\\minio-kes-gcp\\config
   .. |miniodatapath|      replace:: C:\\minio-kes-gcp\\minio

   .. include:: /includes/windows/steps-configure-minio-kes-gcp.rst

Configuration Reference for GCP Secret Manager Root KMS
-------------------------------------------------------

The following section describes each of the |KES-git| configuration settings for
using GCP Secrets Manager as the root Key Management Service
(KMS) for |SSE|:

.. tab-set::

   .. tab-item:: YAML Overview

      The following YAML describes the minimum required fields for configuring
      GCP Secret Manager as an external KMS for supporting |SSE|. 

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
           gcp:
             secretmanager:
               project_id: "${GCPPROJECTID}"
               credentials:
                 client_email: "${GCPCLIENTEMAIL}"
                 client_id: "${GCPCLIENTID}"
                 private_key_id: "${GCPPRIVATEKEYID}"
                 private_key: "${GCPPRIVATEKEY}"

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

         * - ``keystore.gcp.secretmanager``
           - The configuration for the GCP Secret Manager

             - ``project_id`` - The GCP Project of the Secret Manager instance.

             - ``credentials`` -  Replace the ``credentials`` with the
               credentials for a project user with the 
               :ref:`required permissions <minio-sse-gcp-prereq-gcp>`.
