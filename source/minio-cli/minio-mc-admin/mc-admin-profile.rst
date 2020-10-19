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

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only

Profile Data Format
~~~~~~~~~~~~~~~~~~~

:mc-cmd:`mc admin profile` produces a ``ZIP`` archive ``profile.zip`` that
contains one or more ``.pprof`` files. Use the 
`pprof <https://github.com/google/pprof>`__ ``go`` utility to read the
profile data.

Examples
--------

Profile Data for Single Resource
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin profile start` with the
:mc-cmd-option:`~mc admin profile start type` flag to start profiling the
resource:

.. code-block:: shell
   :class: copyable

   mc admin profile start --type "TYPE" ALIAS

- Replace :mc-cmd:`ALIAS <mc admin profile start ALIAS>` with the
  :mc-cmd:`alias <mc alias>` of the MinIO host.

- Replace :mc-cmd:`TYPE <mc admin profile start type>` with the resource to
  profile.

Use :mc-cmd:`mc admin profile stop` to stop profiling data from the specified
resource and output the results:

.. code-block:: shell
   :class: copyable

   mc admin profile stop

The command outputs the profiled data as ``profile.zip``.

Profile Data for Multiple Resources
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin profile start` with the
:mc-cmd-option:`~mc admin profile start type` flag to start profiling the
resources:

.. code-block:: shell
   :class: copyable

   mc admin profile start --type "TYPE,[TYPE...]" ALIAS

- Replace :mc-cmd:`ALIAS <mc admin profile start ALIAS>` with the
  :mc-cmd:`alias <mc alias>` of the MinIO host.

- Replace :mc-cmd:`TYPE <mc admin profile start type>` with the resources to
  profile. Specify multiple resources as a comma-separated list.

Use :mc-cmd:`mc admin profile stop` to stop profiling data from the specified
resources and output the results:

.. code-block:: shell
   :class: copyable

   mc admin profile stop

The command outputs the profiled data as ``profile.zip``.

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



