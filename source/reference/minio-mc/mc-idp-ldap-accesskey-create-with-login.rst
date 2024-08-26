.. _minio-mc-idp-ldap-accesskey-create-with-login:

===========================================
``mc idp ldap accesskey create-with-login``
===========================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2


.. mc:: mc idp ldap accesskey create-with-login

.. versionadded:: mc RELEASE.2024-04-18T16-45-29Z

Description
-----------

.. start-mc-idp-ldap-accesskey-create-with-login-desc

The :mc:`mc idp ldap accesskey create-with-login` uses interactive terminal-based prompt to authenticate with the external AD/LDAP server and generate access keys for use with MinIO.

.. end-mc-idp-ldap-accesskey-create-with-login-desc

.. tab-set::

   .. tab-item:: EXAMPLE

         The following example prompts the user to provide their AD/LDAP credentials.
         It then generates a new access key pair using the policy or policies associated with that AD/LDAP user.

      .. code-block:: shell
         :class: copyable

         mc idp ldap accesskey create-with-login https://minio.example.net/

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] idp ldap accesskey create-with-login        \
                                          URL                         \
                                          [--access-key <value>]      \
                                          [--secret-key <value>]      \
                                          [--policy <value>]          \
                                          [--name <value>]            \
                                          [--description <value>]     \
                                          [--expiry <value>]          \
                                          [--expiry-duration <value>]

      - Replace ``URL`` with the :abbr:`FQDN (Fully Qualified Domain Name)` of a MinIO deployment configured for AD/LDAP integration.

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

.. mc-cmd:: URL
   :required:

   The :abbr:`FQDN (Fully Qualified Domain Name)` of a MinIO deployment configured for AD/LDAP integration.

   For example:

   .. code-block:: none

         mc idp ldap accesskey create-with-login https://minio.example.net

.. mc-cmd:: --access-key
   :optional:

   The access key to use once successfully authenticated.
   Omit to let MinIO randomly generate a value.
   
   The access key cannot contain the characters ``=`` (equal sign) or ``,`` (comma).

   Requires :mc-cmd:`~mc idp ldap accesskey create-with-login --secret-key`

.. mc-cmd:: --secret-key
   :optional:

   A secret key to use once successfully authenticated.
   Omit to let MinIO randomly generate a value.

   Requires :mc-cmd:`~mc idp ldap accesskey create-with-login --access-key`

.. mc-cmd:: --policy
   :optional:

   File path to the JSON-formatted :ref:`policy <minio-policy>` to use for the account.
   This policy _cannot_ grant additional privileges beyond the privileges associated with the authenticated AD/LDAP user.

   Omit to use the AD/LDAP user policies.

.. mc-cmd:: --name
   :optional:

   A human-readable name to use for the created access key.

.. mc-cmd:: --description
   :optional:

   Create a description for the service account.
   For example, you might specify the reason the access key exists.

.. mc-cmd:: --expiry-duration
   :optional:

   Length of time the access key pair should remain valid for use in ``#d#h#s`` format.
       
   For example, ``7d``, ``24h``, ``5d12h30s`` are valid strings.

   Mutually exclusive with :mc-cmd:`~mc idp ldap accesskey create-with-login --expiry`.

.. mc-cmd:: --expiry
   :optional:

   The date after which the access key expires.
   Enter the date in ``YYYY-MM-DD`` format.

   For example, to expire the credentials after December 31, 2024, enter ``2024-12-31``.

   Mutually exclusive with :mc-cmd:`~mc idp ldap accesskey create-with-login --expiry-duration`.


Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals


Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility

Examples
--------

Create a new access-key pair for the authenticated user
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command creates a new access key pair to use with the currently authenticated user on the ``minio`` alias.
The command outputs a randomly generated access key and secret key.

.. code-block:: shell
   :class: copyable

   mc idp ldap accesskey create-with-login https://minio.example.net

Create a new access-key pair with a custom access key and secret key
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command creates a new access key pair with both an access key and secret key that you specify for the user currently authenticated on the ``minio`` alias.

.. code-block:: shell
   :class: copyable

   mc idp ldap accesskey create-with-login https://minio.example.net/ --access-key my-access-key-change-me --secret-key my-secret-key-change-me

Create a new access-key pair that expires after 24 hours
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command creates a new access key pair to use with the currently authenticated user on the ``minio`` alias.
The credentials expire after 24 hours.

The command outputs a randomly generated access key and secret key.

.. code-block:: shell
   :class: copyable

   mc idp ldap accesskey create-with-login https://minio.example.net --expiry-duration 24h

Create a new access-key pair that expires after a date
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command creates a new access key pair to use with the currently authenticated user on the ``minio`` alias.
The credentials expire after February 28, 2025.

The command outputs a randomly generated access key and secret key.

.. code-block:: shell
   :class: copyable

   mc idp ldap accesskey create-with-login https://minio.example.net --expiry 2025-02-28