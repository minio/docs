.. _minio-batch-framework-replicate-job:

=================
Batch Replication
=================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. versionadded:: MinIO RELEASE.2022-10-08T20-11-00Z

   The Batch Framework was introduced with the ``replicate`` job type in the :mc:`mc` :mc-release:`RELEASE.2022-10-08T20-11-00Z`.

The MinIO Batch Framework allows you to create, manage, monitor, and execute jobs using a YAML-formatted job definition file (a "batch file").
The batch jobs run directly on the MinIO deployment to take advantage of the server-side processing power without constraints of the local machine where you run the :ref:`MinIO Client <minio-client>`.

The ``replicate`` batch job replicates objects from one MinIO deployment (the ``source`` deployment) to another MinIO deployment (the ``target`` deployment).
Either the ``source`` or the ``target`` **must** be the :ref:`local <minio-batch-local>` deployment.

Batch Replication between MinIO deployments have the following advantages over using :mc:`mc mirror`:

- Removes the client to cluster network as a potential bottleneck
- A user only needs access to starting a batch job with no other permissions, as the job runs entirely server side on the cluster
- The job provides for retry attempts in event that objects do not replicate
- Batch jobs are one-time, curated processes allowing for fine control replication
- (MinIO to MinIO only) The replication process copies object versions from source to target

.. versionchanged:: MinIO Server RELEASE.2023-02-17T17-52-43Z

   Run batch replication with multiple workers in parallel by specifying the :envvar:`MINIO_BATCH_REPLICATION_WORKERS` environment variable.

Starting with the MinIO Server ``RELEASE.2023-05-04T21-44-30Z``, the other deployment can be either another MinIO deployment or any S3-compatible location using a realtime storage class.
Use filtering options in the replication ``YAML`` file to exclude objects stored in locations that require rehydration or other restoration methods before serving the requested object.
Batch replication to these types of remotes uses ``mc mirror`` behavior.

Behavior
--------

Access Control and Requirements
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Batch replication shares similar access and permission requirements as :ref:`bucket replication <minio-bucket-replication-requirements>`.

The credentials for the "source" deployment must have a policy similar to the following:

.. literalinclude:: /extra/examples/ReplicationAdminPolicy.json
   :class: copyable
   :language: json

The credentials for the "remote" deployment must have a policy similar to the following:

.. literalinclude:: /extra/examples/ReplicationRemoteUserPolicy.json
   :class: copyable
   :language: json


See :mc:`mc admin user`, :mc:`mc admin user svcacct`, and :mc:`mc admin policy` for more complete documentation on adding users, access keys, and policies to a MinIO deployment.

MinIO deployments configured for :ref:`Active Directory/LDAP <minio-external-identity-management-ad-ldap>` or :ref:`OpenID Connect <minio-external-identity-management-openid>` user management can instead create dedicated :ref:`access keys <minio-idp-service-account>` for supporting batch replication.

Filter Replication Targets
~~~~~~~~~~~~~~~~~~~~~~~~~~

The batch job definition file can limit the replication by bucket, prefix, and/or filters to only replicate certain objects.
The access to objects and buckets for the replication process may be restricted by the credentials you provide in the YAML for either the source or target destinations. 

.. versionchanged:: MinIO Server RELEASE.2023-04-07T05-28-58Z

   You can replicate from a remote MinIO deployment to the local deployment that runs the batch job.

For example, you can use a batch job to perform a one-time replication sync to push objects from a bucket on a local deployment at ``minio-local/invoices/`` to a bucket on a remote deployment at ``minio-remote/invoices``.
You can also pull objects from the remote deployment at ``minio-remote/invoices`` to the local deployment at ``minio-local/invoices``.

Batch Compression
~~~~~~~~~~~~~~~~~

Starting with :minio-release:`RELEASE.2023-12-09T18-17-51Z`, batch replication by default uses a compress-and-send methodology similar in function to S3 Snowball Edge batch migration.
MinIO automatically batches and compresses objects smaller than 5MiB to efficiently transfer data between the source and remote.
The remote MinIO deployment can check and immediately apply lifecycle management tiering rules to batched objects.
You can modify the compression settings in the :ref:`replicate <minio-batch-job-types>` job configuration.

.. _minio-batch-framework-replicate-job-ref:

Replicate Batch Job Reference
-----------------------------

The YAML **must** define the source and target deployments.
If the *source* deployment is remote, then the *target* deployment **must** be ``local``.
Optionally, the YAML can also define flags to filter which objects replicate, send notifications for the job, or define retry attempts for the job.

.. versionchanged:: MinIO RELEASE.2023-04-07T05-28-58Z

   You can replicate from a remote MinIO deployment to the local deployment that runs the batch job.

For the **source deployment**

- Required information

  .. list-table::
     :widths: 25 75
     :width: 100%

     * - ``type:``
       - Must be ``minio``.
     * - ``bucket:`` 
       - The bucket on the deployment.

- Optional information

  .. list-table::
     :widths: 25 75
     :width: 100%

     * - ``prefix:`` 
       - The prefix on the object(s) that should replicate.

     * - ``endpoint:`` 
       - | Location of the deployment to use for either the source or the target of a replication batch job. 
         | For example, ``https://minio.example.net``. 
         |
         | If the deployment is the :ref:`alias` specified to the command, omit this field to direct MinIO to use that alias for the endpoint and credentials values. 
         | Either the source deployment *or* the remote deployment *must* be the :ref:`"local" <minio-batch-local>` alias.
         | The non-"local" deployment must specify the ``endpoint`` and ``credentials``.

     * - ``path:``
       - | Directs MinIO to use Path or Virtual Style (DNS) lookup of the bucket.
         | 
         | - Specify ``on`` for Path style
         | - Specify ``off`` for Virtual style
         | - Specify ``auto`` to let MinIO determine the correct lookup style.
         |
         | Defaults to ``auto``.

     * - ``credentials:`` 
       - | The ``accesskey:`` and ``secretKey:`` or the ``sessionToken:`` that grants access to the object(s).
         | Only specify for the deployment that is not the :ref:`local <minio-batch-local>` deployment. 

     * - ``snowball``
       - | *version added*: RELEASE.2023-12-09T18-17-51Z
         |    
         | Configuration options for controlling the batch-and-compress functionality.

     * - ``snowball.disable``
       - | Specify ``true`` to disable the batch-and-compress functionality during replication.
         | Defaults to ``false``.

     * - ``snowball.batch``
       - | Specify the maximum integer number of objects to batch for compression.
         | Defaults to ``100``.

     * - ``snowball.inmemory``
       - | Specify ``false`` to stage archives using local storage or ``true`` to stage to memory (RAM).
         | Defaults to ``true``.

     * - ``snowball.compress``
       - | Specify ``true`` to generate archives using the `S2/Snappy compression algorithm <https://en.wikipedia.org/wiki/Snappy_(compression)>`__.
         | Defaults to ``false`` or no compression.

     * - ``snowball.smallerThan``
       - | Specify the size of object in Megabits (MiB) under which MinIO should batch objects.
         | Defaults to ``5MiB``.

     * - ``snowball.skipErrs``
       - | Specify ``false`` to direct MinIO to halt on any object which produces errors on read.
         | Defaults to ``true``.

For the **target deployment**

- Required information

  .. list-table::
     :widths: 25 75
     :width: 100%

     * - ``type:`` 
       - Must be ``minio``.
     * - ``bucket:`` 
       - The bucket on the deployment.

- Optional information

  .. list-table::
     :widths: 25 75
     :width: 100%
  
     * - ``prefix:`` 
       - The prefix on the object(s) to replicate.

     * - ``endpoint:`` 
       - | The location of the target deployment.
         |
         | If the target is the :ref:`alias <alias>` specified to the command, you can omit this and the ``credentials`` fields.
         | If the target is "local", the source *must* specify the remote deployment with ``endpoint`` and ``credentials``.


     * - ``credentials:`` 
       - The ``accesskey`` and ``secretKey`` or the ``sessionToken`` that grants access to the object(s).
    
For **filters**

.. list-table::
   :widths: 25 75
   :width: 100%

   * - ``newerThan:`` 
     - A string representing a length of time in ``#d#h#s`` format.
       
       Only objects newer than the specified length of time replicate.
       For example, ``7d``, ``24h``, ``5d12h30s`` are valid strings.
   * - ``olderThan:`` 
     - A string representing a length of time in ``#d#h#s`` format.
       
       Only objects older than the specified length of time replicate.
   * - ``createdAfter:`` 
     - A date in ``YYYY-MM-DD`` format.
  
       Only objects created after the date replicate.
   * - ``createdBefore:`` 
     - A date in ``YYYY-MM-DD`` format.
       
       Only objects created prior to the date replicate.

For **notifications**

.. list-table::
   :widths: 25 75
   :width: 100%

   * - ``endpoint:`` 
     - The predefined endpoint to send events for notifications.
   * - ``token:`` 
     - An optional :abbr:`JWT <JSON Web Token>` to access the ``endpoint``.

For **retry attempts**

If something interrupts the job, you can define how many attempts to retry the job batch.
For each retry, you can also define how long to wait between attempts.

.. list-table::
   :widths: 25 75
   :width: 100%

   * - ``attempts:`` 
     - Number of tries to complete the batch job before giving up.
   * - ``delay:`` 
     - The least amount of time to wait between each attempt.

Sample YAML Description File for a ``replicate`` Job Type
---------------------------------------------------------

Use :mc:`mc batch generate` to create a basic ``replicate`` batch job for further customization.

For the :ref:`local <minio-batch-local>` deployment, do not specify the endpoint or credentials.
Either delete or comment out those lines for the source or the target section, depending on which is the ``local``.

.. literalinclude:: /includes/code/replicate.yaml
   :language: yaml

