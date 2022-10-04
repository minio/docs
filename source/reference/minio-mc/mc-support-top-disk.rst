=======================
``mc support top disk``
=======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc support top disk

Syntax
------

.. start-mc-support-top-disk-desc

The :mc:`mc support top disk` command displays current disk statistics.

.. end-mc-support-top-disk-desc

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command udisplays the current in-progress S3 API calls on the :term:`alias` ``myminio``.

      .. code-block:: shell
         :class: copyable

         mc support top disk myminio/

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] support top disk                     \
                                      [--count, -c "integer"]  \
                                      TARGET

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: TARGET
   :required:

   The full path to the :ref:`alias <mc-alias-set>` or :term:`prefix` where the command should run.

.. mc-cmd:: --count, -c
   :optional:

   Display statistics for up to the entered number of disks.

   If no entry is made, the command returns statistics for up to 10 disks.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals
