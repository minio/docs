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

The :mc:`mc ready` command checks the status of a cluster and whether the cluster has ``read`` and ``write`` quorum.

.. end-mc-ready-desc

.. tab-set::

   .. tab-item:: EXAMPLE

      The following sends a ``GET`` request to the cluster at alias ``myminio`` and returns its status.

      .. code-block:: shell
         :class: copyable

         mc ready myminio

      The command sends a ``GET`` request to the deployment at the :mc:`~mc alias` ``myminio``.'
      The command repeats the request until it is successful.

      The output before the cluster at alias ``myminio`` is ready resembles the following:

      .. code-block:: text

         The cluster is `myminio` is unreachable: Get "http://myminio.example.com:9000/minio/health/cluster": dial tcp 198.51.100.0:9000: connect: connection refused

      Once the request succeeds in connecting to the ``myminio`` deployment, the output resembles the following:
     
      .. code-block:: text

         The cluster `myminio` is ready

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
   
   Checks if the cluster can maintain read and write quorum if the node for the alias is taken down for maintenance.

   Use an alias for the specific node you expect to take down for maintenance and not an alias set to a load balancer.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Check if the cluster has read quorum
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command checks that a deployment has sufficient drives available for read operations.

.. code-block:: shell
   :class: copyable

   mc read myminio --cluster-read

Check if a cluster is down for maintenance
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command checks whether the cluster can maintain read and write quorum during maintenance when the node at alias ``myminio`` is taken down.

.. code-block:: shell
   :class: copyable

   mc ready myminio --maintenance
