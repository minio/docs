.. _minio-mc-admin-accesskey-create:

=============================
``mc admin accesskey create``
=============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin accesskey create


Syntax
------

.. start-mc-admin-accesskey-create-desc

The :mc-cmd:`mc admin accesskey create` command adds a new access key and secret key pair for an existing MinIO user.

.. end-mc-admin-accesskey-create-desc

.. admonition:: Access keys for OpenID Connect or AD/LDAP users
   :class: note

   This command is for access keys for users created directly on the MinIO deployment and not managed by a third party solution.

   To generate access keys for :ref:`Active Directory/LDAP users <minio-external-identity-management-ad-ldap>`, use :mc:`mc idp ldap accesskey create`.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command creates a new access key associated to an existing MinIO user:

      .. code-block:: shell                                                                 
         :class: copyable

         mc admin accesskey create        \
            myminio/ myuser               \                                                  
            --access-key myuseraccesskey  \                                  
            --secret-key myusersecretkey  \
            --policy /path/to/policy.json 
                                                                                   
      The command returns the access key and secret key for the new account.

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] admin accesskey create                    \
                                          ALIAS                     \
                                          [USER]                    \
                                          [--access-key string]     \
                                          [--secret-key string]     \
                                          [--policy path]           \
                                          [--name string]           \
                                          [--description string]    \
                                          [--expiry-duration value] \
                                          [--expiry date]
					
      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :mc-cmd:`alias <mc alias>` of the MinIO deployment.

.. mc-cmd:: USER
   :optional:

   The username of the user to which MinIO adds the new access key.
   If not specified, MinIO generates an access key/secret key pair for the authenticated user.

.. mc-cmd:: --access-key
   :optional:

   A string to use as the access key for this account.
   Omit to let MinIO autogenerate a random 20 character value.

   Access Key names *must* be unique across all users.

.. mc-cmd:: --description
   :optional:

   Add a description for the access key.
   For example, you might specify the reason the access key exists.

.. mc-cmd:: --expiry
   :optional:

   Set an expiration date for the access key.
   The date must be in the future.
   You may not set an expiration date that has already passed.

   Allowed date and time formats:

   - ``2024-10-24``
   - ``2024-10-24T10:00``
   - ``2024-10-24T10:00:00``
   - ``2024-10-24T10:00:00Z``
   - ``2024-10-24T10:00:00-07:00``
   
   Mutually exclusive with :mc-cmd:`~mc admin accesskey create --expiry-duration`.

.. mc-cmd:: --expiry-duration
   :optional:

   Length of time for which the accesskey remains valid.
   Valid time units are "ns", "us" (or "µs"), "ms", "s", "m", "h".

   The following expires the credentials after 30 days:

   .. code-block::

      --expiry-duration 720h

   Mutually exclusive with :mc-cmd:`~mc admin accesskey create --expiry`.

.. mc-cmd:: --name
   :optional:

   Add a human-readable name for the access key.

.. mc-cmd:: --policy
   :optional:

   The readable path to a :ref:`policy document <minio-policy>` to attach to the new access key, with a maximum size of 2048 characters.
   The attached policy cannot grant access to any action or resource not explicitly allowed by the parent user's policy or group policies

.. mc-cmd:: --secret-key
   :optional:

   The secret key to associate with the new account.
   Omit to let MinIO autogenerate a random 40-character value.


Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals


Examples
--------

Create access key / secret key pair for the authenticated user
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command generates a new, random access key and secret key pair for the user currently logged in to MinIO deployment at the alias ``myminio``.
The access key and secret key have the same access policies as the authenticated user.

.. code-block:: shell
   :class: copyable

   mc admin accesskey create myminio/

Create a custom access key / secret key pair for the authenticated user
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command creates a new access key and secret key pair for the user currently logged in to MinIO at the alias ``myminio``.
The access key and secret key have the same access policies as the authenticated user.

.. code-block:: shell
   :class: copyable

   mc admin accesskey create myminio/ --access-key myaccesskey --secret-key mysecretkey 

Create an access key / secret key pair for another user with limited duration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command creates a new access key and secret key pair for a user, ``miniouser`` on the alias ``myminio``.
The access key and secret key have the same access policies as ``miniouser``.
The credentials remain valid for 24 hours after creation.

.. code-block:: shell
   :class: copyable

   mc admin accesskey create myminio/ miniouser --expiry-duration 24h


Create access key / secret key pair for the authenticated user that expires
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command generates a new and random access key and random secret key pair for the user currently logged in to MinIO deployment at the alias ``myminio``.
The access key and secret key have the same access policies as the authenticated user.
The credentials expire on the fifteenth day of January, 2025.

.. code-block:: shell
   :class: copyable

   mc admin accesskey create myminio/ --expiry 2025-01-15

The date specified **must** be a future date.
For valid datetime formats, see the :mc-cmd:`~mc admin accesskey create --expiry` flag.

Create access key / secret key pair for a different user with custom access
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command creates a new access key and secret key pair for the user, ``miniouser`` on the alias ``myminio``.
The access key and secret key have a more limited set of access than ``miniouser``, as specified in the policy JSON file.

.. code-block:: shell
   :class: copyable

   mc admin accesskey create myminio/ miniouser --policy /path/to/policy.json 

The specified policy file **must not** grant access to anything to which ``miniouser`` does not already have access.

Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
