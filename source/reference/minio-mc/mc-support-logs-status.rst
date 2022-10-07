==========================
``mc support logs status``
==========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc support logs status

.. include:: /includes/common-mc-support.rst
   :start-after: start-minio-only
   :end-before: end-minio-only

Description
-----------

Use the :mc-cmd:`mc support logs status` command to output whether the specified ALIAS is set to automatically upload logs to |subnet|.

.. include:: /includes/common-mc-support.rst
   :start-after: start-support-logs-opt-in
   :end-before: end-support-logs-opt-in

Example
-------

Display Whether Logs Are Currently Uploading to SUBNET
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command outputs whether logs are currently uploading to SUBNET for the alias ``minio1``.

.. code-block:: shell
   :class: copyable

   mc support logs status minio1


Syntax
------

The command has the following syntax:

.. code-block:: shell
               
   mc [GLOBAL FLAGS] support logs enable ALIAS

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals
