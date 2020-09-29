==================================
``mc admin bucket quota``
==================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin bucket quota

Description
-----------

.. start-mc-admin-bucket-quota-desc

The :mc-cmd:`mc admin bucket quota` command manages per-bucket
storage quotas.

.. end-mc-admin-bucket-quota-desc

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only

.. _mc-admin-bucket-quota-units:

Units of Measurement
~~~~~~~~~~~~~~~~~~~~

The :mc-cmd-option:`mc admin bucket quota hard` and 
:mc-cmd-option:`mc admin bucket quota fifo` flags
accept the following case-insensitive suffixes to represent the unit of the
specified size value:

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
     - TB (Terrabyte, 1000 Gigabytes)

   * - ``ki``
     - KiB (Kibibyte, 1024 Bites)

   * - ``mi``
     - MiB (Mebibyte, 1024 Kibibytes)

   * - ``gi``
     - GiB (Gibibyte, 1024 Mebibytes)

   * - ``ti``
     - TiB (Tebibyte, 1024 Gibibytes)

Omitting the suffix defaults to ``bytes``.


Quick Reference
---------------

:mc-cmd:`mc admin bucket quota play/mybucket --hard 10GB <mc admin bucket quota hard>`
   Adds a hard quota of ``10GB`` to the ``mybucket`` bucket on the
   MinIO deployment with the ``play`` :mc-cmd:`alias <mc alias>`. MinIO
   rejects any ``PUT`` request that would result in the bucket exceeding
   the configured quota.

:mc-cmd:`mc admin bucket quota play/mybucket --fifo 10GB <mc admin bucket quota fifo>`
   Adds a hard quota of ``10GB`` to the ``mybucket`` bucket on the
   MinIO deployment with the ``play`` :mc-cmd:`alias <mc alias>`. MinIO
   removes the oldest objects on the bucket until it can satisfy the size
   of an incoming ``PUT`` request.

:mc-cmd:`mc admin bucket quota play/mybucket --clear <mc admin bucket quota clear>`
   Removes all quotas from the ``mybucket`` bucket on the MinIO deployment
   with the ``play`` :mc-cmd:`alias <mc alias>`.

Syntax
------

:mc-cmd:`mc admin bucket quota` has the following syntax:

.. code-block:: shell
   :class: copyable

   mc admin bucket quota TARGET [FLAGS] [ARGUMENTS]

:mc-cmd:`mc admin bucket quota` supports the following arguments:

.. mc-cmd:: TARGET

   The full path to the bucket for which the command creates the quota. 
   Specify the :mc-cmd:`alias <mc alias>` of the MinIO deployment as a 
   prefix to the path. For example:

   .. code-block:: shell
      :class: copyable

      mc admin bucket quota play/mybucket

.. mc-cmd:: hard
   :option:

   Sets a maximum limit to the bucket storage size. The MinIO server rejects any
   incoming ``PUT`` request whose contents would exceed the bucket's configured
   quota.

   For example, a hard limit of ``10GB`` would prevent adding any additional
   objects if the bucket reaches ``10GB`` of size.

   See :ref:`mc-admin-bucket-quota-units` for supported unit sizes.

.. mc-cmd:: fifo
   :option:

   Sets a limit to the bucket storage size after which MinIO removes the oldest
   objects in the bucket until the bucket size drops below the specified limit.

   For example, a ``fifo`` limit of ``10GB`` would result in removal of the
   oldest objects in the bucket once it reaches ``10GB`` in size. 

   See :ref:`mc-admin-bucket-quota-units` for supported unit sizes.

.. mc-cmd:: clear
   :option:

   Clears all quotas configured for the bucket. 

   

