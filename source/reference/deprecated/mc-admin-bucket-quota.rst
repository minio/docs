=========================
``mc admin bucket quota``
=========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin bucket quota

.. versionchanged:: RELEASE.2022-12-13T00-23-28Z

   ``mc admin bucket quota`` replaced by :mc-cmd:`mc quota set`, :mc-cmd:`mc quota info`, and :mc-cmd:`mc quota clear`.

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

The :mc-cmd:`mc admin bucket quota --hard` flag
accepts the following case-insensitive suffixes to represent the unit of the
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

Examples
--------

Configure a Hard Quota on a Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin bucket quota` with the
:mc-cmd:`~mc admin bucket quota --hard` flag to specify a hard quota 
on a bucket. Hard quotas prevent the bucket size from growing past the specified
limit.

.. code-block:: shell
   :class: copyable

   mc admin bucket quota TARGET/BUCKET --hard LIMIT

- Replace ``TARGET`` with the :mc-cmd:`alias <mc alias>` of a configured 
  MinIO deployment. Replace ``BUCKET`` with the name of the bucket on which to
  set the hard quota.

- Replace ``LIMIT`` with the maximum size to which the bucket can grow. 
  For example, to set a hard limit of 10 Terrabytes, specify ``10t``.
  See :ref:`mc-admin-bucket-quota-units` for supported units.

Retrieve Bucket Quota Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin bucket quota` to retrieve the current quota configuration
for a bucket:

.. code-block:: shell
   :class: copyable

   mc admin bucket quota TARGET/BUCKET

Replace ``TARGET`` with the :mc-cmd:`alias <mc alias>` of a configured 
MinIO deployment. Replace ``BUCKET`` with the name of the bucket on which to
retrieve the quota.

Clear Configured Bucket Quota
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin bucket quota` with the
:mc-cmd:`~mc admin bucket quota --clear` flag to clear all quotas from
a bucket.

.. code-block:: shell
   :class: copyable

   mc admin bucket quota TARGET/BUCKET --clear

- Replace ``TARGET`` with the :mc-cmd:`alias <mc alias>` of a configured 
  MinIO deployment. Replace ``BUCKET`` with the name of the bucket on which to
  clear the quota.

Syntax
------

:mc-cmd:`mc admin bucket quota` has the following syntax:

.. code-block:: shell
   :class: copyable

   mc admin bucket quota TARGET [ARGUMENTS]

:mc-cmd:`mc admin bucket quota` supports the following arguments:

.. mc-cmd:: TARGET

   The full path to the bucket for which the command creates the quota. 
   Specify the :mc-cmd:`alias <mc alias>` of the MinIO deployment as a 
   prefix to the path. For example:

   .. code-block:: shell
      :class: copyable

      mc admin bucket quota play/mybucket

   Omit all other arguments to return the current quota settings for the
   specified bucket.

.. mc-cmd:: --hard
   

   Sets a maximum limit to the bucket storage size. The MinIO server rejects any
   incoming ``PUT`` request whose contents would exceed the bucket's configured
   quota.

   For example, a hard limit of ``10GB`` would prevent adding any additional
   objects if the bucket reaches ``10GB`` of size.

   See :ref:`mc-admin-bucket-quota-units` for supported unit sizes.

.. mc-cmd:: --clear
   

   Clears all quotas configured for the bucket. 

   

