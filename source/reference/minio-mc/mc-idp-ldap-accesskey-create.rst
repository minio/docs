.. _minio-mc-idp-ldap-accesskey-create:

================================
``mc idp ldap accesskey create``
================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2


.. mc:: mc idp ldap accesskey create

.. versionadded:: mc RELEASE.2023-12-23T08-47-21Z 

Description
-----------

.. start-mc-idp-ldap-accesskey-create-desc

The :mc:`mc idp ldap accesskey create` allows you to add LDAP access key pairs.

.. end-mc-idp-ldap-accesskey-create-desc

.. tab-set::

   .. tab-item:: EXAMPLE

         The following example creates a new access key pair with the same policy as the authenticated user on the ``minio`` :ref:`alias <alias>`:

      .. code-block:: shell
         :class: copyable

         mc idp ldap accesskey create minio/

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] idp ldap accesskey create                   \
                                          ALIAS                       \
                                          [--access-key <value>]      \
                                          [--secret-key <value>]      \
                                          [--policy <value>]          \
                                          [--name <value>]            \
                                          [--description <value>]     \
                                          [--expiry-duration <value>] \ 
                                          [--login <site>]

      - Replace ``ALIAS`` with the :ref:`alias <alias>` of a MinIO deployment configured for AD/LDAP integration.

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :ref:`alias <alias>` of the MinIO deployment configured for AD/LDAP.

   For example:

   .. code-block:: none

         mc idp ldap accesskey create minio

.. mc-cmd:: --access-key
   :optional:

   An access key to use for the account.
   The access key cannot contain the characters ``=`` (equal sign) or ``,`` (comma).

   Requires :mc-cmd:`~mc idp ldap accesskey create --secret-key`

.. mc-cmd:: --secret-key
   :optional:

   A secret to use for the account.

   Requires :mc-cmd:`~mc idp ldap accesskey create --access-key`

.. mc-cmd:: --policy
   :optional:

   File path to the JSON-formatted policy to use for the account.

   If not specified, the account uses the same policy as the authenticated user.

.. mc-cmd:: --name
   :optional:

   A human-readable name to use for the account.

.. mc-cmd:: --description
   :optional:

   Add a description for the service account.
   For example, you might specify the reason the access key exists.

.. mc-cmd:: --expiry-duration
   :optional:

   Length of time the access key pair should remain valid for use in ``#d#h#s`` format.
       
   For example, ``7d``, ``24h``, ``5d12h30s`` are valid strings.

   Mutually exclusive with :mc-cmd:`~mc idp ldap accesskey create --expiry`.

.. mc-cmd:: --expiry
   :optional:

   The date after which the access key expires.
   Enter the date in YYYY-MM-DD format.

   For example, to expire the credentials after December 31, 2024, enter ``2024-12-31``.

   Mutually exclusive with :mc-cmd:`~mc idp ldap accesskey create --expiry-duration`.

.. mc-cmd:: --login
   :optional:

   Prompts the user to log in using the LDAP credentials to use to generate the access key.
   Specify the URL of the LDAP-configured MinIO Server to use for the login prompt.

   Requires an interactive terminal.


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

   mc idp ldap accesskey create minio

Create a new access-key pair with a custom access key and secret key
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command creates a new access key pair with both an access key and secret key that you specify for the user currently authenticated on the ``minio`` alias.

.. code-block:: shell
   :class: copyable

   mc idp ldap accesskey create minio/ --access-key my-access-key-change-me --secret-key my-secret-key-change-me

Create a new access-key pair that expires after 24 hours
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command creates a new access key pair to use with the currently authenticated user on the ``minio`` alias.
The credentials expire after 24 hours.

The command outputs a randomly generated access key and secret key.

.. code-block:: shell
   :class: copyable

   mc idp ldap accesskey create minio --expiry-duration 24h

Create a new access-key and prompt to login as the user
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command creates a new access key pair.
The MinIO Client will first ask you to log in as the user the access key is for on the MinIO site configured for LDAP at ``minio.example.com``.

The command outputs a randomly generated access key and secret key.

.. code-block:: shell
   :class: copyable

   mc idp ldap accesskey create minio --login minio.example.com

Create a new access-key pair that expires after a date
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command creates a new access key pair to use with the currently authenticated user on the ``minio`` alias.
The credentials expire after February 29, 2024.

The command outputs a randomly generated access key and secret key.

.. code-block:: shell
   :class: copyable

   mc idp ldap accesskey create minio --expiry 2024-02-29