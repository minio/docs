.. _minio-mc-batch-cancel:

===================
``mc batch cancel``
===================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc batch cancel

.. versionadded:: mc RELEASE.2023-03-20T17-17-53Z

Syntax
------

.. start-mc-batch-cancel-desc

The :mc:`mc batch cancel` stops an ongoing batch job.

.. end-mc-batch-cancel-desc

You must specify the job ID.
To find the job ID, use :mc-cmd:`mc batch list`.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command outputs the job definition for the job identified as ``KwSysDpxcBU9FNhGkn2dCf``.

      .. code-block:: shell
         :class: copyable

         mc batch cancel myminio KwSysDpxcBU9FNhGkn2dCf

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] batch cancel ALIAS JOBID

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:
   
   The :ref:`alias <alias>` for the MinIO deployment on which the job is currently running. 

.. mc-cmd:: JOBID
   :required:

   The unique identifier of the batch job to cancel.
   To find the ID of a job, use :mc:`mc batch list`.
   
Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Example
-------

Cancel an ongoing batch job
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following command cancels the job with ID ``KwSysDpxcBU9FNhGkn2dCf`` on the deployment at alias ``myminio``:

.. code-block:: shell
   :class: copyable

   mc batch cancel myminio KwSysDpxcBU9FNhGkn2dCf

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
