======================================
MinIO Key Encryption Service (``kes``)
======================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: kes

Overview
--------

The MinIO Key Encryption Service (KES) is a stateless and distributed
key-management system for high-performance applications. KES provides
a bridge between applications running in bare-metal or orchestrated
environments to centralised KMS solutions. 

This page provides a reference for the :mc:`kes` command line tool. For more
complete conceptual information on KES, see :ref:`minio-kes`.

For tutorials on deploying KES to support Server-Side Object Encryption, see:

- Server-Side Object Encryption with Thales CipherText
- Other similar tutorials.

.. _minio-kes-installation:

Installation
------------

.. include:: /includes/minio-kes-installation.rst

.. _minio-kes-config:

KES Configuration File
----------------------

The KES configuration file is a ``YAML`` document containing information for
running the KES server. Use 
:mc-cmd-option:`kes server config` to specify the path to the configuration file 
on startup. 

General Configuration
~~~~~~~~~~~~~~~~~~~~~

.. kesconf:: address

   The network addresses and port on which :mc:`kes server` binds to on startup.
   Specify a string as ``IP:PORT``:

   - To specify only a custom IP address, omit ``:PORT``.

   - To specify only a custom port, omit ``IP``.

   Defaults to port ``7373`` on all network addresses on the host machine.

.. kesconf:: root

   Specify ``disabled`` to disable the :ref:`root <minio-kes-iam-root>` identity
   on the KES server. The ``root`` identity has super administrator access to
   the KES server.

   If omitted, the :mc:`kes server` *requires* specifying an x.509 certificate
   using the :mc-cmd-option:`~kes server root` command line option.

TLS Configuration
~~~~~~~~~~~~~~~~~

The following section describes TLS-related configuration for the KES server:

.. code-block:: yaml

   tls:
      key: <string>
      cert: <string>

.. kesconf:: tls

   The root field for TLS-related configuration.

.. kesconf:: tls.key

   The path to the TLS private ``.key`` file KES uses when establishing
   TLS-secured communications.

   Ensure the Certificate Authority used to sign the private key exists in the
   host OS system trusted certificate store. Defer to the host operating
   system documentation for adding Certificate Authorities to the certificate
   store.

   To direct KES to accept invalid certificates, include the
   :mc-cmd-option:`kes server auth` option when starting the KES server.

.. kesconf:: tls.cert

   The path to the TLS public certificate ``.cert`` file KES uses when
   establishing TLS-secured communications.

   Ensure the Certificate Authority used to sign the private key exists in the
   host OS system trusted certificate store. Defer to the host operating
   system documentation for adding Certificate Authorities to the certificate
   store.

   To direct KES to accept invalid certificates, include the
   :mc-cmd-option:`kes server auth` option when starting the KES server.

Cache Configuration
~~~~~~~~~~~~~~~~~~~

The following section describes cache-related configuration for
controlling how often the KES server fetches keys from an external KMS.

.. code-block:: yaml

   cache:
      expiry:
         any: <string>
         unused: <string>

.. kesconf:: cache

   The root field for cache-related configuration.

.. kesconf:: cache.expiry

   The root field for cache expiry configuration.

.. kesconf:: cache.expiry.any

   The duration between clearing the in-memory cache of Customer Master Keys 
   (CMK) retrieved by KES. Specify a string as ``##h##m##s``:

   - ``30s`` sets a cache expiry of 30 seconds.
   - ``1m0s`` sets a cache expiry of 1 minute.
   - ``2m30s`` sets a cache expiry of 2 minutes and 30 seconds.

   Lower values trade higher security for more frequent outgoing network
   requests to the external KMS. Higher values may provide increased performance
   at the cost of security due to long-cached CMK.

   For example, a ``30s`` expiry allows KES to go up to 30 seconds
   without making a request to the external KMS. However, if the CMK is disabled
   or deleted during that time period, KES continues to encrypt and decrypt
   data using that CMK until the next refresh.

   The following table provides guidance for setting the cache value:

   .. list-table::
      :header-rows: 1
      :widths: 40 60
      :width: 50%

      * - Security Goal
        - Value

      * - *Liberal*
        - ``5m0s``
      
      * - *Moderate*
        - ``1m0s``

      * - *Conservative*
        - ``30s``

.. kesconf:: cache.expiry.unused

   The duration after which KES considers a cached Customer Master Key as
   unused and removes that key from the cache. Specify a string as ``##h##m##s``:

   - ``30s`` sets a cache expiry of 30 seconds.
   - ``1m0s`` sets a cache expiry of 1 minute.
   - ``2m30s`` sets a cache expiry of 2 minutes and 30 seconds.

   The following table provides guidance for setting the cache value:

   .. list-table::
      :header-rows: 1
      :widths: 40 60
      :width: 50%

      * - Security Goal
        - Value

      * - *Liberal*
        - ``30s``
      
      * - *Moderate*
        - ``20s``

      * - *Conservative*
        - ``5s``

Logging Configuration
~~~~~~~~~~~~~~~~~~~~~

The following section describes logging-related configuration for the KES
server:

.. code-block:: yaml

   log:
      error: <string>
      audit: <string>

.. kesconf:: log

   The root field for log-related configuration.

.. kesconf:: log.error

   Enables or disables error logging to ``STDERR``.

   - Specify ``on`` to enable error logging. 

   - Specify ``off`` to disable error logging.

   Defaults to ``on``.

.. kesconf:: log.audit

   Enables or disables audit logging to ``STDOUT``.

   - Specify ``on`` to enable audit logging.

   - Specify ``off`` to disable audit logging.

   Defaults to ``off``.

   The KES server emits an audit event for every client request. Each
   event describes the complete request-response pair and includes information
   about the requesting client. The audit information *never* contains
   plaintext cryptographic keys. 

   KES server may produce many audit events depending on the number of MinIO
   servers or other clients making requests to the server.

Policy Configuration
~~~~~~~~~~~~~~~~~~~~

The following section describes policy-related configuration for the KES server.
Policies control :ref:`Identity and Access Management <minio-kes-iam>` for
the KES server.

Policies listed in this section are *persistent* through KES server restarts.
Policies created using :mc:`kes policy` are *ephemeral* and are removed after
KES server restart. To make a policy created or modified through 
:mc:`kes policy` persistent. add that policy to this section of the 
KES configuration file:

.. code-block:: yaml

   policy:
      policyname:
         paths: <array>
         identities: <array>

.. kesconf:: policy

   The root field for policy-related configuration.

.. kesconf:: policy.policyname

   The name of the policy. Replace the field ``policyname`` with a string
   for the policy name. The policy name *must* be unique among all other
   ``policyname`` objects specified to :kesconf:`policy`.

.. kesconf:: policy.policyname.paths

   An array of :ref:`KES API Endpoints <minio-kes-endpoints>` which
   the specified :kesconf:`policy.policyname.identities` can access.

   Each endpoint *must* be a glob pattern in the following form:

   .. code-block:: shell

      <APIVERSION>/<API>/<operation>/[<argument>/<argument>/]

   You can specify an asterisk ``*`` to create a catch-all pattern for
   a given endpoint. For example, the following endpoint pattern 
   allows complete access to key creation via the ``/v1/key/create`` 
   endpoint:

.. kesconf:: policy.policyname.identities

   An array of x.509 identities associated to the policy. KES grants clients
   authenticating with a matching x.509 certificate access to the
   endpoints listed in the :kespolicy:`~policyName.paths` for the 
   policy.

   Use :mc-cmd:`kes tool identity of` to compute the name of each x.509
   certificate you want to associate to the policy and specify that value
   to the array.

Filesystem KMS Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following section describes Filesystem KMS-related configuration for the
KES server.

Configuring the KES server for Filesystem KMS directs KES to store
generated Customer Master Keys (CMK) on-disk. Filesystem KMS is appropriate
for local development and evaluation of KES *only* and should *never* be used
for production environments.

.. code-block:: yaml

   keys:
      fs:
         path: <string>

.. kesconf:: keys
   :noindex:

   The root field for KMS-related configuration.

.. kesconf:: keys.fs

   The root field for Filesystem KMS-related configuration.

.. kesconf:: keys.fs.path

   The filesystem path to the directory on disk where KES stores any
   generated CMK.

Hashicorp Vault Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following section describes Hashicorp Vault-related configuration for
the KES server.

For more complete documentation on configuring KES for connecting to a 
Hashicorp Vault KMS, see <TODO>.

.. code-block:: yaml

   keys:
      vault:
         endpoint: https://[IP|HOSTNAME]
         approle:
            id: "<string>"
            secret: "<string>"
            retry: <string>
         status:
            ping: <string>
         tls:
            ca: <string>

.. kesconf:: keys
   :noindex:

   The root field for KMS-related configuration.

.. kesconf:: keys.vault

   The root field for Hashicorp Vault-related configuration. 

.. kesconf:: keys.vault.endpoint

   Specify the URL endpoint of the Hashicorp Vault server.

.. kesconf:: keys.vault.prefix

   Specify the prefix under which the KES server looks for secret keys. 
   Required if the Vault ``AppRole`` capabilities specifies a prefix for keys
   generated by that ``AppRole``.

.. kesconf:: keys.vault.approle

   Contains information related to Hashicorp Vault 
   `AppRole Authentication <https://www.vaultproject.io/docs/auth/approle>`__.

   KES authenticates to Hashicorp Vault using the ``AppRole`` ID and secret. 
   The specified ``AppRole`` *must* grant KES ``create``, ``read``, and
   ``delete`` capabilities on Vault. Defer to Vault documentation for
   more complete guidance on configuring ``AppRole`` ID and permission.

.. kesconf:: keys.vault.approle.id

   Specify the ID of the Vault ``AppRole`` with which KES authenticates.

.. kesconf:: keys.vault.approle.secret

   Specify the corresponding secret ID for the specified 
   :kesconf:`keys.vault.approle.id`.

.. kesconf:: keys.vault.approle.retry

   The duration KES waits before attempting to reconnect to the Vault server.
   Specify a string as ``##h##m##s``.

.. kesconf:: keys.vault.status

   Contains information related to retrieving the status of the Vault server.

.. kesconf:: keys.vault.status.ping

   The duration KES waits between requesting status information onn the Vault
   server. Specify a string as ``##h##m##s``.

.. kesconf:: keys.vault.tls

   Contains information related to the TLS Certificate Authority used by the
   vault server. KES may require this for self-signed certificates *or*
   for certificates signed by a non-global Certificate Authority.

.. kesconf:: keys.vault.tls.ca

   Specify the full path to the Certificate Authority ``*.crt`` file used to 
   sign the Vault TLS certificates. 
   


.. toctree::
   :titlesonly:
   :hidden:
   :glob:

   /minio-cli/kes/*