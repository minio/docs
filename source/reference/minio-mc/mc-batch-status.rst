.. _minio-mc-batch-status:

===================
``mc batch status``
===================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc batch status

.. versionchanged:: MinIO RELEASE.2022-10-08T20-11-00Z or later

Syntax
------

.. start-mc-batch-status-desc

The :mc:`mc batch status` command outputs real-time summaries of job events on a MinIO server.

.. end-mc-batch-status-desc


.. tab-set::

   .. tab-item:: EXAMPLE

      The following command outputs a list of all jobs currently in progress on the ``myminio`` alias.

      .. code-block:: shell
         :class: copyable

         mc batch status myminio KwSysDpxcBU9FNhGkn2dCf

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] batch list TARGET           \
                                     JOBID

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: TARGET
   :required:
   
   The :ref:`alias <alias>` and bucket on the MinIO deployment to which to add the object lifecycle management rule. 

.. mc-cmd:: JOBID
   :optional:

   The unique identifier of a job to summarize.
   To find the ID of a job, use :mc:`mc batch list`.
   
Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Example
-------

Summary the Events of a Replicate Job
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command provides the real-time summary of an active job on the deployment at :mc:`alias <mc alias>` ``myminio``:

.. code-block:: shell
   :class: copyable

   mc batch status myminio KwSysDpxcBU9FNhGkn2dCf

- Replace ``myminio`` with the :mc:`alias <mc alias>` of the MinIO deployment that should run the job.

The output of the above command is similar to the following:

.. code-block:: shell

   ●∙∙
   Objects:        28766
   Versions:       28766
   Throughput:     3.0 MiB/s
   Transferred:    406 MiB
   Elapsed:        2m14.227222868s
   CurrObjName:    share/doc/xml-core/examples/foo.xmlcatalogs
 
S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
