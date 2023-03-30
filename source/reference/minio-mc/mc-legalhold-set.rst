.. _minio-mc-legalhold-set:

====================
``mc legalhold set``
====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc legalhold set

.. |command| replace:: :mc:`mc legalhold set`
.. |rewind| replace:: :mc-cmd:`~mc legalhold set --rewind`
.. |versionid| replace:: :mc-cmd:`~mc legalhold set --version-id`
.. |alias| replace:: :mc-cmd:`~mc legalhold set ALIAS`

Syntax
------

.. start-mc-legalhold-set-desc

The :mc:`mc legalhold set` command enables :ref:`legal hold
<minio-object-locking-legalhold>` Write-Once Read-Many (WORM) object locking on
an object or objects.

.. end-mc-legalhold-set-desc

:mc:`mc legalhold` *requires* that the specified bucket has 
:ref:`object locking enabled <minio-object-locking>`. You can **only** enable
object locking at bucket creation. See :mc-cmd:`mc mb --with-lock` for
documentation on creating buckets with object locking enabled. 

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command enables legalhold WORM locking on all objects
      in the ``mydata`` bucket on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc legalhold set --recursive myminio/mydata

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] legalhold set  \
                          [--recursive]  \
                          [--rewind]     \
                          [--version-id] \
                          ALIAS

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS

   *Required* The MinIO :ref:`alias <alias>` and path to the object or
   objects on which to enable the legal hold. For example:

   .. code-block:: shell
      
      mc legalhold set play/mybucket/myobjects/objects.txt

.. mc-cmd:: --recursive, r
   

   *Optional* Applies the legal hold to all objects in the 
   :mc-cmd:`~mc legalhold set ALIAS` bucket or bucket prefix.

.. mc-cmd:: --rewind
   :optional:

   .. include:: /includes/facts-versioning.rst
      :start-after: start-rewind-desc
      :end-before: end-rewind-desc

.. mc-cmd:: --version-id, vid
   

   .. include:: /includes/facts-versioning.rst
      :start-after: start-version-id-desc
      :end-before: end-version-id-desc

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Use :mc:`mc legalhold set` to enable legal hold on objects:

.. code-block:: shell
   :class: copyable

   mc legalhold set [--recursive] ALIAS/PATH 

- Replace :mc-cmd:`ALIAS <mc legalhold set ALIAS>` with the 
  :ref:`alias <alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc legalhold set ALIAS>` with the path to the bucket
  or object on the S3-compatible host. If specifying the path to a bucket or
  bucket prefix, include the :mc-cmd:`~mc legalhold set --recursive`
  option.

Behavior
--------

Legal Holds Require Explicit Removal
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Legal Holds are indefinite and enforce complete immutability for locked objects.
Only privileged users with the :policy-action:`s3:PutObjectLegalHold` can set or
lift the Legal Hold.

Legal Holds Complement Other Retention Modes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Legal holds are complementary to both :ref:`minio-object-locking-governance` and
:ref:`minio-object-locking-compliance` retention settings. An object held under
both legal hold *and* a ``GOVERNANCE/COMPLIANCE`` retention rule remains WORM
locked until the legal hold is lifed *and* the rule expires.

For ``GOVERNANCE`` locked objects, the legal hold prevents mutating the object
*even if* the user has the necessary privileges to bypass retention.

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
