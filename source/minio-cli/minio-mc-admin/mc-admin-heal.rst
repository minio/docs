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

The :mc:`mc admin heal` command scans for objects that are damaged or
corrupted and heals those objects.  

.. end-mc-admin-heal-desc

:mc:`mc admin heal` is resource intensive and typically not required even
after disk failures or corruption events. Instead, MinIO automatically heals
objects damaged by silent bitrot corruption, disk failure, or other issues on
POST/GET. MinIO also performs periodic background object healing.

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only

Syntax
------

:mc:`mc admin heal` has the following syntax:

.. code-block:: shell
   :class: copyable

   mc admin heal [FLAGS] TARGET

:mc:`mc admin heal` supports the following arguments:

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

.. mc-cmd:: scan
   :option:

   The type of scan to perform. Specify one of the following supported scan
   modes:

   - ``normal`` (default)
   - ``deep``

.. mc-cmd:: recursive, r
   :option:

   Recursively scans for objects in the specified bucket or bucket prefix.

.. mc-cmd:: dry-run
   :option:

   Inspects the :mc-cmd:`~mc admin heal TARGET` bucket or bucket prefix, 
   but does *not* perform any object healing.

.. mc-cmd:: force-start, f
   :option:

   Force starts the healing process.

.. mc-cmd:: force-stop, s
   :option:

   Force stops the healing sequence.

.. mc-cmd:: remove
   :option:

   Removes dangling objects in the healing process. 
