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

A batch file can define any number of job tasks.
MinIO does not limit on the number of job tasks that you can define in a batch file.

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

MinIO Batch CLI
---------------

- Install the :ref:`MinIO Client <minio-client>`
- Define an :mc-cmd:`alias <mc alias set>` for the MinIO deployment

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

You can use MinIO's :ref:`Policy Based Access Control <minio-policy>` and the :ref:`administrative policy actions <minio-policy-mc-admin-actions>` to restrict who can start a batch job, retrieve a list of running jobs, or describe a running job.

Job Types
---------

``replicate``
~~~~~~~~~~~~~

The ``replicate`` job type performs a single-run replication of objects from one MinIO deployment to another.
The definition file can limit the replication by bucket, prefix, and/or filters to only replicate certain objects.

For example, you can use a batch job to perform a one-time replication sync of objects from ``minio-alpha/invoices/`` to ``minio-baker/invoices``.

The advantages of Batch Replication over :mc:`mc mirror` include:

- Removes the client to cluster network as a potential bottleneck
- A user only needs access to starting a batch job with no other permissions, as the job runs entirely server side on the cluster
- The job provides for retry attempts in event that objects do not replicate
- Batch jobs are one-time, curated processes allowing for fine control replication

Sample YAML Description File for a ``replicate`` Job Type
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Create a basic ``replicate`` job definition file you can edit with :mc-cmd:`mc batch generate`.

.. code-block:: yaml

   replicate:
     apiVersion: v1
     # source of the objects to be replicated
     source:
         type: TYPE # valid values are "s3"
   	   bucket: BUCKET
	      prefix: PREFIX
	      # NOTE: if source is remote then target must be "local"
	      # endpoint: ENDPOINT
	      # credentials:
         #   accessKey: ACCESS-KEY
         #   secretKey: SECRET-KEY
         #   sessionToken: SESSION-TOKEN # Available when rotating credentials are used

     # target where the objects must be replicated
     target:
	      type: TYPE # valid values are "s3"
	      bucket: BUCKET
	      prefix: PREFIX
	      # NOTE: if target is remote then source must be "local"
	      # endpoint: ENDPOINT
	      # credentials:
         #   accessKey: ACCESS-KEY
         #   secretKey: SECRET-KEY
         #   sessionToken: SESSION-TOKEN # Available when rotating credentials are used

     # optional flags based filtering criteria
     # for all source objects
     flags:
	      filter:
	         newerThan: "7d" # match objects newer than this value (e.g. 7d10h31s)
	         olderThan: "7d" # match objects older than this value (e.g. 7d10h31s)
	         createdAfter: "date" # match objects created after "date"
	         createdBefore: "date" # match objects created before "date"

      	   ## NOTE: tags are not supported when "source" is remote.
	         # tags:
      	   #   - key: "name"
      	   #     value: "pick*" # match objects with tag 'name', with all values starting with 'pick'

      	   ## NOTE: metadata filter not supported when "source" is non MinIO.
	         # metadata:
      	   #   - key: "content-type"
      	   #     value: "image/*" # match objects with 'content-type', with all values starting with 'image/'

	      notify:
	         endpoint: "https://notify.endpoint" # notification endpoint to receive job status events
	         token: "Bearer xxxxx" # optional authentication token for the notification endpoint

	      retry:
	         attempts: 10 # number of retries for the job before giving up
	         delay: "500ms" # least amount of delay between each retry