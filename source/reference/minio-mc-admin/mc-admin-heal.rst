=================
``mc admin heal``
=================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin heal

Description
-----------

.. start-mc-admin-heal-desc

The :mc-cmd:`mc admin heal` command scans for objects that are damaged or
corrupted and heals those objects.  

.. end-mc-admin-heal-desc

:mc-cmd:`mc admin heal` is resource intensive and typically not required even
after drive failures or corruption events. Instead, MinIO automatically heals
objects damaged by silent bit rot corruption, drive failure, or other issues on
POST/GET. MinIO also performs periodic background object healing.

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only

Syntax
------

:mc-cmd:`mc admin heal` has the following syntax:

.. code-block:: shell
   :class: copyable

   mc admin heal [FLAGS] TARGET

:mc-cmd:`mc admin heal` supports the following arguments:

.. mc-cmd:: TARGET

   *Required*

   The full path to the bucket or bucket prefix on which the command should
   perform object healing. Specify the :mc-cmd:`alias <mc alias>` of a
   configured MinIO deployment as the prefix for the path. For example:

   .. code-block:: shell
      :class: copyable

      mc admin heal play/mybucket/myprefix

   If the ``TARGET`` bucket or bucket prefix has an active healing scan,
   the command returns the status of that scan.

.. mc-cmd:: --scan
   

   The type of scan to perform. Specify one of the following supported scan
   modes:

   - ``normal`` (default)
   - ``deep``

.. mc-cmd:: --recursive, r
   

   Recursively scans for objects in the specified bucket or bucket prefix.

.. mc-cmd:: --dry-run
   

   Inspects the :mc-cmd:`~mc admin heal TARGET` bucket or bucket prefix, 
   but does *not* perform any object healing.

.. mc-cmd:: --force-start, f
   

   Force starts the healing process.

.. mc-cmd:: --force-stop, s
   

   Force stops the healing sequence.

.. mc-cmd:: --remove
   

   Removes dangling objects and data directories in the healing process not referenced by the metadata on a per-drive basis.
