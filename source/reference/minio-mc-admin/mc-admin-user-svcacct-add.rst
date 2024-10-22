.. _minio-mc-admin-svcacct-add:

=============================
``mc admin user svcacct add``
=============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin user svcacct add

.. important::

   This command has been replaced and will be deprecated in a future MinIO Client release.

   As of MinIO Client RELEASE.2024-10-08T09-37-26Z, use the :mc:`mc admin accesskey create` command to add access keys for built-in MinIO IDP users.

   To add access keys for AD/LDAP users, use the :mc:`mc idp ldap accesskey create` command.


Syntax
------

.. start-mc-admin-svcacct-add-desc

The :mc-cmd:`mc admin user svcacct add` command adds a new access key to an existing MinIO or AD/LDAP user.

.. end-mc-admin-svcacct-add-desc

.. admonition:: Access keys for OpenID Connect users
   :class: note

   To generate service account access keys for :ref:`OpenID Connect users <minio-external-identity-management-openid>`, use the :ref:`MinIO Console <minio-console>`.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command creates a new access key associated to an existing MinIO user:

      .. code-block:: shell                                                                 
         :class: copyable

         mc admin user svcacct add                       \
            --access-key "myuserserviceaccount"          \                                  
            --secret-key "myuserserviceaccountpassword"  \
            --policy "/path/to/policy.json"              \
            myminio myuser                                                                  
                                                                                   
      The command returns the access key and secret key for the new account.

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] admin user svcacct add             \
                                             [--access-key]  \
                                             [--secret-key]  \
                                             [--policy]      \
                                             [--comment]     \
                                             ALIAS           \
                                             USER
					
      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :mc-cmd:`alias <mc alias>` of the MinIO deployment.

.. mc-cmd:: USER
   :required:

   The username of the user to which MinIO adds the new access key.

   - For :ref:`MinIO-managed users <minio-users>`, specify the access key for the user.
   - For :ref:`Active Directory/LDAP users <minio-external-identity-management-ad-ldap>`, specify the Distinguished Name of the user.
   - For :ref:`OpenID Connect users <minio-external-identity-management-openid>`, use the :ref:`MinIO Console <minio-console>` to generate access keys.

.. mc-cmd:: --access-key
   :optional:

   A string to use as the access key for this account.
   Omit to let MinIO autogenerate a random 20 character value.

   Access Key names *must* be unique across all users.

.. mc-cmd:: --comment
   :optional:

   .. versionchanged:: RELEASE.2023-05-18T16-59-00Z
      Replaced by :mc-cmd:`~mc admin user svcacct add --description` and :mc-cmd:`~mc admin user svcacct add --name`.
      
      Originally added in version RELEASE.2023-01-28T20-29-38Z.


   This option has been removed.
   Use ``--description`` or ``--name`` instead.

.. mc-cmd:: --description
   :optional:

   .. versionadded:: RELEASE.2023-05-18T16-59-00Z

   Add a description for the service account.
   For example, you might specify the reason the service account exists.

.. mc-cmd:: --expiry
   :optional:

   .. versionadded:: RELEASE.2023-05-30T22-41-38Z

   Set an expiration date for the service account.
   The date must be in the future, you may not set an expiration date that has already passed.

   Allowed date and time formats:

   - ``2023-06-24``
   - ``2023-06-24T10:00``
   - ``2023-06-24T10:00:00``
   - ``2023-06-24T10:00:00Z``
   - ``2023-06-24T10:00:00-07:00``

.. mc-cmd:: --name
   :optional:

   .. versionadded:: RELEASE.2023-05-18T16-59-00Z

   Add a human-readable name for the service account.

.. mc-cmd:: --policy
   :optional:

   The path to a :ref:`policy document <minio-policy>` to attach to the new access key, with a maximum size of 2048 characters.
   The attached policy cannot grant access to any action or resource not explicitly allowed by the parent user's policies.
   

.. mc-cmd:: --secret-key
   :optional:

   The secret key to associate with the new account.
   Omit to let MinIO autogenerate a random 40-character value.


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
