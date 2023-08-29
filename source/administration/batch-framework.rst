.. _minio-batch-framework:

===============
Batch Framework
===============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. versionadded:: MinIO RELEASE.2022-10-08T20-11-00Z

   The Batch Framework was introduced with the ``replicate`` job type in the :mc:`mc` RELEASES.2022-10-08T20-11-00Z.

Overview
--------

The MinIO Batch Framework allows you to create, manage, monitor, and execute jobs using a YAML-formatted job definition file (a "batch file").
The batch jobs run directly on the MinIO deployment to take advantage of the server-side processing power without constraints of the local machine where you run the :ref:`MinIO Client <minio-client>`.

A batch file defines one job task.

Once started, MinIO starts processing the job.
Time to completion depends on the resources available to the deployment.

If any portion of the job fails, MinIO retries the job up to the number of times defined in the job definition.

The MinIO Batch Framework supports the following job types:

.. list-table:: 
   :header-rows: 1
   :widths: 30 70
   :width: 100%   

   * - Job Type
     - Description

   * - ``replicate``
     - Perform a one-time replication procedure from one MinIO location to another MinIO location.

   * - ``keyrotate``
     - Perform a one-time process to cycle the :ref:`sse-s3 or sse-kms <minio-sse-data-encryption>` cryptographic keys on objects.

MinIO Batch CLI
---------------

- Install the :ref:`MinIO Client <minio-client>`
- Define an :mc:`alias <mc alias set>` for the MinIO deployment

The :mc:`mc batch` commands include

.. list-table::
   :widths: 30 70
   :width: 90%

   * - :mc:`mc batch generate`
     - .. include:: /reference/minio-mc/mc-batch-generate.rst
          :start-after: start-mc-batch-generate-desc
          :end-before: end-mc-batch-generate-desc
   * - :mc:`mc batch start`
     - .. include:: /reference/minio-mc/mc-batch-start.rst
          :start-after: start-mc-batch-start-desc
          :end-before: end-mc-batch-start-desc
   * - :mc:`mc batch list`
     - .. include:: /reference/minio-mc/mc-batch-list.rst
          :start-after: start-mc-batch-list-desc
          :end-before: end-mc-batch-list-desc
   * - :mc:`mc batch status`
     - .. include:: /reference/minio-mc/mc-batch-status.rst
          :start-after: start-mc-batch-status-desc
          :end-before: end-mc-batch-status-desc
   * - :mc:`mc batch describe`
     - .. include:: /reference/minio-mc/mc-batch-describe.rst
          :start-after: start-mc-batch-describe-desc
          :end-before: end-mc-batch-describe-desc

Access to ``mc batch``
----------------------

A user's access keys and policies do not restrict the the buckets, prefixes, or objects the batch function can access or the types of actions the process can perform on any objects.

For some job types, the credentials passed to the batch job through the YAML file do restrict the objects that the job can access.
However, any restrictions to the job are from the credentials in the YAML, not policies attached to the user who starts the job.

Use MinIO's :ref:`Policy Based Access Control <minio-policy>` and the :ref:`administrative policy actions <minio-policy-mc-admin-actions>` to restrict who can perform various batch job functions.
MinIO provides the following admin policy actions for Batch Jobs:

``admin:ListBatchJobs``
  Grants the user the ability to see batch jobs currently in process.

``admin:DescribeBatchJobs``
  Grants the user the ability to see the definition details of batch job currently in process.

``admin:StartBatchJob``
  Grants the user the ability to start a batch job.
  The job may be further restricted by the credentials the job uses to access either the source or target deployments.

``admin:CancelBatchJob``
  Allows the user to stop a batch job currently in progress.

You can assign any of these actions to users independently or in any combination.

The built-in ``ConsoleAdmin`` policy includes sufficient access to perform all of these types of batch job actions.

Job Types
---------

.. note:: 

   Depending on the job type, the success or failure of any batch job may be impacted by the credentials given in the batch job's YAML for the source or target deployments.

.. _minio-batch-local:

``Local`` Deployment
~~~~~~~~~~~~~~~~~~~~

You run a batch job against a particular deployment by passing an ``alias`` to the :mc:`mc batch` command.
The deployment you specify in the command becomes the ``local`` deployment within the context of that batch job.

Replicate
~~~~~~~~~

Use the ``replicate`` job type to create a batch job that replicates objects from one MinIO deployment (the ``source`` deployment) to another MinIO deployment (the ``target`` deployment).
Either the ``source`` or the ``target`` **must** be the :ref:`local <minio-batch-local>` deployment.
Starting with the MinIO Server ``RELEASE.2023-05-04T21-44-30Z``, the other deployment can be either another MinIO deployment or any S3-compatible location.

The batch job definition file can limit the replication by bucket, prefix, and/or filters to only replicate certain objects.
The access to objects and buckets for the replicate process may be restricted by the credentials you provide in the YAML for either the source or target destinations. 

.. versionchanged:: MinIO Server RELEASE.2023-04-07T05-28-58Z

   You can replicate from a remote MinIO deployment to the local deployment that runs the batch job.

For example, you can use a batch job to perform a one-time replication sync to push objects from a bucket on a local deployment at ``minio-local/invoices/`` to a bucket on a remote deployment at ``minio-remote/invoices``.
You can also pull objects from the remote deployment at ``minio-remote/invoices`` to the local deployment at ``minio-local/invoices``.

The advantages of Batch Replication over :mc:`mc mirror` include:

- Removes the client to cluster network as a potential bottleneck
- A user only needs access to starting a batch job with no other permissions, as the job runs entirely server side on the cluster
- The job provides for retry attempts in event that objects do not replicate
- Batch jobs are one-time, curated processes allowing for fine control replication
- (MinIO to MinIO only) The replication process copies object versions from source to target

.. versionchanged:: MinIO Server RELEASE.2023-02-17T17-52-43Z

   Run batch replication with multiple workers in parallel by specifying the :envvar:`MINIO_BATCH_REPLICATION_WORKERS` environment variable.

Sample YAML Description File for a ``replicate`` Job Type
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Create a basic ``replicate`` job definition file you can edit with :mc:`mc batch generate`.

For the :ref:`local <minio-batch-local>` deployment, do not specify the endpoint or credentials.
Either delete or comment out those lines for the source or the target section, depending on which is the ``local``.

.. literalinclude:: /includes/code/replicate.yaml
   :language: yaml

Key Rotate
~~~~~~~~~~

.. versionadded:: MinIO RELEASE.2023-04-07T05-28-58Z

Use the ``keyrotate`` job type to create a batch job that cycles the :ref:`sse-s3 or sse-kms keys <minio-sse-data-encryption>` for encrypted objects.

The YAML configuration supports filters to restrict key rotation to  a specific set of objects by creation date, tags, metadata, or kms key.
You can also define retry attempts or set a notification endpoint and token.

Sample YAML Description File for a ``keyrotate`` Job Type
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Create a basic ``keyrotate`` job definition file you can edit with :mc:`mc batch generate`.

.. literalinclude:: /includes/code/keyrotate.yaml
   :language: yaml
