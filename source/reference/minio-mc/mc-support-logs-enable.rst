==========================
``mc support logs enable``
==========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc support logs enable

.. include:: /includes/common-mc-support.rst
   :start-after: start-minio-only
   :end-before: end-minio-only

Description
-----------

Use the :mc-cmd:`mc support logs enable` command to allow real-time MinIO logs to upload to |subnet|.

.. include:: /includes/common-mc-support.rst
   :start-after: start-support-logs-opt-in
   :end-before: end-support-logs-opt-in
   
.. admonition:: Sensitive Data
   :class: important 

   By default, MinIO does not scrub the logs uploaded to SUBNET.

   To hide sensitive information in the logs, start the server with the :mc-cmd:`~minio server --anonymous` flag.
   MinIO employs an aggressive scrubbing algorithm which may produce logs with reduced visibility into the deployment.
   MinIO Engineering may later request unredacted logs if required for ongoing support cases.

Example
-------

Enable Automatic Upload of MinIO Logs to SUBNET
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command starts sending the MinIO deployment's server logs to SUBNET for the alias ``minio1``.

.. code-block::
   :class: copyable

   mc support logs enable minio1


Syntax
------

The command has the following syntax:

.. code-block::
               
   mc [GLOBAL FLAGS] support logs enable ALIAS

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals
.. default-domain:: minio
