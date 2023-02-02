=====================
``mc retention info``
=====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc retention info

.. |command| replace:: :mc:`mc retention info`
.. |rewind| replace:: :mc-cmd:`~mc retention info --rewind`
.. |versionid| replace:: :mc-cmd:`~mc retention info --version-id`
.. |alias| replace:: :mc-cmd:`~mc retention info ALIAS`
.. |versions| replace:: :mc-cmd:`~mc retention info --versions`

Syntax
------

.. start-mc-retention-info-desc

The :mc:`mc retention info` command configures the :ref:`Write-Once Read-Many (WORM)
locking <minio-object-locking>` settings for an object or object(s) in a bucket.
You can also set the default object lock settings for a bucket, where all
objects without explicit object lock settings inherit the bucket default.

.. end-mc-retention-info-desc

To lock an object under :ref:`legal hold <minio-object-locking-legalhold>`, 
use :mc:`mc legalhold set`.

:mc:`mc retention info` *requires* that the specified bucket has object locking
enabled. You can **only** enable object locking at bucket creation. See
:mc-cmd:`mc mb --with-lock` for documentation on creating buckets with
object locking enabled. 

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command returns the default object lock configuration for 
      the ``mydata`` bucket on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc retention info --default myminio/mydata

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] retention info            \
                          [--default]               \
                          [--recursive]             \
                          [--rewind "string"]       \
                          [--version-id "string"]*  \
                          [--versions]              \
                          ALIAS

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

      :mc-cmd:`mc retention info --version-id` is mutually exclusive with
      multiple other parameters. See the reference documentation for more
      information.

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS

   *Required* 
   
   The full path to the object for which to retrieve
   the object lock configuration. Specify the :ref:`alias <alias>` of a
   configured S3-compatible service as the prefix to the ``ALIAS`` bucket
   path. For example:

   .. code-block:: shell

      mc retention info play/mybucket/object.txt

   - If the ``ALIAS`` specifies a bucket or bucket prefix, include 
      :mc-cmd:`~mc retention info --recursive` to return the object
      lock settings for all objects in the bucket or bucket prefix.

   - If the ``ALIAS`` bucket has versioning enabled, 
      :mc:`mc retention info` by default applies to only the latest object
      version. Use :mc-cmd:`~mc retention info --version-id` or
      :mc-cmd:`~mc retention info --versions` to return the object lock
      settings for a specific version or for all versions of the object.


.. mc-cmd:: --default
   

   *Optional* Returns the default object lock settings for the bucket specified
   to :mc-cmd:`~mc retention info ALIAS`.

   If specifying :mc-cmd:`~mc retention info --default`, 
   :mc:`mc retention info` ignores all other flags.

.. mc-cmd:: --recursive, r
   

   *Optional* Recursively returns the object lock settings for all objects in the
   specified :mc-cmd:`~mc retention info ALIAS` path.

   Mutually exclusive with :mc-cmd:`~mc retention info --version-id`.

.. mc-cmd:: --rewind
   

   .. include:: /includes/facts-versioning.rst
      :start-after: start-rewind-desc
      :end-before: end-rewind-desc

.. mc-cmd:: --version-id, vid
   

   .. include:: /includes/facts-versioning.rst
      :start-after: start-version-id-desc
      :end-before: end-version-id-desc

   Mutually exclusive with any of the following flags:
   
   - :mc-cmd:`~mc retention info --versions`
   - :mc-cmd:`~mc retention info --rewind`
   - :mc-cmd:`~mc retention info --recursive`

.. mc-cmd:: --versions
   

   .. include:: /includes/facts-versioning.rst
      :start-after: start-versions-desc
      :end-before: end-versions-desc

   Use :mc-cmd:`~mc retention info --versions` and
   :mc-cmd:`~mc retention info --rewind` together to retrieve the
   retention settings for all object versions that existed at a
   specific point-in-time.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Retrieve Object Lock Settings for an Object or Object(s)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. tab-set::

   .. tab-item:: Specific Object

      .. code-block:: shell
         :class: copyable

         mc retention info ALIAS/PATH

      - Replace :mc-cmd:`ALIAS <mc retention info ALIAS>` with the
        :mc:`alias <mc alias>` of a configured S3-compatible host.

      - Replace :mc-cmd:`PATH <mc retention info ALIAS>` with the path to the
        object.

   .. tab-item:: Multiple Objects

      Use :mc:`mc retention info` with
      :mc-cmd:`~mc retention info --recursive` to retrieve the retention
      settings for all objects in a bucket:

      .. code-block:: shell
         :class: copyable

         mc retention info --recursive ALIAS/PATH

      - Replace :mc-cmd:`ALIAS <mc retention info ALIAS>` with the
        :mc:`alias <mc alias>` of a configured S3-compatible host.

      - Replace :mc-cmd:`PATH <mc retention info ALIAS>` with the path to the 
        bucket.

.. include:: /includes/facts-locking.rst
   :start-after: start-command-requires-locking-desc
   :end-before: end-command-requires-locking-desc

Retrieve Default Object Lock Settings for a Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc retention info` with 
:mc-cmd:`~mc retention info --default` to retrieve the default 
object lock settings for a bucket:

.. code-block:: shell
   :class: copyable

   mc retention info --default ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc retention info ALIAS>` with the
   :mc:`alias <mc alias>` of a configured S3-compatible host.

- Replace :mc-cmd:`PATH <mc retention info ALIAS>` with the path to the
  bucket.

.. include:: /includes/facts-locking.rst
   :start-after: start-command-requires-locking-desc
   :end-before: end-command-requires-locking-desc

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
