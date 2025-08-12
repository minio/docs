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
.. |rootkms|       replace:: `HashiCorp Vault <https://vaultproject.io/>`__
.. |rootkms-short| replace:: Vault

.. meta::
   :description: Deploy MinIO with Server-Side Object Encryption
   :keywords: encryption, security, hashicorp, keyvault, azure

.. Conditionals to handle the slight divergences in procedures between platforms.

.. tab-set::
   :class: parent

   .. tab-item:: Kubernetes
      :sync: k8s

      This procedure assumes you have access to a Kubernetes cluster with an active MinIO Operator installation.
      For instructions on running KES, see the :kes-docs:`KES docs <tutorials/getting-started/>`.

      As part of this procedure, you will:

      #. Create or modify a MinIO deployment with support for |SSE| using |KES|.
         Defer to the :ref:`Deploy Distributed MinIO <minio-mnmd>` tutorial for guidance on production-ready MinIO deployments.

      #. Use the MinIO Operator Console to create or manage a MinIO Tenant.
      #. Access the :guilabel:`Encryption` settings for that tenant and configure |SSE| using a :kes-docs:`supported Key Management System <#supported-kms-targets>`.
      #. Create a new |EK| for use with |SSE|.
      #. Configure automatic bucket-default :ref:`SSE-KMS <minio-encryption-sse-kms>`.

   .. tab-item:: Baremetal
      :sync: baremetal

      This procedure provides guidance for deploying MinIO configured to use KES and enable :ref:`Server Side Encryption <minio-sse-data-encryption>`.
      For instructions on running KES, see the :kes-docs:`KES docs <tutorials/getting-started/>`.

      As part of this procedure, you will:

      #. Create a new |EK| for use with |SSE|.

      #. Create or modify a MinIO deployment with support for |SSE| using |KES|.
         Defer to the :ref:`Deploy Distributed MinIO <minio-mnmd>` tutorial for guidance on production-ready MinIO deployments.

      #. Configure automatic bucket-default :ref:`SSE-KMS <minio-encryption-sse-kms>`

.. important::

   .. include:: /includes/common/common-minio-kes.rst
      :start-after: start-kes-encrypted-backend-desc
      :end-before: end-kes-encrypted-backend-desc

Prerequisites
-------------

Access to MinIO Cluster
~~~~~~~~~~~~~~~~~~~~~~~

.. tab-set::
   

   .. tab-item:: Kubernetes
      :sync: k8s

      You must have access to the Kubernetes cluster, with administrative permissions associated to your ``kubectl`` configuration.
      
      This procedure assumes your permission sets extends sufficiently to support deployment or modification of MinIO-associated resources on the Kubernetes cluster, including but not limited to pods, statefulsets, replicasets, deployments, and secrets.

   .. tab-item:: Baremetal
      :sync: baremetal

      This procedure uses :mc:`mc` for performing operations on the MinIO cluster. 
      Install ``mc`` on a machine with network access to the cluster.
      See the ``mc`` :ref:`Installation Quickstart <mc-install>` for instructions on downloading and installing ``mc``.

      This procedure assumes a configured :mc:`alias <mc alias>` for the MinIO cluster. 

.. _minio-sse-vault-prereq-vault:

Ensure KES Access to a Supported KMS Target
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. tab-set::
   

   .. tab-item:: Kubernetes
      :sync: k8s

      This procedure assumes an existing :kes-docs:`supported KMS installation <#supported-kms-targets>` accessible from the Kubernetes cluster.

      - For deployments within the same Kubernetes cluster as the MinIO Tenant, you can use Kubernetes service names to allow the MinIO Tenant to establish connectivity to the target KMS service.

      - For deployments external to the Kubernetes cluster, you must ensure the cluster supports routing communications between Kubernetes services and pods and the external network.
        This may require configuration or deployment of additional Kubernetes network components and/or enabling access to the public internet.

      Defer to the documentation for your chosen KMS solution for guidance on deployment and configuration.

   .. tab-item:: Baremetal
      :sync: baremetal

      This procedure assumes an existing KES installation connected to a supported |KMS| installation accessible, both accessible from the local host.
      Refer to the installation instructions for your :kes-docs:`supported KMS target <#supported-kms-targets>` to deploy KES and connect it to a KMS solution.
   
.. admonition:: KES Operations Require Unsealed Target
   :class: important

   Some supported |KMS| targets allow you to seal or unseal the vault instance.
   KES returns an error if the configured |KMS| service is sealed.

   If you restart or otherwise seal your vault instance, KES cannot perform any cryptographic operations against the vault.
   You must unseal the Vault to ensure normal operations.

   See the documentation for your chosen |KMS| solution for more information on whether unsealing may be required.

Refer to the configuration instruction in the :kes-docs:`KES documentation <>` for your chosen supported |KMS|:

- :kes-docs:`AWS Secrets Manager <integrations/aws-secrets-manager/>`
- :kes-docs:`Azure KeyVault <integrations/azure-keyvault/>`
- :kes-docs:`Entrust KeyControl <integrations/entrust-keycontrol/>`
- :kes-docs:`Fortanix SDKMS <integrations/fortanix-sdkms/>`
- :kes-docs:`Google Cloud Secret Manager <integrations/google-cloud-secret-manager/>`
- :kes-docs:`HashiCorp Vault <integrations/hashicorp-vault-keystore/>`
- :kes-docs:`Thales CipherTrust Manager (formerly Gemalto KeySecure) <integrations/thales-ciphertrust/>`

Procedure
---------

This procedure provides instructions for configuring and enabling Server-Side Encryption using your selected `supported KMS solution <https://docs.min.io/community/minio-kes/#supported-kms-targets>`__ in production environments. 
Specifically, this procedure assumes the following:

- An existing production-grade KMS target
- One or more KES servers connected to the KMS target
- One or more hosts for a new or existing MinIO deployment

.. tab-set::
   

   .. tab-item:: Kubernetes
      :sync: k8s

      .. include:: /includes/k8s/steps-configure-minio-kes-hashicorp.rst

   .. tab-item:: Baremetal
      :sync: baremetal

      .. include:: /includes/linux/steps-configure-minio-kes-hashicorp.rst
