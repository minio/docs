============
``mc ready``
============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc ready

Syntax
------

.. start-mc-ready-desc

The :mc:`mc ready` command checks the status of a cluster.

.. end-mc-ready-desc

.. tab-set::

   .. tab-item:: EXAMPLE

      The following sends a ``GET`` request to the cluster and returns its status.

      .. code-block:: shell
         :class: copyable

         mc ready play

      The command sends a ``get`` request to the deployment at the :mc:`~mc alias` ``play``.'
      The command repeats the request until it is successful.

      The output before a cluster is ready resembles the following:

      .. code-block:: shell

         The cluster is unreachable: Get "http://play.min.io:9000/minio/health/cluster": dial tcp 127.0.0.1:9000: connect: connection refused

      Once the request succeeds, the output resembles the following:
     
      .. code-block:: shell

         The cluster is ready

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] ready            \
                          TARGET           \
                          [--cluster-read] \
                          [--maintenance]

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: TARGET
   :required:

   The full path to the :ref:`alias <minio-mc-alias>` or prefix where the command should run.

.. mc-cmd:: --cluster-read
   :optional:

   Checks if the cluster has enough :term:`quorum <read quorum>` to serve ``READ`` requests.

.. mc-cmd:: --maintenance
   :optional:
   
   Checks if the cluster can maintain read and write quorum if taken down for maintenance.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Check if the cluster has read quorum
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command sends checks that a deployment has sufficient drives available for read operations.

.. code-block:: shell
   :class: copyable

   mc read myminio --cluster-read

Check if a cluster is down for maintenance
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command checks if the cluster can maintain read and write quorum during maintenance.

.. code-block:: shell
   :class: copyable

   mc ready myminio --maintenance
