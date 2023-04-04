.. _minio-sse-azure:

===========================================================
Server-Side Object Encryption with Azure Key Vault Root KMS
===========================================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. |EK|      replace:: :abbr:`EK (External Key)`
.. |SSE|     replace:: :abbr:`SSE (Server-Side Encryption)`
.. |KMS|     replace:: :abbr:`KMS (Key Management System)`
.. |KES-git| replace:: :minio-git:`Key Encryption Service (KES) <kes>`
.. |KES|     replace:: :abbr:`KES (Key Encryption Service)`
.. |rootkms|       replace:: `Azure Key Vault <https://azure.microsoft.com/en-us/services/key-vault/#product-overview>`__
.. |rootkms-short| replace:: Azure Key Vault


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

.. _minio-sse-azure-prereq-azure:

Azure Key Vault
~~~~~~~~~~~~~~~

This procedure assumes familiarity with `Azure Key Vault
<https://azure.microsoft.com/en-us/services/key-vault/#product-overview>`__. The
`Key Vault Quickstart
<https://docs.microsoft.com/en-us/azure/key-vault/general/quick-create-portal>`__
provides a sufficient foundation for the purposes of this procedure.

MinIO specifically requires the following Azure settings or
configurations:

- `Register an application <https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app>`__
  for |KES| (e.g. ``minio-kes``). Note the :guilabel:`Application (client) ID`,
  :guilabel:`Directory (tenant) ID`, and :guilabel:`Client credentials`. 
  You may need to create the client credentials secret and copy the
  :guilabel:`Secret Value` for use in this procedure.

- Create an `Access Policy <https://docs.microsoft.com/en-us/azure/key-vault/general/assign-access-policy?tabs=azure-portal>`__
  for use by KES. The policy **must** have the following 
  :guilabel:`Secret Permissions`:

  - ``Get``
  - ``List``
  - ``Set``
  - ``Delete``
  - ``Purge``

  Set the :guilabel:`Principal` for the new policy to the KES Application ID.

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


.. |namespace| replace:: minio-kes-azure

.. cond:: k8s

   .. include:: /includes/k8s/steps-configure-minio-kes-azure.rst

.. cond:: container

   .. |kescertpath|        replace:: ~/minio-kes-azure/certs
   .. |kesconfigpath|      replace:: ~/minio-kes-azure/config
   .. |kesconfigcertpath|  replace:: /certs/
   .. |miniocertpath|      replace:: ~/minio-kes-azure/certs
   .. |minioconfigpath|    replace:: ~/minio-kes-azure/config
   .. |miniodatapath|      replace:: ~/minio-kes-azure/minio

   .. include:: /includes/container/steps-configure-minio-kes-azure.rst

.. cond:: linux

   .. |kescertpath|        replace:: /opt/kes/certs
   .. |kesconfigpath|      replace:: /opt/kes/config
   .. |kesconfigcertpath|  replace:: /opt/kes/certs/
   .. |miniocertpath|      replace:: /opt/minio/certs
   .. |minioconfigpath|    replace:: /opt/minio/config
   .. |miniodatapath|      replace:: ~/minio


   .. include:: /includes/linux/steps-configure-minio-kes-azure-quick.rst

   .. include:: /includes/linux/steps-configure-minio-kes-azure.rst

.. cond:: macos

   .. |kescertpath|        replace:: ~/minio-kes-azure/certs
   .. |kesconfigpath|      replace:: ~/minio-kes-azure/config
   .. |kesconfigcertpath|  replace:: ~/minio-kes-azure/certs/
   .. |miniocertpath|      replace:: ~/minio-kes-azure/certs
   .. |minioconfigpath|    replace:: ~/minio-kes-azure/config
   .. |miniodatapath|      replace:: ~/minio-kes-azure/minio

   .. include:: /includes/macos/steps-configure-minio-kes-azure.rst

.. cond:: windows

   .. |kescertpath|        replace:: C:\\minio-kes-azure\\certs
   .. |kesconfigpath|      replace:: C:\\minio-kes-azure\\config
   .. |kesconfigcertpath|  replace:: C:\\minio-kes-azure\\certs\\
   .. |miniocertpath|      replace:: C:\\minio-kes-azure\\certs
   .. |minioconfigpath|    replace:: C:\\minio-kes-azure\\config
   .. |miniodatapath|      replace:: C:\\minio-kes-azure\\minio

   .. include:: /includes/windows/steps-configure-minio-kes-azure.rst

Configuration Reference for Azure Key Vault Root KMS
----------------------------------------------------

The following section describes each of the |KES-git| configuration settings for
using Azure Key Vault as the root Key Management Service
(KMS) for |SSE|:

.. important::

   Starting with :minio-release:`RELEASE.2023-02-17T17-52-43Z`, MinIO requires expanded KES permissions for functionality.
   The example configuration in this section contains all required permissions.

.. tab-set::

   .. tab-item:: YAML Overview

      Fields with ``${<STRING>}`` use the environment variable matching the ``<STRING>`` value. 
      You can use this functionality to set credentials without writing them to the configuration file.

      The YAML assumes a minimal set of permissions for the MinIO deployment accessing KES.
      As an alternative, you can omit the ``policy.minio-server`` section and instead set the ``${MINIO_IDENTITY}`` hash as the ``${ROOT_IDENTITY}``.

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
             - /v1/key/bulk/decrypt
             - /v1/key/list
             - /v1/status
             - /v1/metrics
             - /v1/log/audit
             - /v1/log/error
             identities:
             - ${MINIO_IDENTITY}

         keys:
           - name: "minio-encryption-key-alpha"
           - name: "minio-encryption-key-baker"
           - name: "minio-encryption-key-charlie"

         keystore:
           azure:
             keyvault:
               endpoint: "https://<keyvaultinstance>.vault.azure.net"
               credentials:
                 tenant_id: "${TENANTID}" # The directory/tenant UUID
                 client_id: "${CLIENTID}" # The application/client UUID
                 client_secret: "${CLIENTSECRET}" # The Active Directory secret for the application


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

         * - ``keystore.azure.keyvault``
           - The configuration for the Azure Key Vault

             - ``endpoint`` - The hostname for the Key Vault service.

             - ``credentials`` -  Replace the ``credentials`` with the
               credentials for the Active Directory application as which KES
               authenticates.

               The specified credentials must have the appropriate
               :ref:`permissions <minio-sse-azure-prereq-azure>`
