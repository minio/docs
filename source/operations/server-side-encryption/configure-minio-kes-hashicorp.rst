.. _minio-sse-vault:

===========================================================
Server-Side Object Encryption with Hashicorp Vault Root KMS
===========================================================

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

.. Conditionals to handle the slight divergences in procedures between platforms.

.. cond:: linux

   This procedure provides guidance for deploying MinIO configured to use KES and enable :ref:`Server Side Encryption <minio-sse-data-encryption>`.

   As part of this procedure, you will:

   #. Deploy one or more |KES| servers configured to use |rootkms| as the root |KMS|.
      You may optionally deploy a load balancer for managing connections to those KES servers.

   #. Create a new |EK| on Vault for use with |SSE|.

   #. Create or modify a MinIO deployment with support for |SSE| using |KES|.
      Defer to the :ref:`Deploy Distributed MinIO <minio-mnmd>` tutorial for guidance on production-ready MinIO deployments.

   #. Configure automatic bucket-default :ref:`SSE-KMS <minio-encryption-sse-kms>`

.. cond:: macos or windows

   This procedure assumes a single local host machine running the MinIO and KES processes.
   As part of this procedure, you will:

   #. Deploy a |KES| server configured to use |rootkms-short| as the root |KMS|.

   #. Create a new |EK| on Vault for use with |SSE|.

   #. Deploy a MinIO server in :ref:`Single-Node Single-Drive mode <minio-snsd>` configured to use the |KES| container for supporting |SSE|.

   #. Configure automatic bucket-default :ref:`SSE-KMS <minio-encryption-sse-kms>`.

   For production orchestrated environments, use the MinIO Kubernetes Operator to deploy a tenant with |SSE| enabled and configured for use with Hashicorp Vault.

   For production baremetal environments, see the MinIO on Linux documentation for tutorials on configuring MinIO with KES and Hashicorp Vault.

.. cond:: container

   This procedure assumes a single host machine running the MinIO and KES containers.
   As part of this procedure, you will:

   #. Deploy a |KES| container configured to use |rootkms-short| as the root |KMS|.

   #. Create a new |EK| on Vault for use with |SSE|.

   #. Deploy a MinIO Server container in :ref:`Single-Node Single-Drive mode <minio-snsd>` configured to use the |KES| container for supporting |SSE|.

   #. Configure automatic bucket-default :ref:`SSE-KMS <minio-encryption-sse-kms>`.

   For production orchestrated environments, use the MinIO Kubernetes Operator to deploy a tenant with |SSE| enabled and configured for use with Hashicorp Vault.

   For production baremetal environments, see the MinIO on Linux documentation for tutorials on configuring MinIO with KES and Hashicorp Vault.

.. cond:: k8s

   This procedure assumes you have access to a Kubernetes cluster with an active MinIO Operator installation.
   As part of this procedure, you will:

   #. Use the MinIO Operator Console to create or manage a MinIO Tenant.
   #. Access the :guilabel:`Encryption` settings for that tenant and configure |SSE| using |rootkms-short|.
   #. Create a new |EK| on Vault for use with |SSE|.
   #. Configure automatic bucket-default :ref:`SSE-KMS <minio-encryption-sse-kms>`.

   For production baremetal environments, see the MinIO on Linux documentation for tutorials on configuring MinIO with KES and Hashicorp Vault.

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

Deploy or Ensure Access to a Hashicorp Vault Service
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. cond:: linux or macos or windows or container

   .. include:: /includes/common/common-minio-kes-hashicorp.rst
      :start-after: start-kes-prereq-hashicorp-vault-desc
      :end-before: end-kes-prereq-hashicorp-vault-desc

.. cond:: k8s

   .. include:: /includes/k8s/common-minio-kes.rst
      :start-after: start-kes-prereq-hashicorp-vault-desc
      :end-before: end-kes-prereq-hashicorp-vault-desc

MinIO |KES| supports either the V1 or V2 Vault `K/V engines <https://www.vaultproject.io/docs/secrets/kv>`__.

MinIO KES requires using AppRole authentication to the Vault server. 
You must create an AppRole, assign it a policy that the necessary permissions, and retrieve the AppRole ID and Secret for use in configuring KES.

You can use the following steps to enable AppRole authentication and create the necessary policies to support core KES functionality against Vault:

1. Enable AppRole Authentication

   .. code-block:: shell
      :class: copyable

      vault auth enable approle

#. Create a Policy for KES

   Create a `policy with necessary capabilities <https://www.vaultproject.io/docs/concepts/policies#capabilities>`__ for KES to use when accessing Vault.
   Select the tab corresponding to the KV engine used for storing KES secrets:
 
   .. tab-set::

      .. tab-item:: Vault Engine V1

         Create an access policy ``kes-policy.hcl`` with a configuration similar to the following:
            
         .. code-block:: shell
            :class: copyable

            path "kv/*" {
                  capabilities = [ "create", "read", "delete" ]
            }

         Write the policy to Vault using ``vault policy write kes-policy kes-policy.hcl``.

      .. tab-item:: Vault Engine V2

         Create an access policy ``kes-policy.hcl`` with a configuration similar to the following:

         .. code-block:: shell
            :class: copyable

            path "kv/data/*" {
                  capabilities = [ "create", "read"]
            }

            path "kv/metadata/*" {
                  capabilities = [ "list", "delete"]
            }
            
         Write the policy to Vault using ``vault policy write kes-policy kes-policy.hcl``

#. Create an AppRole for KES and assign it the created policy

   .. code-block:: shell
      :class: copyable

      vault write    auth/approle/role/kes-role token_num_uses=0 secret_id_num_uses=0 period=5m
      vault write    auth/approle/role/kes-role policies=kes-policy

#. Retrieve the AppRole ID and Secret

   .. code-block:: shell
      :class: copyable

      vault read     auth/approle/role/kes-role/role-id
      vault write -f auth/approle/role/kes-role/secret-id


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

Configuration Reference for Hashicorp Vault
-------------------------------------------

The following section describes each of the |KES-git| configuration settings for using Hashicorp Vault as the root Key Management Service (KMS) for |SSE|.

.. important::

   Starting with :minio-release:`RELEASE.2023-02-17T17-52-43Z`, MinIO requires expanded KES permissions for functionality.
   The example configuration in this section contains all required permissions.

.. tab-set::

   .. tab-item:: YAML Overview

      The following YAML describes the minimum required fields for configuring Hashicorp Vault as an external KMS for supporting |SSE|. 

      Fields with ``${<STRING>}`` use the environment variable matching the ``<STRING>`` value. 
      You can use this functionality to set credentials without writing them to the configuration file.

      The YAML assumes a minimal set of permissions for the MinIO deployment accessing KES.
      As an alternative, you can omit the ``policy.minio-server`` section and instead set the ``${MINIO_IDENTITY}`` hash as the ``${ROOT_IDENTITY}``.

      .. code-block:: yaml

         address: 0.0.0.0:7373
         admin: 
           identity: ${ROOT_IDENTITY}

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
             - /v1/key/list/*
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
           vault:
             endpoint: https://vault.example.net:8200
             engine: "kv"
             version: "v1"
             namespace: "minio"
             prefix: "keys"
             approle:
               id: ${KES_APPROLE_ID}
               secret: ${KES_APPROLE_SECRET}
               retry: 15s
             status:
               ping: 10s
             tls:
               key: "kes-mtls.key"
               cert: "kes-mtls.cert"
               ca: vault-tls.cert

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

         * - ``keystore.vault``
           - The configuration for the Hashicorp Vault keystore. The following
             fields are *required*:

             - ``endpoint`` - The hostname for the vault server(s). 
               The hostname *must* be resolvable by the KES server host.

             - ``engine`` - The path to the K/V engine to use.
               Defaults to ``kv``

             - ``version`` - The version of the K/V engine to use.
               
               Specify either ``v1`` or ``v2``. 
               Defaults to ``v1``.

             - ``namespace`` - The Vault namespace to use for secret storage.

             - ``prefix`` - The prefix to use for secret storage.

             - ``approle`` - The `AppRole <https://www.vaultproject.io/docs/auth/approle>`__ used by KES for performing authenticated operations against Vault.

               The specified AppRole must have the appropriate :ref:`permissions <minio-sse-vault-prereq-vault>`

             - ``tls.ca`` - The Certificate Authority used to sign the 
               Vault TLS certificates. Typically required if the Vault
               server uses self-signed certificates *or* is signed by an unknown
               CA (internal or non-global).
