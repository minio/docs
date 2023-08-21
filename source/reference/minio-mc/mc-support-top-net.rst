=======================
``mc support top net``
=======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc support top net

Syntax
------

.. start-mc-support-top-net-desc

The :mc:`mc support top net` command displays realtime network metrics.

.. end-mc-support-top-net-desc

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command displays the current realtime network metrics for the :term:`alias` ``myminio`` deployment.

      .. code-block:: shell
         :class: copyable

         mc support top net myminio/

      The output returns information such as the server URL, interface, receive, transmit, and messages.

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] support top disk                \
                                      [--interval value]  \
                                      TARGET

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: TARGET
   :required:

   The full path to the :ref:`alias <minio-mc-alias>` or :term:`prefix` where the command should run.

.. mc-cmd:: --interval
   :optional:

   The interval in seconds between metric requests.

   If no entry is made, the command requests metrics every second.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

