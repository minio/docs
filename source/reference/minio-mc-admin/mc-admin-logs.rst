=================
``mc admin logs``
=================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc support logs show
.. mc:: mc admin logs

.. include:: /includes/common-mc-support.rst
   :start-after: start-minio-only
   :end-before: end-minio-only

.. versionchanged:: RELEASE.2022-12-02T23-48-47Z

   ``mc support logs`` moved to ``mc admin logs`` and provide a simpler command interface for displaying server logs for the MinIO deployment.

   The output is similar to what is available via ``journalctl -uf minio`` for systemd-controlled deployments.

Description
-----------

.. start-mc-admin-logs-desc

Use the :mc-cmd:`mc admin logs` command to show MinIO server logs.

.. end-mc-admin-logs-desc

To enable or disable the sending of logs to SUBNET for support, use :mc:`mc support callhome`.

.. include:: /includes/common-mc-support.rst
   :start-after: start-support-logs-opt-in
   :end-before: end-support-logs-opt-in

Examples
--------

Show Logs for a Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command displays the most recent ten server logs of any type for the alias ``minio1``.

.. code-block:: shell
   :class: copyable

   mc admin logs minio1

Show Last 5 Log Entries for a Node
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command shows the most recent five log entries for a ``node1`` on the deployment with alias ``minio1``.

.. code-block:: shell
   :class: copyable

   mc admin logs --last 5 myminio node1

Show Application Type Log Entires for a Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command shows log entries of the type ``application`` for all nodes on the deployment with alias ``minio1``.

.. code-block:: shell
   :class: copyable

   mc admin logs --type application minio1

Syntax
------

The command has the following syntax:

.. code-block:: shell
               
   mc admin logs [GLOBAL FLAGS]     \
                 [--last, -l value] \
                 [--type, -t value] \
                 ALIAS              \
                 [NODE]

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :ref:`alias <alias>` of the MinIO deployment.
   
.. mc-cmd:: --last, -l
   :optional:

   Show only the most recent specified number of log entries.

   If this flag is not included, up to the last 10 log entries show.

.. mc-cmd:: --type, --type
   :optional:

   List log entries of a specified type.
   Valid types are ``minio``, ``application``, or ``all``.

   If not specified, all log entry types show.

.. mc-cmd:: NODE
   :optional:

   In distributed deployments, specify which node's logs to show by entering the node's name.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals
