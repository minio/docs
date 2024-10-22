.. _minio-mc-admin-accesskey-edit:

================================
``mc admin user accesskey edit``
================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin accesskey edit


Syntax
------

.. start-mc-admin-accesskey-edit-desc

The :mc-cmd:`mc admin accesskey edit` command modifies the configuration of an access key associated to the specified user.

.. end-mc-admin-accesskey-edit-desc

The command requires that at least one attribute of the access key change.
Otherwise, the command exits with an error message.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command applies a new policy and secret key to the ``myuserserviceaccount`` access key on the ``myminio`` deployment:

      .. code-block:: shell  
         :class: copyable 

         mc admin accesskey edit                                             \  
                            myminio myuserserviceaccount                     \
                            --secret-key "myuserserviceaccountnewsecretkey"  \     
                            --policy "/path/to/new/policy.json"    

   .. tab-item:: SYNTAX

      The command has the following syntax: 
  
      .. code-block:: shell  
         :class: copyable 

         mc [GLOBALFLAGS] admin accesskey edit                      \  
                                          ALIAS                     \  
                                          ACCESSKEY                 \
                                          [--description string]    \
                                          [--expiry-duration value] \
                                          [--expiry value]          \
                                          [--name string]           \
                                          [--policy path]           \  
                                          [--secret-key string]  

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :mc-cmd:`alias <mc alias>` of the MinIO deployment.

.. mc-cmd:: ACCESSKEY
   :required:

   The access key to modify.

.. mc-cmd:: --description
   :optional:

   Add or modify a description for the access key.
   For example, you might specify the reason the access key exists.

.. mc-cmd:: --expiry
   :optional:

   Set or modify an expiration date for the access key.
   The date must be in the future, you may not set an expiration date that has already passed.

   Allowed date and time formats:

   - ``2023-06-24``
   - ``2023-06-24T10:00``
   - ``2023-06-24T10:00:00``
   - ``2023-06-24T10:00:00Z``
   - ``2023-06-24T10:00:00-07:00``

   Mutually exclusive with :mc-cmd:`~mc admin accesskey edit --expiry-duration`.

.. mc-cmd:: --expiry-duration
   :optional:

   Length of time for which the accesskey remains valid.

   For example, ``30d``, ``24h``, or similar.
   To expire the credentials after 30 days, use:

   .. code-block::

      --expiry-duration 30d

   Mutually exclusive with :mc-cmd:`~mc admin accesskey edit --expiry`.

.. mc-cmd:: --name
   :optional:

   Add or modify a human-readable name for the access key.

.. mc-cmd:: --policy
   :optional:

   The path to a :ref:`policy document <minio-policy>` to attach to the new access key, with a maximum size of 2048 characters.
   The attached policy cannot grant access to any action or resource not explicitly allowed by the parent user's policies.

   The new policy overwrites any previously attached policy.

.. mc-cmd:: --secret-key
   :optional:

   The secret key to associate with the new access key.
   Overwrites the previous secret key.
   Applications using the access keys *must* update to use the new credentials to continue performing operations.


Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Change the secret key for an access key
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command modifies the secret key for the access key ``myuseraccesskey`` on the ``myminio`` deployment.

.. code-block:: shell
   :class: copyable

   mc admin accesskey edit myminio/ myuseraccesskey --secret-key 'new-secret-key-change-me'

Change the expiration for an access key
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command changes the expiration value for the access key ``myuseraccesskey`` on the ``myminio`` deployment.

.. code-block:: shell
   :class: copyable

   mc admin accesskey edit myminio/ myuseraccesskey --expiry-duration 24h

The :mc-cmd:`~mc admin accesskey edit --expiry-duration` cannot be added if the access key already has a value set for :mc-cmd:`~mc admin accesskey edit --expiry`.


Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
