======================
``mc retention clear``
======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc retention clear

.. |command| replace:: :mc-cmd:`mc retention clear`
.. |rewind| replace:: :mc-cmd:`~mc retention clear --rewind`
.. |versionid| replace:: :mc-cmd:`~mc retention clear --version-id`
.. |versions| replace:: :mc-cmd:`~mc retention clear --versions`
.. |alias| replace:: :mc-cmd:`~mc retention clear ALIAS`

Syntax
------

.. start-mc-retention-desc

The :mc:`mc retention clear` command removes the 
:ref:`Write-Once Read-Many (WORM) locking <minio-object-locking>` settings for
an object or object(s) in a bucket. You can also remove the default object lock
settings for a bucket.

.. end-mc-retention-desc

To change the retention status of an object under 
:ref:`legal hold <minio-object-locking-legalhold>`, use 
:mc:`mc legalhold clear`.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command removes the default object lock configuration for 
      the ``mydata`` bucket on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc retention clear --default myminio/mydata

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] retention clear           \
                          [--default]               \
                          [--recursive]             \
                          [--rewind "string"]       \
                          [--version-id "string"]*  \
                          [--versions]              \
                          ALIAS

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

      :mc-cmd:`mc retention clear --version-id` is mutually exclusive with
      multiple other parameters. See the reference documentation for more
      information.

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS

   *Required* The full path to the object or objects for which to clear
   the object lock configuration. Specify the :mc-cmd:`alias <mc alias>` of a
   configured S3-compatible service as the prefix to the ``ALIAS`` bucket
   path. For example:

   .. code-block:: shell

      mc retention clear play/mybucket/object.txt

   - If the ``ALIAS`` specifies a bucket or bucket prefix, include
      :mc-cmd:`~mc retention clear --recursive` to clear the object lock
      settings to the bucket contents.

   - If the ``ALIAS`` bucket has versioning enabled,
      :mc-cmd:`mc retention clear` by default applies to only the latest
      object version. Use :mc-cmd:`~mc retention clear --version-id` or
      :mc-cmd:`~mc retention clear --versions` to clear the object lock
      settings for a specific version or for all versions of the object.

.. mc-cmd:: --default
   

   *Optional* Clears the default object lock settings for the bucket specified
   to :mc-cmd:`~mc retention clear ALIAS`.
   
   If specifying :mc-cmd:`~mc retention clear --default`, 
   :mc-cmd:`mc retention clear` ignores all other flags.

.. mc-cmd:: --recursive, r
   

   *Optional* Recursively clears the object lock settings for all objects in the
   specified :mc-cmd:`~mc retention clear ALIAS` path.

   Mutually exclusive with :mc-cmd:`~mc retention clear --version-id`.

.. mc-cmd:: --rewind
   

   .. include:: /includes/facts-versioning.rst
      :start-after: start-rewind-desc
      :end-before: end-rewind-desc

.. mc-cmd:: --version-id, vid
   

   .. include:: /includes/facts-versioning.rst
      :start-after: start-version-id-desc
      :end-before: end-version-id-desc

   Mutually exclusive with any of the following flags:
   
   - :mc-cmd:`~mc retention clear --versions`
   - :mc-cmd:`~mc retention clear --rewind`
   - :mc-cmd:`~mc retention clear --recursive`

.. mc-cmd:: --versions
   

   .. include:: /includes/facts-versioning.rst
      :start-after: start-versions-desc
      :end-before: end-versions-desc

   Use :mc-cmd:`~mc retention clear --versions` and
   :mc-cmd:`~mc retention clear --rewind` together to remove the
   retention settings from all object versions that existed at a
   specific point-in-time.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Clear Object Lock Settings for an Object or Object(s)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. tab-set::

   .. tab-item:: Specific Object

      .. code-block:: shell
         :class: copyable

         mc retention clear ALIAS/PATH

      - Replace :mc-cmd:`ALIAS <mc retention clear ALIAS>` with the
        :mc:`alias <mc alias>` of a configured S3-compatible host.

      - Replace :mc-cmd:`PATH <mc retention clear ALIAS>` with the path to the
        object.


   .. tab-item:: Multiple Objects

      Use :mc-cmd:`mc retention clear` with
      :mc-cmd:`~mc retention clear --recursive` to clear the retention
      settings from all objects in a bucket:

      .. code-block:: shell
         :class: copyable

         mc retention clear --recursive ALIAS/PATH

      - Replace :mc-cmd:`ALIAS <mc retention clear ALIAS>` with the
        :mc:`alias <mc alias>` of a configured S3-compatible host.

      - Replace :mc-cmd:`PATH <mc retention clear ALIAS>` with the path to the 
        bucket.


.. include:: /includes/facts-locking.rst
   :start-after: start-command-requires-locking-desc
   :end-before: end-command-requires-locking-desc

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibilit
