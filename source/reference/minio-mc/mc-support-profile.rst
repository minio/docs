======================
``mc support profile``
======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc support profile

Description
-----------

The :mc-cmd:`mc support profile` command runs a system profile for your deployment.
The results of the profile can provide insight into the MinIO server process running on a given node.

The resulting report is intended for use by MinIO Engineering.
You can upload the report to |subnet|.
Independent or third-party use of these profiles for diagnostics and remediation is done at your own risk.

.. include:: /includes/common-mc-support.rst
   :start-after: start-minio-only
   :end-before: end-minio-only

Examples
--------

Fetch CPU Profiling
~~~~~~~~~~~~~~~~~~~

This command retrieves the CPU profile on a MinIO deployment with the alias ``minio1``.
The profile runs for the default of 10 seconds.

.. code-block:: shell
   :class: copyable

   mc support profile --type cpu minio1/


Fetch CPU, Memory, and Block Profiling Concurrently
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This command fetches the profile of the CPU, memory, and block usage on the alias ``minio2``.
The profile runs for the default of 10 seconds.

.. code-block:: shell
   :class: copyable

   mc support profile --type cpu,mem,block minio2/

Fetch CPU, Memory, and Block Profiling Concurrently for 10 Minutes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This command fetches the profile of the CPU, memory, and block  on the alias ``minio3``.
The profile runs for 10 minutes (600 seconds).

.. code-block:: shell
   :class: copyable

   mc support profile --type cpu,mem,block --duration 600 minio3/

Syntax
------
      
The :mc-cmd:`mc support profile` command has the following syntax:

.. code-block:: shell

   mc [GLOBALFLAGS] support profile    \
                            COMMAND    \
                            [--type]   \
                            [--duration]
                            ALIAS 

Parameters
~~~~~~~~~~

.. mc-cmd:: --duration
   :optional:

   Run profiling for the specified duration in seconds.

   Use ``--type <value>`` where ``<value>`` is the number of seconds for the profile to run.

   If not specified, the command collects data for 10 seconds.

.. mc-cmd:: --type
   :optional:

   Specify the profile(s) to gather data for.

   Use ``--type <value>`` where ``<value>`` is one or more comma-separated types of data to collect.

   Valid types are:

   - ``cpu``
   - ``cpuio``
   - ``mem``
   - ``block``
   - ``mutex``
   - ``trace``
   - ``threads``
   - ``goroutines``
   
   If not specified, the command collects data for CPU, memory, block, mutex, threads, and goroutines.

.. mc-cmd:: ALIAS
   :required:

   The :ref:`alias <alias>` of the MinIO deployment.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals
