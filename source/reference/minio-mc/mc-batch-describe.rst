.. _minio-mc-batch-describe:

=====================
``mc batch describe``
=====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc batch describe

.. versionchanged:: MinIO RELEASE.2022-10-08T20-11-00Z or later

Syntax
------

.. start-mc-batch-describe-desc

The :mc:`mc batch describe` command outputs the job definition for a specified job ID.

.. end-mc-batch-describe-desc

You must specify the job ID.
To find the job ID, use :mc-cmd:`mc batch list`.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command outputs the job definition for the job identified as ``KwSysDpxcBU9FNhGkn2dCf``.

      .. code-block:: shell
         :class: copyable

         mc batch describe myminio KwSysDpxcBU9FNhGkn2dCf

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] batch describe TARGET           \
                                         JOBID

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: TARGET
   :required:
   
   The :ref:`alias <alias>` for the MinIO deployment to look for the Job ID. 

.. mc-cmd:: JOBID
   :required:

   The unique identifier of a job to describe.
   To find the ID of a job, use :mc:`mc batch list`.
   
Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Example
-------

Show the Definition of an In Progress Batch Job
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command provides the full job definition of a specific job at :mc:`alias <mc alias>` ``myminio``:

.. code-block:: shell
   :class: copyable

   mc batch describe myminio KwSysDpxcBU9FNhGkn2dCf

- Replace ``myminio`` with the :mc:`alias <mc alias>` of the MinIO deployment that should run the job.
- Replace ``KwSysDpxcBU9FNhGkn2dCf`` with the ID of the job to define.

The output of the above command is similar to the following:

.. code-block:: shell

   mc batch describe myminio KwSysDpxcBU9FNhGkn2dCf
   replicate:
     apiVersion: v1
   ...
 
Note, this example is truncated.
The output is the full job definition for the specified job.

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility

Permissions
-----------

You must have the :policy:`admin:DescribeBatchJobs` permission to describe jobs on the deployment. 
