.. _minio-mc-legalhold-info:

=====================
``mc legalhold info``
=====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc legalhold info

.. |command| replace:: :mc:`mc legalhold info`
.. |rewind| replace:: :mc-cmd:`~mc legalhold info --rewind`
.. |versionid| replace:: :mc-cmd:`~mc legalhold info --version-id`
.. |alias| replace:: :mc-cmd:`~mc legalhold info ALIAS`

Syntax
------

.. start-mc-legalhold-info-desc

The :mc:`mc legalhold info` command returns the current :ref:`legal hold
<minio-object-locking-legalhold>` setting for an object or objects.

.. end-mc-legalhold-info-desc

:mc:`mc legalhold` *requires* that the specified bucket has object locking
enabled. You can **only** enable object locking at bucket creation. See
:mc-cmd:`mc mb --with-lock` for documentation on creating buckets with
object locking enabled. 

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command retrieves the current legalhold status for objects
      in the ``mydata`` bucket on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc legalhold info --recursive myminio/mydata

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] legalhold info  \
                          [--recursive]   \
                          [--rewind]      \
                          [--version-id]  \
                          ALIAS

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The MinIO :ref:`alias <alias>` and path to the object or
   objects on which to enable the legal hold. For example:

   .. code-block:: shell
      
      mc legalhold info play/mybucket/myobjects/objects.txt

.. mc-cmd:: --recursive, r
   :optional:

   Returns the legal hold status of all objects in the 
   :mc-cmd:`~mc legalhold info ALIAS` bucket or bucket prefix.

.. mc-cmd:: --rewind
   :optional:

   .. include:: /includes/facts-versioning.rst
      :start-after: start-rewind-desc
      :end-before: end-rewind-desc

.. mc-cmd:: --version-id, vid
   :optional:

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

Retrieve the Legal Hold Status Objects
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc legalhold info` to retrieve the legal hold status of an object.
Include :mc-cmd:`~mc legalhold info --recursive` to return the legal hold
status of the contents of a bucket:

.. code-block:: shell
   :class: copyable

   mc legalhold clear [--recursive] ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc legalhold info ALIAS>` with the 
  :ref:`alias <alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc legalhold info ALIAS>` with the path to the bucket
  or object on the S3-compatible host. If specifying the path to a bucket or
  bucket prefix, include the :mc-cmd:`~mc legalhold info --recursive`
  option.


Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
