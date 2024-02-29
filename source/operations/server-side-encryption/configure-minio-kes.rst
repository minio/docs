.. _minio-sse-vault:
.. _minio-sse-gcp:
.. _minio-sse-azure:
.. _minio-sse-aws:

======================================
Server-Side Object Encryption with KES
======================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. |EK|            replace:: :abbr:`EK (External Key)`
.. |SSE|           replace:: :abbr:`SSE (Server-Side Encryption)`
.. |KMS|           replace:: :abbr:`KMS (Key Management System)`
.. |KES-git|       replace:: :minio-git:`Key Encryption Service (KES) <kes>`
.. |KES|           replace:: :abbr:`KES (Key Encryption Service)`
.. |rootkms|       replace:: `Hashicorp Vault <https://vaultproject.io/>`__
.. |rootkms-short| replace:: Vault

.. meta::
   :description: Deploy MinIO with Server-Side Object Encryption
   :keywords: encryption, security, hashicorp, keyvault, azure

.. Conditionals to handle the slight divergences in procedures between platforms.

.. cond:: linux

   This procedure provides guidance for deploying MinIO configured to use KES and enable :ref:`Server Side Encryption <minio-sse-data-encryption>`.
   For instructions on running KES, see the :kes-docs:`KES docs <tutorials/getting-started/>`.

   As part of this procedure, you will:

   #. Create a new |EK| for use with |SSE|.

   #. Create or modify a MinIO deployment with support for |SSE| using |KES|.
      Defer to the :ref:`Deploy Distributed MinIO <minio-mnmd>` tutorial for guidance on production-ready MinIO deployments.

   #. Configure automatic bucket-default :ref:`SSE-KMS <minio-encryption-sse-kms>`

.. cond:: macos or windows

   This procedure assumes a single local host machine running the MinIO and KES processes.
   For instructions on running KES, see the :kes-docs:`KES docs <tutorials/getting-started/>`.
   
   .. note::

      For production orchestrated environments, use the MinIO Kubernetes Operator to deploy a tenant with |SSE| enabled and configured for use with your |KMS|.

      For production baremetal environments, see the `MinIO on Linux documentation <https://min.io/docs/minio/linux/operations/server-side-encryption.html>`__ for tutorials on configuring MinIO with KES and your |KMS|.

   As part of this procedure, you will:

   #. Create a new |EK| for use with |SSE|.

   #. Deploy a MinIO server in :ref:`Single-Node Single-Drive mode <minio-snsd>` configured to use the |KES| container for supporting |SSE|.

   #. Configure automatic bucket-default :ref:`SSE-KMS <minio-encryption-sse-kms>`.


.. cond:: container

   This procedure assumes that you use a single host machine to run both the MinIO and KES containers.
   For instructions on running KES, see the :kes-docs:`KES docs <tutorials/getting-started/>`.

   As part of this procedure, you will:

   #. Create a new |EK| for use with |SSE|.

   #. Deploy a MinIO Server container in :ref:`Single-Node Single-Drive mode <minio-snsd>` configured to use the |KES| container for supporting |SSE|.

   #. Configure automatic bucket-default :ref:`SSE-KMS <minio-encryption-sse-kms>`.

   For production orchestrated environments, use the MinIO Kubernetes Operator to deploy a tenant with |SSE| enabled and configured for use with your |KMS|.

   For production baremetal environments, see the `MinIO on Linux documentation <https://min.io/docs/minio/linux/operations/server-side-encryption.html>`__ for tutorials on configuring MinIO with KES and your |KMS|.

.. cond:: k8s

   This procedure assumes you have access to a Kubernetes cluster with an active MinIO Operator installation.
   For instructions on running KES, see the :kes-docs:`KES docs <tutorials/getting-started/>`.

   As part of this procedure, you will:

   #. Use the MinIO Operator Console to create or manage a MinIO Tenant.
   #. Access the :guilabel:`Encryption` settings for that tenant and configure |SSE| using a :kes-docs:`supported Key Management System <#supported-kms-targets>`.
   #. Create a new |EK| for use with |SSE|.
   #. Configure automatic bucket-default :ref:`SSE-KMS <minio-encryption-sse-kms>`.

   For production baremetal environments, see the `MinIO on Linux documentation <https://min.io/docs/minio/linux/operations/server-side-encryption.html>`__  for tutorials on configuring MinIO with KES and your |KMS|.

.. important::

   .. include:: /includes/common/common-minio-kes.rst
      :start-after: start-kes-encrypted-backend-desc
      :end-before: end-kes-encrypted-backend-desc

Prerequisites
-------------

.. cond:: k8s

   MinIO Kubernetes Operator and Plugin
   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

   .. include:: /includes/k8s/common-operator.rst
      :start-after: start-requires-operator-plugin
      :end-before: end-requires-operator-plugin

   See :ref:`deploy-operator-kubernetes` for complete documentation on deploying the MinIO Operator.

.. _minio-sse-vault-prereq-vault:

Ensure KES Access to a Supported KMS Target
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. cond:: linux or macos or windows or container

   This procedure assumes an existing KES installation connected to a supported |KMS| installation accessible, both accessible from the local host.
   Refer to the installation instructions for your :kes-docs:`supported KMS target <#supported-kms-targets>` to deploy KES and connect it to a KMS solution.
   
   .. admonition:: KES Operations Require Unsealed Target
      :class: important
   
      Some supported |KMS| targets allow you to seal or unseal the vault instance.
      KES returns an error if the configured |KMS| service is sealed.
   
      If you restart or otherwise seal your vault instance, KES cannot perform any cryptographic operations against the vault.
      You must unseal the Vault to ensure normal operations.
   
      See the documentation for your chosen |KMS| solution for more information on whether unsealing may be required.

.. cond:: k8s

   .. include:: /includes/k8s/common-minio-kes.rst
      :start-after: start-kes-prereq-hashicorp-vault-desc
      :end-before: end-kes-prereq-hashicorp-vault-desc

Refer to the configuration instruction in the :kes-docs:`KES documentation <>` for your chosen supported |KMS|:

- :kes-docs:`AWS Secrets Manager <integrations/aws-secrets-manager/>`
- :kes-docs:`Azure KeyVault <integrations/azure-keyvault/>`
- :kes-docs:`Entrust KeyControl <integrations/entrust-keycontrol/>`
- :kes-docs:`Fortanix SDKMS <integrations/fortanix-sdkms/>`
- :kes-docs:`Google Cloud Secret Manager <ntegrations/google-cloud-secret-manager/>`
- :kes-docs:`Hashicorp Vault <integrations/hashicorp-vault-keystore/>`
- :kes-docs:`Thales CipherTrust Manager (formerly Gemalto KeySecure) <integrations/thales-ciphertrust/>`


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

.. |namespace| replace:: minio-kes-vault

.. cond:: container

   .. |kescertpath|        replace:: ~/minio-kes-vault/certs
   .. |kesconfigpath|      replace:: ~/minio-kes-vault/config
   .. |kesconfigcertpath|  replace:: /certs/
   .. |miniocertpath|      replace:: ~/minio-kes-vault/certs
   .. |minioconfigpath|    replace:: ~/minio-kes-vault/config
   .. |miniodatapath|      replace:: ~/minio-kes-vault/minio

   .. include:: /includes/container/steps-configure-minio-kes-hashicorp.rst

.. cond:: linux

   .. |kescertpath|        replace:: /opt/kes/certs
   .. |kesconfigpath|      replace:: /opt/kes/config
   .. |kesconfigcertpath|  replace:: /opt/kes/certs/
   .. |miniocertpath|      replace:: /opt/minio/certs
   .. |minioconfigpath|    replace:: /opt/minio/config
   .. |miniodatapath|      replace:: ~/minio

   .. include:: /includes/linux/steps-configure-minio-kes-hashicorp.rst

.. cond:: macos

   .. |kescertpath|        replace:: ~/minio-kes-vault/certs
   .. |kesconfigpath|      replace:: ~/minio-kes-vault/config
   .. |kesconfigcertpath|  replace:: ~/minio-kes-vault/certs
   .. |miniocertpath|      replace:: ~/minio-kes-vault/certs
   .. |minioconfigpath|    replace:: ~/minio-kes-vault/config
   .. |miniodatapath|      replace:: ~/minio-kes-vault/minio

   .. include:: /includes/macos/steps-configure-minio-kes-hashicorp.rst

.. cond:: k8s

   .. include:: /includes/k8s/steps-configure-minio-kes-hashicorp.rst

.. cond:: windows

   .. |kescertpath|        replace:: C:\\minio-kes-vault\\certs
   .. |kesconfigpath|      replace:: C:\\minio-kes-vault\\config
   .. |kesconfigcertpath|  replace:: C:\\minio-kes-vault\\certs\\
   .. |miniocertpath|      replace:: C:\\minio-kes-vault\\certs
   .. |minioconfigpath|    replace:: C:\\minio-kes-vault\\config
   .. |miniodatapath|      replace:: C:\\minio-kes-vault\\minio

   .. include:: /includes/windows/steps-configure-minio-kes-hashicorp.rst

.. Procedure for K8s only, for adding KES to an existing Tenant
