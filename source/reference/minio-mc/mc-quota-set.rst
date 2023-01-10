================
``mc quota set``
================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc quota set

.. versionchanged:: RELEASE.2022-12-13T00-23-28Z

   ``mc quota set`` replaced ``mc admin bucket quota --hard``.

Description
-----------

.. start-mc-quota-set-desc

The :mc-cmd:`mc quota set` assigns a hard quota limit to a bucket beyond which MinIO does not allow writes.

.. end-mc-quota-set-desc

Units of Measurement
~~~~~~~~~~~~~~~~~~~~

The :mc-cmd:`mc quota set --size` flag accepts the following **case-insensitive** suffixes to represent the unit of the specified size value:

.. list-table::
   :header-rows: 1
   :widths: 20 80
   :width: 100%

   * - Suffix
     - Unit Size

   * - ``k``
     - KB (Kilobyte, 1000 Bytes)

   * - ``m``
     - MB (Megabyte, 1000 Kilobytes)

   * - ``g``
     - GB (Gigabyte, 1000 Megabytes)

   * - ``t``
     - TB (Terabyte, 1000 Gigabytes)

   * - ``ki`` or ``kib``
     - KiB (Kibibyte, 1024 Bites)

   * - ``mi`` or ``mib``
     - MiB (Mebibyte, 1024 Kibibytes)

   * - ``gi`` or ``gib``
     - GiB (Gibibyte, 1024 Mebibytes)

   * - ``ti`` or ``tib``
     - TiB (Tebibyte, 1024 Gibibytes)

Omitting a suffix defaults to ``bytes``.

Examples
--------

Configure a Hard Quota on a Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc quota set` with the :mc-cmd:`~mc quota set --size` flag to specify a hard quota on a bucket. 
Hard quotas prevent the bucket size from growing past the specified limit.

.. code-block:: shell
   :class: copyable

   mc quota set TARGET/BUCKET --size LIMIT

- Replace ``TARGET`` with the :mc-cmd:`alias <mc alias>` of a configured MinIO deployment. 
  Replace ``BUCKET`` with the name of the bucket on which to set the hard quota.

- Replace ``LIMIT`` with the maximum size to which the bucket can grow as an integer and, as desired, a suffix. 
  For example, to set a hard limit of 10 Terabytes, specify ``10t``.

Syntax
------

:mc-cmd:`mc quota set` has the following syntax:

.. code-block:: shell
   :class: copyable

   mc quota set TARGET --size LIMIT

:mc-cmd:`mc quota set` supports the following arguments:

.. mc-cmd:: TARGET
   :required:

   The full path to the bucket for which the command creates the quota. 
   Specify the :mc-cmd:`alias <mc alias>` of the MinIO deployment as a prefix to the path. 
   For example:

   .. code-block:: shell
      :class: copyable

      mc quota set play/mybucket --size 10Gi

.. mc-cmd:: --size
   :required:

   Sets a maximum limit to the bucket storage size. 
   The MinIO server rejects any incoming ``PUT`` request whose contents would exceed the bucket's configured quota.

   For example, a hard limit of ``10G`` would prevent adding any additional objects if the bucket reaches 10 gigabytes of size.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

   
S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
