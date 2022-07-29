.. _minio-sse-vault:

===========================================================
Server-Side Object Encryption with Hashicorp Vault Root KMS
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

MinIO Server-Side Encryption (SSE) protects objects as part of write operations, allowing clients to take advantage of server processing power to secure objects at the storage layer (encryption-at-rest). 
SSE also provides key functionality to regulatory and compliance requirements around secure locking and erasure.

MinIO SSE uses |KES-git| and an external root Key Management Service (KMS) for performing secured cryptographic operations at scale. 
The root KMS provides stateful and secured storage of External Keys (EK) while |KES| is stateless and derives additional cryptographic keys from the root-managed |EK|. 

.. cond:: container

   .. include:: /includes/container/steps-configure-minio-kes-hashicorp.rst

.. cond:: linux

   .. include:: /includes/linux/steps-configure-minio-kes-hashicorp.rst

.. cond:: macos

   .. include:: /includes/macos/steps-configure-minio-kes-hashicorp.rst


Configuration Reference for Hashicorp Vault
-------------------------------------------

The following section describes each of the |KES-git| configuration settings for
using Hashicorp Vault as the root Key Management Service (KMS) for |SSE|:

.. tab-set::

   .. tab-item:: YAML Overview

      The following YAML describes the minimum required fields for configuring
      Hashicorp Vault as an external KMS for supporting |SSE|. 

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
           vault:
             endpoint: https://vault.example.net:8200
             approle:
               id: ${KES_APPROLE_ID}
               secret: ${KES_APPROLE_SECRET}
               retry: 15s
             status:
               ping: 10s
             tls:
               ca: vault-tls.cert

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

         * - ``keystore.vault``
           - The configuration for the Hashicorp Vault keystore. The following
             fields are *required*:

             - ``endpoint`` - The hostname for the vault server(s). The 
               hostname *must* be resolvable by the KES server host.

             - ``approle`` - The `AppRole 
               <https://www.vaultproject.io/docs/auth/approle>`__ used by 
               KES for performing authenticated operations against Vault.

               The specified AppRole must have the
               appropriate :ref:`permissions <minio-sse-vault-prereq-vault>`

             - ``tls.ca`` - The Certificate Authority used to sign the 
               Vault TLS certificates. Typically required if the Vault
               server uses self-signed certificates *or* is signed by an unknown
               CA (internal or non-global).
