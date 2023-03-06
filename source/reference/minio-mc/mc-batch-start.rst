.. _minio-mc-batch-start:

==================
``mc batch start``
==================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc batch start

.. versionchanged:: MinIO RELEASE.2022-10-08T20-11-00Z or later

Syntax
------

.. start-mc-batch-start-desc

The :mc:`mc batch start` command launches a batch job from a job batch YAML file.

.. end-mc-batch-start-desc

The batch job runs to completion (or up to the number of retries specified in the file) one time.
To run the batch job again after completion, you must start it again.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command creates a basic YAML file for a replicate job on the ``mybucket`` bucket of the ``myminio`` alias.

      .. code-block:: shell
         :class: copyable

         mc batch start myminio/mybucket jobfile.yaml

      The output of the above command is something similar to:

      .. code-block:: shell
         
         Successfully start 'replicate' job `B34HHqnNMcg1taynaPfxu` on '2022-10-24 17:19:06.296974771 -0700 PDT'

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] batch start    \
                                TARGET   \
                                JOBFILE

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: TARGET
   :required:
   
   The :ref:`alias <alias>` on which to start the batch job.
   
   For example:

   .. code-block:: none

      mc batch start myminio replicate.yaml

.. mc-cmd:: JOBFILE
   :required:
   
   A YAML-defined batch job.
   The job may have as many tasks as desired; there is no predefined limit.
   
Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Example
-------

Start a Batch Job
~~~~~~~~~~~~~~~~~

The following command starts the batch of job(s) defined in the file ``replication.yaml`` on the deployment at :mc:`alias <mc alias>` ``myminio``:

.. code-block:: shell
   :class: copyable

   mc batch start myminio ./replication.yaml

- Replace ``myminio`` with the :mc:`alias <mc alias>` of the MinIO deployment that should run the job.

- Replace ``./replication.yaml`` with the yaml-formatted file that describes the batch job.
  Use the file path relative to your current location. 

The output of the above command is similar to the following:

.. code-block:: shell
   
   Successfully start 'replicate' job `E24HH4nNMcgY5taynaPfxu` on '2022-09-26 17:19:06.296974771 -0700 PDT'
 
S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility


Permissions
-----------

You must have the :policy-action:`admin:StartBatchJob` permission on the deployment to start jobs. 
