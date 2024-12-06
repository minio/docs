==================
``mc support top``
==================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc support top

.. note::

   .. versionchanged:: RELEASE.2022-08-11T00-30-48Z

   ``mc support top`` replaces the ``mc admin top`` command.

.. include:: /includes/common-mc-support.rst
   :start-after: start-minio-only
   :end-before: end-minio-only

Description
-----------

.. start-mc-support-top-desc

The :mc:`mc support top` command returns statistics for distributed
MinIO deployments, similar to the output of the ``top`` command in a shell. 

.. end-mc-support-top-desc

.. note::

   :mc:`mc support top` is not supported on single-node single-drive MinIO deployments.

:mc-cmd:`mc support top` has the following subcommands:

- :mc-cmd:`~mc support top api`
- :mc-cmd:`~mc support top locks`
- :mc-cmd:`~mc support top disk`
- :mc-cmd:`~mc support top net`
- :mc-cmd:`~mc support top rpc`

Refer to the pages linked above for each subcommand for details.

Syntax
------

The command has the following syntax:

.. code-block:: shell

   mc support top COMMAND [COMMAND FLAGS] [ARGUMENTS ...]

.. toctree::
   :titlesonly:
   :hidden:
   
   /reference/minio-mc/mc-support-top-api
   /reference/minio-mc/mc-support-top-locks
   /reference/minio-mc/mc-support-top-disk
   /reference/minio-mc/mc-support-top-net
   /reference/minio-mc/mc-support-top-rpc