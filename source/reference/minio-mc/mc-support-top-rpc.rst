=======================
``mc support top rpc``
=======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc support top rpc

.. include:: /includes/common-mc-support.rst
   :start-after: start-minio-only
   :end-before: end-minio-only

Syntax
------

.. start-mc-support-top-rpc-desc

The :mc:`mc support top rpc` command displays metrics for remote procedure calls (RPC).

.. end-mc-support-top-rpc-desc

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command displays the current remote procedure call metrics for the :term:`alias` ``myminio`` deployment.

      .. code-block:: shell
         :class: copyable

         mc support top rpc myminio/

      The output returns information such as the server, number of connections, length of ping, time since last ping (``pong``), reconnections, string in, string out, messages in, and messages out.

      The output resembles

      .. code-block:: bash

         λ mc support top rpc myminio
               SERVER            CONCTD  PING     PONG   OUT.Q   RECONNS STR.IN  STR.OUT MSG.IN  MSG.OUT
          To  127.0.0.1:9002       5     0.7ms   1s ago    0        0     ->0      0->    3269    3212
         From 127.0.0.1:9002       5     1.1ms   1s ago    0        0     ->0      0->    3213    3269
          To  127.0.0.1:9003       5     0.6ms   1s ago    0        0     ->0      0->    6001    6076
         From 127.0.0.1:9003       5     0.6ms   1s ago    0        0     ->0      0->    6077    6001
          To  127.0.0.1:9004       5     0.6ms   1s ago    0        0     ->0      0->    3243    3160
         From 127.0.0.1:9004       5     0.4ms   1s ago    0        0     ->0      0->    3161    3243
          To  127.0.0.1:9005       5     0.6ms   1s ago    0        0     ->0      0->    3150    3094
         From 127.0.0.1:9005       5     0.3ms   1s ago    0        0     ->0      0->    3095    3150
          To  127.0.0.1:9006       5     0.3ms   1s ago    0        0     ->0      0->    3185    3221
         From 127.0.0.1:9006       5     0.6ms   1s ago    0        0     ->0      0->    3222    3185

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell 
         :class: copyable

         mc [GLOBALFLAGS] support top rpc                 \
                                      [--airgap]          \
                                      [--in value]        \
                                      [--interval value]  \
                                      [-n value]          \
                                      [--nodes value]     \
                                      TARGET

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: TARGET
   :required:

   The full path to the :ref:`alias <minio-mc-alias>` or :term:`prefix` where the command should run.

.. mc-cmd:: --airgap
   :optional:

   Use in environments without network access to SUBNET.

.. mc-cmd:: --in
   :optional:

   Replay a previously saved JSON file.
   Specify the path to the JSON file to replay.

.. mc-cmd:: --interval
   :optional:

   The interval in seconds between metric requests.

   By default, the command requests metrics every second.

.. mc-cmd:: -n
   :optional:

   The number of requests to run before existing.
   Use ``0`` for endless.

   If not specified, the command does not automatically exit.

.. mc-cmd:: --nodes
   :optional:

   Comma-separated list of the node or nodes from which to collect metrics.


Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

