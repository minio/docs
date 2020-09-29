====================
``mc admin profile``
====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin profile

Description
-----------

.. start-mc-admin-profile-desc

The :mc-cmd:`mc admin profile` command generates profiling data for debugging
purposes.

.. end-mc-admin-profile-desc

:mc-cmd:`mc admin profile` produces a ``ZIP`` archive ``profile.zip`` that
contains one or more ``.pprof`` files. Use the 
`pprof <https://github.com/google/pprof>`__ ``go`` utility to read the
profile data.

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only

Quick Reference
---------------

:mc-cmd:`mc admin profile start --type cpu myminio/ <mc admin profile start>`
   Starts profiling data related to ``cpu`` statistics
   on the ``myminio`` :mc-cmd:`alias <mc alias>`.

:mc-cmd:`mc admin profile start --type "cpu,mem,block" myminio/ <mc admin profile start>`
   Starts profiling data related to ``cpu``, ``mem``, and ``block`` statistics
   on the ``myminio`` :mc-cmd:`alias <mc alias>`.

:mc-cmd:`mc admin profile stop myminio/ <mc admin profile stop>`
   Stops profiling data on the ``myminio`` :mc-cmd:`alias <mc alias>` and
   dumps the recorded data to ``profile.zip``.

Syntax
------

:mc-cmd:`mc admin profile` has the following syntax:

.. code-block:: shell
   :class: copyable

   mc admin profile SUBCOMMAND

:mc-cmd:`mc admin profile` supports the following subcommands:

.. mc-cmd:: start
   :fullpath:

   Starts collecting profiling data on the target MinIO deployment. The
   command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc admin profile start [FLAGS] TARGET

   :mc-cmd:`mc admin profile start` supports the following arguments:

   .. mc-cmd:: TARGET

      The :mc-cmd:`alias <mc alias>` of a configured MinIO deployment from
      which the command collects profiling data.

   .. mc-cmd:: type
      :option:

      The type(s) of profiling data to collect from the 
      :mc-cmd:`~mc admin profile start TARGET` MinIO deployment.

      Specify one or more of the following supported types as a comma-separated
      list:

      - ``cpu``
      - ``mem``
      - ``block``
      - ``mutex``
      - ``trace``
      - ``threads``
      - ``goroutines``

      Defaults to ``cpu,mem,block`` if omitted. 

.. mc-cmd:: stop
   :fullpath:

   Stops the profiling process and returns the collected data as 
   ``profile.zip``. The ``zip`` file contains one or more 
   ``.pprof`` files which are readable with programs like the ``go``
   `pprof <https://github.com/google/pprof>`__ utility.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc admin profile stop TARGET

   The command supports the following arguments:

   .. mc-cmd:: TARGET

      The :mc-cmd:`alias <mc alias>` of a configured MinIO deployment from
      which the command returns available profiling data. 



