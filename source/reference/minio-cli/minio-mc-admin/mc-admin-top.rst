================
``mc admin top``
================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin top

Description
-----------

.. start-mc-admin-top-desc

The :mc-cmd:`mc admin top` command returns statistics for distributed
MinIO deployments, similar to the output of the ``top`` command. 

:mc-cmd:`mc admin top` is not supported on standalone MinIO deployments
or MinIO Gateway deployments.

.. end-mc-admin-top-desc

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only

Syntax
------

.. mc-cmd:: locks
   :fullpath:

   Returns the 10 oldest locks on the MinIO deployment.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc admin top locks TARGET

   The command supports the following arguments:

   .. mc-cmd:: TARGET

      The :mc-cmd:`alias <mc alias>` of a configured MinIO deployment from which
      the command retrieves statistics.

      The alias *must* correspond to a distributed (multi-node) MinIO deployment.
      The command returns an error for standalone MinIO deployments or MinIO
      Gateway deployments.


