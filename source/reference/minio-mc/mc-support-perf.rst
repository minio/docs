===================
``mc support perf``
===================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc support perf

Description
-----------

Use the :mc:`mc support perf` command to review the performance of the S3 API (read/write), network IO, and storage (drive read/write).

The resulting tests can provide general guidance of deployment performance under S3 ``GET`` and ``PUT`` requests and identify any potential bottlenecks.

For more complete performance testing, consider using a combination of load-testing using your staging application environments and the MinIO `WARP <https://github.com/minio/warp>`_ S3 benchmarking tool.
   
:mc:`mc support perf` has three subcommands

#. :mc-cmd:`~mc support perf drive`

   Measure the speed of drives in a MinIO deployment.

#. :mc-cmd:`~mc support perf object`
      
   Measure the speed of reading and writing objects in a cluster.

#. :mc-cmd:`~mc support perf net`

   Measure the network throughput of all nodes.

.. include:: /includes/common-mc-support.rst
   :start-after: start-minio-only
   :end-before: end-minio-only

Examples
--------

Measure Speed of an Object
~~~~~~~~~~~~~~~~~~~~~~~~~~

Measure the performance of S3 read/write of an object on the alias ``minio1``.
MinIO autotunes concurrency to obtain maximum throughput and IOPS (Input/Output Per Second).

.. code-block:: shell
   :class: copyable
 
   mc support perf object minio1

Measure Speed of an Object of a Specific Size for a Specific Duration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Run object the S3 read/write performance of an object for 20 seconds with object size of 128MiB on alias ``minio1``.
MinIO autotunes concurrency to obtain maximum throughput.

.. code-block:: shell
   :class: copyable

   mc support perf object minio1 --duration 20s --size 128MiB


Test Speed of All Drives on All Nodes with Default Specifications
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Run drive read/write performance measurements on all drive on all nodes for a cluster with alias ``minio1``.
The command does not specify the blocksize, so the default of 4MiB is used.

.. code-block:: shell
   :class: copyable
 
   mc support perf drive minio1

Test Drive Speed Measurements with Custom Specifications
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Run drive read/write performance measurements on a cluster with alias ``minio1`` specificying a blocksize of 64KiB and data read/written from each drive of 2GiB.

.. code-block:: shell
   :class: copyable

   mc support perf drive minio1 --blocksize 64KiB --filesize 2GiB

Test Network Throughput
~~~~~~~~~~~~~~~~~~~~~~~

Run a network throughput test on a cluster with alias ``minio1``.

.. code-block:: shell
   :class: copyable

   mc support perf net minio1

Syntax
------

.. mc-cmd:: drive
   :fullpath:

Measure the read/write speed of the drives in a cluster.

.. code-block:: shell
               
   mc [GLOBAL FLAGS] support perf drive   \
                   [--concurrent]         \
                   [--verbose, -v]        \
                   [--filesize]           \
                   [--blocksize]          \
                   [--serial]             \
                   ALIAS

.. mc-cmd:: object
   :fullpath:

Measure the S3 peformance of reading and writing objects in a cluster.

.. code-block:: shell
               
   mc [GLOBAL FLAGS] support perf object  \
                   [--duration]           \
                   [--size]               \
                   [--concurrent]         \
                   [--verbose, -v]        \
                   ALIAS  
            
.. mc-cmd:: net
   :fullpath:

Measure the network throughput of all nodes in a cluster.

.. code-block:: shell

   mc [GLOBAL FLAGS] support perf net  \
                   [--concurrent]      \
                   [--verbose, -v]     \
                   [--serial]          \
                   ALIAS

Parameters
~~~~~~~~~~

.. mc-cmd:: --duration
   :optional:

   Applies to the :mc-cmd:`~mc support perf object` command.

   Specify the duration for the performance tests to run.

   If not specified, the default value is ``10s``.

   Use ``--duration <value>`` where ``<value>`` is a number and a unit of ``s`` for seconds, ``m`` for minutes.

.. mc-cmd:: --size
   :optional:

   Applies to the :mc-cmd:`~mc support perf object` command.

   Specify the size of the object to use for upload and download performance test.

   If not specified, the default value is ``64MiB``.

   Use ``--size <value>`` where ``<value>`` is a number and the storage unit, ``KiB``, ``MiB``, or ``GiB``.

.. mc-cmd:: --concurrent
   :optional:

   Applies to the :mc-cmd:`~mc support perf drive`, :mc-cmd:`~mc support perf object`, and :mc-cmd:`~mc support perf net` commands.

   Specify the number of concurrent requests to test per server.

   If not specified, the default value is ``32``.

   Use ``--concurrent <value>`` where ``<value>`` is a number.

.. mc-cmd:: --verbose
   :optional:
   :alias: -v

   Applies to the :mc-cmd:`~mc support perf drive`, :mc-cmd:`~mc support perf object`, and :mc-cmd:`~mc support perf net` commands.

   Show per-server stats in the output.

.. mc-cmd:: --filesize
   :optional:

   Applies to the :mc-cmd:`~mc support perf drive` command.

   Specify the total size of data to read or write to each drive.

   If not specified, the default value is ``1GiB``.

   Use ``--filesize <value>`` where ``<value>`` is a number and storage unit, ``KiB``, ``MiB``, or ``GiB``.

.. mc-cmd:: --blocksize
   :optional:

   Applies to the :mc-cmd:`~mc support perf drive` command.

   Specify the read/write block size.

   If not specified, the default value is ``4MiB``.

   Use ``--filesize <value>`` where ``<value>`` is a number and a storage unit, using standard storage unit abbreviations.

.. mc-cmd:: --serial
   :optional:

   Applies to the :mc-cmd:`~mc support perf drive` and :mc-cmd:`~mc support perf net` commands.

   Run performance tests on drive(s) one by one.

.. mc-cmd:: ALIAS
   :required:

   Applies to the :mc-cmd:`~mc support perf drive`, :mc-cmd:`~mc support perf object`, and :mc-cmd:`~mc support perf net` commands.

   The :ref:`alias <alias>` of the MinIO deployment.
       

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals
