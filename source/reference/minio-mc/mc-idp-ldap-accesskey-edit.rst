.. _minio-mc-idp-ldap-accesskey-edit:

==============================
``mc idp ldap accesskey edit``
==============================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2


.. mc:: mc idp ldap accesskey edit


Description
-----------

.. start-mc-idp-ldap-accesskey-edit-desc

:mc:`mc idp ldap accesskey edit` modifies the specified :ref:`access key <minio-id-access-keys>` on the local server.

.. end-mc-idp-ldap-accesskey-rm-desc

.. tab-set::

   .. tab-item:: EXAMPLE

         The following example modifies the secret for the access key ``mykey`` on the ``minio`` deployment:

      .. code-block:: shell
         :class: copyable

         mc idp ldap accesskey edit myminio/ mykey --secret-key 'xxxxxxx' 

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] idp ldap accesskey rm                        \
                                          ALIAS                        \
                                          KEY                          \
                                          [--secret-key <string>]      \
                                          [--policy <string>]          \
                                          [--name <string>]            \
                                          [--description <string>]     \
                                          [--expiry-duration <string>] \
                                          [--expiry <string>]


      - Replace ``ALIAS`` with the :ref:`alias <alias>` of a MinIO deployment configured for AD/LDAP integration.
      - Replace ``KEY`` with the access key to delete.
        
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

         mc idp ldap accesskey ls minio

.. mc-cmd:: KEY
   :required:

   The configured access key to delete.

.. mc-cmd:: --description
   :optional:

   Add a description for the service account.
   For example, you might specify the reason the access key exists.

.. mc-cmd:: --expiry
   :optional:

   The date after which the access key expires.
   Enter the date in YYYY-MM-DD format.

   For example, to expire the credentials after December 31, 2024, enter ``2024-12-31``.

   Mutually exclusive with :mc-cmd:`~mc idp ldap accesskey edit --expiry-duration`.

.. mc-cmd:: --expiry-duration
   :optional:

   Length of time the access key pair should remain valid for use in ``#d#h#s`` format.
       
   For example, ``7d``, ``24h``, ``5d12h30s`` are valid strings.

   Mutually exclusive with :mc-cmd:`~mc idp ldap accesskey edit --expiry`.

.. mc-cmd:: --name
   :optional:

   A human-readable name to use for the account.

.. mc-cmd:: --policy
   :optional:

   File path to the JSON-formatted policy to use for the account.

   If not specified, the account uses the same policy as the authenticated user.

.. mc-cmd:: --secret-key
   :optional:

   A secret to use for the account.


Example
~~~~~~~

Modify a secret for an access key
+++++++++++++++++++++++++++++++++

Modify the secret for the access key ``mykey`` on the ``minio`` deployment.

.. code-block:: shell
   :class: copyable

   mc idp ldap accesskey edit myminio/ mykey --secret-key 'xxxxxxx' 

Modify the expiration duration for an accesskey
+++++++++++++++++++++++++++++++++++++++++++++++

Modify the expiration duration for the access key ``mykey`` on the ``minio`` deployment.

.. code-block:: shell
   :class: copyable

   mc idp ldap accesskey edit myminio/ mykey ---expiry-duration 24h 


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
