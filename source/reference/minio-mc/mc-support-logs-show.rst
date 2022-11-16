========================
``mc support logs show``
========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc support logs show

.. include:: /includes/common-mc-support.rst
   :start-after: start-minio-only
   :end-before: end-minio-only

Description
-----------

Use the :mc-cmd:`mc support logs show` command to display MinIO server logs.
   
Examples
--------

Show Logs for the Alias ``minio1``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command shows logs for the alias ``minio1``.

.. code-block:: shell
   :class: copyable

   mc support logs show minio1

Show Last Five Log Entries for a Specific Node
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command shows the last five log entries on the node ``node1`` for a MinIO server with the alias ``minio1``.

.. code-block:: shell
   :class: copyable

   mc support logs show --last 5 minio1 node1

Show Application Log Entries
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command shows the application logs for a MinIO server with the alias ``minio1``.

.. include:: /includes/common-mc-support.rst
   :start-after: start-support-logs-opt-in
   :end-before: end-support-logs-opt-in

.. code-block:: shell
   :class: copyable

   mc support logs show --type application minio1

Syntax
------
      
The command has the following syntax:

.. code-block:: shell

   mc [GLOBALFLAGS] support logs show      \
                                 [--last]  \
                                 [--type]  \
                                 ALIAS

Parameters
~~~~~~~~~~

.. mc-cmd:: --last
   :optional:

   Show the most recent log entries to a specified number.
   Takes an integer value.

   If not specified, the command shows the last 10 log entries.
   
.. mc-cmd:: --type
   :optional:

   List error logs by type.

   Valid types:
   
   - ``application``
   - ``minio``
   - ``all``

   Defaults to ``all``.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals
