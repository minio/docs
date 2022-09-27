======================
``mc support top api``
======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc support top api

Syntax
------

.. start-mc-support-top-api-desc

The :mc:`mc support top api` command summarizes the real-time API events on a MinIO deployment server.

.. end-mc-support-top-api-desc

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command udisplays the current in-progress S3 API calls on the :term:`alias` ``myminio``.

      .. code-block:: shell
         :class: copyable

         mc support top api myminio/

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] support top api    \
                          TARGET             \
                          [--name "string"]  \
                          [--path "string"]  \
                          [--node "string"]  \
                          [--errors, -e]

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: TARGET
   :required:

   The full path to the alias, prefix, or object where the command should run.
   The path must include at least an :ref:`ALIAS <mc-alias-set>`.

.. mc-cmd:: --name
   :optional:

   Outputs a summary of current API calls matching the entered string.


.. mc-cmd:: --path
   :optional:

   Outputs a summary of current API calls for a specified path.

.. mc-cmd:: --node
   :optional:

   Outputs a summary of the current API calls on matching servers.

.. mc-cmd:: --errors, -e
   :optional:

   Outputs a summary of current API calls returning errors.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Display All Current In-progress S3 API Calls
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command displays all in-progress S3 calls for the ``myminio`` deployment:

.. code-block:: shell
   :class: copyable

   mc support top api myminio/

Display Current, In-progress ``s3.PutObject`` Calls
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command displays all in-progress ``s3.PutObject`` calls for the ``myminio`` deployment:

.. code-block:: shell
   :class: copyable

   mc support top api --name s3.PutObject myminio/
