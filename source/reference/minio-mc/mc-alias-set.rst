.. _minio-mc-alias-set:
.. _minio-mc-alias:
.. _alias:

================
``mc alias set``
================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc alias set

.. |command| replace:: :mc:`mc alias set`

Syntax
------

.. start-mc-alias-set-desc

The :mc:`mc alias set` command adds or updates an alias to the local
:program:`mc` configuration.

.. end-mc-alias-set-desc

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command adds an :ref:`alias <alias>` for a MinIO
      deployment ``myminio`` running at the URL
      ``https://myminio.example.net``. :program:`mc` uses the specified 
      username and password for authenticating to the MinIO deployment:

      .. code-block:: shell
         :class: copyable
         
         mc alias set myminio https://myminio.example.net minioadminuser minioadminpassword

      If the ``myminio`` alias already exists, the command overwrites that
      alias with the new URL, access key, and secret key.

   .. tab-item:: SYNTAX

      The :mc:`mc alias set` command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] alias set \ 
                          [--api "string"]                           \
                          [--path "string"]                          \
                          ALIAS                                      \ 
                          URL                                        \
                          ACCESSKEY                                  \
                          SECRETKEY

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS

   *Required* The name to associate to the S3-compatible service.

.. mc-cmd:: URL

   *Required* The URL to the S3-compatible service endpoint. For example:

   ``https://minio.example.net``

.. mc-cmd:: ACCESSKEY
   
   *Required*

   The access key for authenticating to the S3 service.

.. mc-cmd:: SECRETKEY

   *Required*

   The secret key for authenticating to the S3 service.

.. mc-cmd:: --api
   
   
   *Optional*

   Specifies the signature calculation method to use when connecting to the
   S3-compatible service. Supports the following values:

   - ``S3v4`` (Default)
   - ``S3v2``

   .. note::

      AWS Signature V2 is considered
      `deprecated <https://aws.amazon.com/blogs/aws/amazon-s3-update-sigv2-deprecation-period-extended-modified/>`__
      by AWS. :mc:`mc alias set` includes this option only for S3 buckets
      or services still reliant on the Signature V2.
      
      Use ``S3v4`` unless explicitly required by the S3-compatible service.
      MinIO server does not rely on nor require ``S3v2``, nor are all API
      operations available on ``S3v2``. 

.. mc-cmd:: --path
   

   *Optional*

   Specifies the bucket path lookup setting used by the server. Supports the
   following values:

   - ``"auto"`` (Default)
   - ``"on"``
   - ``"off"``

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Add or Update an Alias for a MinIO Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc alias set` to add an S3-compatible service for use with
:program:`mc`:

.. tab-set::

   .. tab-item:: Example

      The following command creates a new alias ``myminio`` pointing at a
      MinIO deployment at ``https://minio.example.net``. The
      alias uses the ``miniouser`` and ``miniopassword`` credentials for
      performing operations against the deployment.

      .. code-block:: shell
         :class: copyable

         mc alias set myminio https://minio.example.net miniouser miniopassword

      If the ``myminio`` alias already exists, the 
      :mc:`mc alias set` command overwrites that alias with the specified
      arguments.

   .. tab-item:: Syntax

      .. code-block:: shell
         :class: copyable

         mc alias set ALIAS HOSTNAME ACCESSKEY SECRETKEY

      - Replace ``ALIAS`` with the the name to associate to the 
        MinIO service.

      - Replace ``HOSTNAME`` with the URL for any node in the MinIO
        deployment. You can alternatively specify the URL for a load balancer
        or reverse proxy managing connections to the MinIO deployment.

      - Replace ``ACCESSKEY`` and ``SECRETKEY`` with credentials for a user
        on the MinIO deployment.

Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility

Required Credentials and Access Control
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

:mc:`mc alias set` requires specifying an access key and corresponding
secret key for the S3-compatible host. :program:`mc` functionality is limited
based on the policies associated to the specified credentials. For example, if
the specified credentials do not have read/write access to a specific bucket,
:program:`mc` cannot perform read or write operations on that bucket.

For more information on MinIO Access Control, see
:ref:`minio-access-management`. 

For more complete documentation on S3 Access Control, see
:s3-docs:`Amazon S3 Security <security.html>`.

For all other S3-compatible services, defer to the documentation for that
service.

Certificates
~~~~~~~~~~~~

The MinIO Client fetches the peer certificate, computes the public key fingerprint, and asks the user whether to accept the deployment's certificate.

If trusted, the MinIO Client automatically adds the certificate authority to:

-  ``~/.mc/certs/CAs/`` on Linux and other Unix-like systems.
-  ``C:\Users\[username]\mc\certs\CAs\`` on Windows systems.