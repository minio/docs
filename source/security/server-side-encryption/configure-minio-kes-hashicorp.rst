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
  `Hashicorp Vault <https://www.vaultproject.io/>`__ as the root |KMS|.

- Configure MinIO to use the |KES| instance for supporting |SSE|.
  
- Configure automatic bucket-default 
  :ref:`SSE-KMS <minio-encryption-sse-kms>` and 
  :ref:`SSE-S3 <minio-encryption-sse-s3>`.

Prerequisites
-------------

.. _minio-sse-vault-prereq-vault:

Hashicorp Vault
~~~~~~~~~~~~~~~

This procedure assumes familiarity with 
`Hashicorp Vault <https://www.vaultproject.io/>`__. The
Vault `Quick Start 
<https://learn.hashicorp.com/tutorials/vault/getting-started-install>`__ 
provides a sufficient foundation for the purposes of this procedure.

MinIO specifically requires the following Vault settings or configurations:

- Enable the Vault K/V engine. KES version 0.15.0 and later support both the 
  v1 and v2 engines. This procedure uses the v1 engine.

- For K/V v1, create an access policy ``kes-policy.hcl`` with a configuration
  similar to the following:
   
  .. code-block:: shell
     :class: copyable

     path "kv/*" {
          capabilities = [ "create", "read", "delete" ]
     }

  Write the policy to Vault using 
  ``vault policy write kes-policy kes-policy.hcl``.
  
- For K/V v2, create an access policy ``kes-policy.hcl`` with a configuration
  similar to the following:

  .. code-block:: shell
     :class: copyable

     path "kv/data/*" {
          capabilities = [ "create", "read"]

     path "kv/metadata/*" {
          capabilities = [ "list", "delete"]
    
  Write the policy to Vault using 
  ``vault policy write kes-policy kes-policy.hcl``

- Enable Vault AppRole authentication, create an AppRole ID, bind it to 
  the necessary policy, and request both roleID and secret ID. 

  .. code-block:: shell
     :class: copyable

     vault write    auth/approle/role/kes-role token_num_uses=0 secret_id_num_uses=0 period=5m
     vault write    auth/approle/role/kes-role policies=kes-policy
     vault read     auth/approle/role/kes-role/role-id
     vault write -f auth/approle/role/kes-role/secret-id

The instructions on this page include configuring and starting Vault for
supporting development/evaluation of MinIO |SSE|. **DO NOT** use these
instructions for deploying Vault for any long-term development or production
environments. Extended development and production environments should defer to
the `Vault Documentation <https://learn.hashicorp.com/vault>`__ for specific
guidance on deployment and configuration.

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

Enable MinIO Server-Side Encryption with Hashicorp Vault
--------------------------------------------------------

The following steps deploy |KES-git| configured to use an existing Hashicorp
Vault deployment as the root KMS for supporting |SSE|. These steps assume the
Vault deployment meets the :ref:`prerequisites <minio-sse-vault-prereq-vault>`.

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
specifies the minimum required fields for enabling |SSE| using Hashicorp Vault:

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

   # Specify the connection information for the Vault server.
   # The endpoint should be resolvable from the host.
   # This example assumes that Vault is configured with an AppRole ID and
   # Secret for use with KES.
   keystore:
     vault:
       endpoint: https://HOSTNAME:8200
       approle:
         id: "${VAULTAPPID}"     # Hashicorp Vault AppRole ID
         secret: "${VAULTAPPSECRET}" # Hashicorp Vault AppRole Secret ID
         retry: 15s
       status:
         ping: 10s
       # Required if Vault uses certificates signed by an unknown CA,
       # e.g. self-signed or internal (non-globally trusted).  
       tls:
         ca: vault-tls.cert 

Save the configuration file as ``~/kes/config/kes-config.yaml``. Any field with
value ``${VARIABLE}`` uses the environment variable with matching name as the
value. You can use this functionality to set credentials without writing them to
the configuration file.

- Set ``MINIO_IDENTITY_HASH`` to the output of 
  ``kes tool identity of minio-kes.cert``.

- Replace the ``vault.endpoint`` with the hostname of the Vault server(s).

- Replace the ``VAULTAPPID`` and ``VAULTAPPSECRET`` with the appropriate
  :ref:`Vault AppRole credentials <minio-sse-vault-prereq-vault>`.

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

You can check the newly created key on the Vault server by running the 
``vault kv list kv/`` command, where ``kv/`` is the path to the vault storing
|KES|-generated keys.

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
