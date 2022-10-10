==================
``mc admin trace``
==================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin trace

Description
-----------

.. start-mc-admin-trace-desc

The :mc-cmd:`mc admin trace` command displays API operations occurring on the target MinIO deployment.

.. end-mc-admin-trace-desc

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only

Example
-------

Use :mc-cmd:`mc admin trace` to monitor API operations on a MinIO deployment:

.. code-block:: shell
   :class: copyable

   mc admin trace ALIAS

- Replace :mc-cmd:`ALIAS <mc admin trace TARGET>` with the 
  :mc-cmd:`alias <mc alias>` of the MinIO deployment.

Syntax
------

:mc-cmd:`mc admin trace` has the following syntax:

.. code-block:: shell
   :class: copyable

   mc admin trace [FLAGS] TARGET

:mc-cmd:`mc admin trace` supports the following argument:

.. mc-cmd:: TARGET

   Specify the :mc:`alias <mc alias>` of a configured MinIO deployment for which to monitor API operations.

.. mc-cmd:: --all, a
   

   Returns all traffic on the MinIO deployment, including internode traffic
   between MinIO servers.

.. mc-cmd:: --verbose
   

   Returns verbose output.

.. mc-cmd:: --errors, e
   

   Returns failed API operations only.
