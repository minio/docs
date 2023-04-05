.. _minio-mc-replicate-status:

=======================
``mc replicate status``
=======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc replicate status

Syntax
------

.. start-mc-replicate-status-desc

The :mc:`mc replicate status` command displays the :ref:`replication status <minio-bucket-replication-serverside>` of a MinIO bucket.
The status also lists the remote target path or location.

.. end-mc-replicate-status-desc

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command displays the current replication status of the
      ``mydata`` bucket on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc replicate status myminio/mydata

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] replicate status TARGET
                                    [--limit-upload value]
                                    [--limit-download value]

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :ref:`alias <alias>` of the MinIO deployment and full path to the bucket or bucket prefix for which to display the replication status. 
   For example:

   .. code-block:: none

      mc replicate status myminio/mybucket

.. mc-cmd:: --limit-download
   :optional:

   Limit download rates to no more than a specified rate in KiB/s, MiB/s, or GiB/s.
   Valid units include: 
   
   - ``B`` for bytes
   - ``K`` for kilobytes
   - ``G`` for gigabytes
   - ``T`` for terabytes
   - ``Ki`` for kibibytes
   - ``Gi`` for gibibytes
   - ``Ti`` for tebibytes

   For example, to limit download rates to no more than 1 GiB/s, use the following:

   .. code-block::

      --limit-download 1G

   If not specified, MinIO uses an unlimited download rate.

.. mc-cmd:: --limit-upload
   :optional:

   Limit upload rates to no more than the specified rate in KiB/s, MiB/s, or GiB/s.
   Valid units include: 
   
   - ``B`` for bytes
   - ``K`` for kilobytes
   - ``G`` for gigabytes
   - ``T`` for terabytes
   - ``Ki`` for kibibytes
   - ``Gi`` for gibibytes
   - ``Ti`` for tebibytes

   For example, to limit upload rates to no more than 1 GiB/s, use the following:

   .. code-block::

      --limit-upload 1G

   If not specified, MinIO uses an unlimited upload rate.


Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Display Replication Status
~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc:`mc replicate status` to show bucket replication status:

.. code-block:: shell
   :class: copyable

   mc replicate status ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc replicate status ALIAS>` with the :mc:`alias <mc alias>` of the MinIO deployment.

- Replace :mc-cmd:`PATH <mc replicate status ALIAS>` with the path to the bucket or bucket prefix.

Behavior
--------

Removed and Re-added ARNs
~~~~~~~~~~~~~~~~~~~~~~~~~

.. versionchanged:: mc RELEASE.2023-03-20T17-17-53Z

The standard output of this command does not display ARNs previously removed from a replication configuration.

To list all ARNs, including ARNs no longer part of the replication, use the ``--json`` flag.
The ``json`` output continues to show data replicated under old ARNs.
This may be valuable if an ARN was removed and re-added for the same bucket.

New ARNs do **not** cause re-replication of previously synced objects.