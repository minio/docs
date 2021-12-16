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

The :mc:`mc replicate status` command displays the 
:ref:`replication status <minio-bucket-replication-serverside>` of a
MinIO bucket.

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

         mc [GLOBALFLAGS] replicate status ALIAS

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS

   *Required* the :ref:`alias <alias>` of the MinIO deployment and full path to
   the bucket or bucket prefix for which to display the replication status. For
   example:

   .. code-block:: none

      mc replicate status myminio/mybucket

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Display Replication Status
~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc replicate status` to show bucket replication status:

.. code-block:: shell
   :class: copyable

   mc replicate status ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc replicate status ALIAS>` with the 
  :mc:`alias <mc alias>` of the MinIO deployment.

- Replace :mc-cmd:`PATH <mc replicate status ALIAS>` with the path to the 
  bucket or bucket prefix.
