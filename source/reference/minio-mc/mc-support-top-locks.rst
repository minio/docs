========================
``mc support top locks``
========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc support top locks

Syntax
------

.. start-mc-support-top-locks-desc

The :mc:`mc support top locks` command lists the ten oldest locks on a MinIO deployment.

.. end-mc-support-top-locks-desc

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command displays the current in-progress S3 API calls on the :term:`alias` ``myminio``.

      .. code-block:: shell
         :class: copyable

         mc support top locks myminio/

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] support top locks  \
                          [--stale]          \ 
                          TARGET

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: TARGET
   :required:

   The full path to the :ref:`alias <mc-alias-set>` or prefix where the command should run.

.. mc-cmd:: --stale
   :optional:

   Return only stale locks.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Display the 10 Oldest Locks on the ``myminio`` Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: shell
   :class: copyable

   mc support top locks myminio/

Display Stale Locks on the ``myminio`` Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command displays all in-progress ``s3.PutObject`` calls for the ``myminio`` deployment:

.. code-block:: shell
   :class: copyable

   mc support top locks --stale myminio/
