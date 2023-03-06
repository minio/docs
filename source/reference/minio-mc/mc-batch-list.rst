.. _minio-mc-batch-list:

=================
``mc batch list``
=================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc batch list

.. versionchanged:: MinIO RELEASE.2022-10-08T20-11-00Z or later

Syntax
------

.. start-mc-batch-list-desc

The :mc:`mc batch list` command outputs a list of the batch jobs currently in progress on a deployment.

.. end-mc-batch-list-desc


.. tab-set::

   .. tab-item:: EXAMPLE

      The following command outputs a list of all jobs currently in progress on the ``myminio`` alias.

      .. code-block:: shell
         :class: copyable

         mc batch list myminio

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] batch list TARGET           \
                                     --type "string"

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: TARGET
   :required:
   
   The :ref:`alias <alias>` of the deployment for which you want to list jobs in progress. 
   
.. mc-cmd:: --type
   :optional:

   List batch jobs only of a certain type.
   
Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Example
-------

List all ``replicate`` type batch jobs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command lists the ``replicate``` type job(s) on the deployment at :mc:`alias <mc alias>` ``myminio``:

.. code-block:: shell
   :class: copyable

   mc batch list myminio --type "replicate"

- Replace ``myminio`` with the :mc:`alias <mc alias>` of the MinIO deployment that should run the job.

- Replace ``replicate`` with the job type to output.
  
  Currently, :mc:`mc batch` only supports the ``replicate`` job type.

The output of the above command is similar to the following:

.. code-block:: shell

   ID                      TYPE            USER            STARTED
   E24HH4nNMcgY5taynaPfxu  replicate       minioadmin      1 minute ago
 
S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility

Permissions
-----------

You must have the :policy-action:`admin:ListBatchJobs` permission to list jobs on the deployment. 
