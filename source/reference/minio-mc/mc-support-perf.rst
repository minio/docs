===================
``mc support perf``
===================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc support perf

.. versionchanged:: RELEASE.2022-07-24T02-25-13Z

   ``mc support perf`` replaces the ``mc admin speedtest`` command.

.. include:: /includes/common-mc-support.rst
   :start-after: start-minio-only
   :end-before: end-minio-only

Description
-----------

.. start-mc-support-perf-desc

Use the :mc:`mc support perf` command to review the performance of the S3 API (read/write), network IO, and storage (drive read/write).

.. end-mc-support-perf-desc

The resulting tests can provide general guidance of deployment performance under S3 ``GET`` and ``PUT`` requests and identify any potential bottlenecks.

.. admonition:: Other S3 API calls suspended during testing
   :class: note

   For S3 testing, :mc:`mc support perf` temporarily suspends S3 API calls during a test.
   They are automatically restarted after the test is complete or if the command is cancelled.

For more complete performance testing, consider using a combination of load-testing using your staging application environments and the MinIO `WARP <https://github.com/minio/warp>`_ S3 benchmarking tool.


:mc:`mc support perf` has the following subcommands

#. :mc-cmd:`~mc support perf drive`

   Measure the speed of drives in a MinIO deployment.

#. :mc-cmd:`~mc support perf object`
      
   Measure the speed of reading and writing objects in a cluster.

#. :mc-cmd:`~mc support perf net`

   Measure the network throughput of all nodes.

#. :mc-cmd:`~mc support perf client`

   Measure the network throughput to a client.

#. :mc-cmd:`~mc support perf site-replication`
 
   Measure the speed of site replication operations.

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

Run drive read/write performance measurements on a cluster with alias ``minio1`` specifying a blocksize of 64KiB and data read/written from each drive of 2GiB.

.. code-block:: shell
   :class: copyable

   mc support perf drive minio1 --blocksize 64KiB --filesize 2GiB

Test Network Throughput
~~~~~~~~~~~~~~~~~~~~~~~

Run a network throughput test on a cluster with alias ``minio1``.

.. code-block:: shell
   :class: copyable

   mc support perf net minio1

Test Site Replication Speed
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Run a test on the speed of site replication operations from the ``minio1`` site to other configured peers.

.. code-block:: shell
   :class: copyable

   mc support perf site-replication minio1

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
                      [--airgap]             \
                      ALIAS

.. mc-cmd:: object
   :fullpath:

   Measure the S3 performance of reading and writing objects in a cluster.

   .. code-block:: shell
               
      mc [GLOBAL FLAGS] support perf object  \
                      [--size]               \
                      [--concurrent]         \
                      [--verbose, -v]        \
                      [--airgap]             \
                      ALIAS  
            
.. mc-cmd:: net
   :fullpath:

   Measure the network throughput of all nodes in a cluster.

   .. code-block:: shell

      mc [GLOBAL FLAGS] support perf net  \
                      [--concurrent]      \
                      [--verbose, -v]     \
                      [--serial]          \
                      [--airgap]          \
                      ALIAS

.. mc-cmd:: client
   :fullpath:

   Measure the network throughput from the local device running the MinIO Client to the server.

   .. code-block:: shell

      mc [GLOBAL FLAGS] support perf client  \
                      --duration             \
                      [--verbose, -v]        \
                      [--airgap]             \
                      ALIAS

.. mc-cmd:: site-replication
   :fullpath:

   Measure the speed of site replication operations from the specified ``ALIAS`` to other configured peers.

   .. code-block:: shell

      mc [GLOBAL FLAGS] support perf site-replication \
                        --duration                    \
                        [--verbose, -v]               \
                        ALIAS


Parameters
~~~~~~~~~~

.. mc-cmd:: --airgap
   :optional:

   Use in environments without network access to SUBNET (for example, airgapped, firewalled, or similar configuration).

   If the deployment is airgapped, but the local device where you are using the :ref:`minio client <minio-client>` has network access, you do not need to use the ``--airgap`` flag.

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

   Applies to the :mc-cmd:`~mc support perf drive`, :mc-cmd:`~mc support perf object`, :mc-cmd:`~mc support perf net`, and :mc-cmd:`~mc support perf client` commands.

   The :ref:`alias <alias>` of the MinIO deployment.

.. mc-cmd:: --duration
   :required:

   Applies to the :mc-cmd:`~mc support perf client` command.

   Length of time in seconds to perform the test.
   Time cannot be `0` or negative.
       

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals
