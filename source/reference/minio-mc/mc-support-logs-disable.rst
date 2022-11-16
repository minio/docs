===========================
``mc support logs disable``
===========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc support logs disable

.. include:: /includes/common-mc-support.rst
   :start-after: start-minio-only
   :end-before: end-minio-only

Description
-----------

Use the :mc-cmd:`mc support logs disable` command to disable the uploading of real-time MinIO logs to |subnet|.

.. include:: /includes/common-mc-support.rst
   :start-after: start-support-logs-opt-in
   :end-before: end-support-logs-opt-in
   
Example
-------

Disable Logs from Uploading to SUBNET
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command disables console logs from uploading to SUBNET for the alias ``minio1``.

.. code-block:: shell
   :class: copyable

   mc support logs disable minio1

Syntax
------

The command has the following syntax:

.. code-block:: shell
               
   mc [GLOBAL FLAGS] support logs disable ALIAS

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals
