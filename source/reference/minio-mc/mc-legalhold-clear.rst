.. _minio-mc-legalhold-clear:

======================
``mc legalhold clear``
======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc legalhold clear

.. |command| replace:: :mc:`mc legalhold clear`
.. |rewind| replace:: :mc-cmd:`~mc legalhold clear --rewind`
.. |versionid| replace:: :mc-cmd:`~mc legalhold clear --version-id`
.. |alias| replace:: :mc-cmd:`~mc legalhold clear ALIAS`

Syntax
------

.. start-mc-legalhold-clear-desc

The :mc:`mc legalhold clear` command removes the current :ref:`legal hold
<minio-object-locking-legalhold>` setting for an object or objects.

.. end-mc-legalhold-clear-desc

Removing the legal hold on object(s) does *not* remove any other 
:ref:`minio-object-locking-governance` and
:ref:`minio-object-locking-compliance` retention settings in place for
the object(s)

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command removes the legal hold on all objects in the
      ``mydata`` bucket on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc legalhold clear --recursive myminio/mydata

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] legalhold clear \
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

   *Required* The MinIO :ref:`alias <alias>` and path to the object or
   objects on which to remove the legal hold. For example:

   .. code-block:: shell
      
      mc legalhold clear play/mybucket/myobjects/objects.txt

.. mc-cmd:: --recursive, r
   

   Removes the legal hold on all objects in the 
   :mc-cmd:`~mc legalhold clear ALIAS` bucket or bucket prefix.

.. mc-cmd:: --rewind
   

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

Retrieve the Legal Hold Status Objects
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc legalhold clear` to retrieve the legal hold status of an object.
Include :mc-cmd:`~mc legalhold clear --recursive` to return the legal hold
status of the contents of a bucket:

.. code-block:: shell
   :class: copyable

   mc legalhold clear [--recursive] ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc legalhold clear ALIAS>` with the 
  :ref:`alias <alias>` of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc legalhold clear ALIAS>` with the path to the bucket
  or object on the S3-compatible host. If specifying the path to a bucket or
  bucket prefix, include the :mc-cmd:`~mc legalhold clear --recursive`
  option.

Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
