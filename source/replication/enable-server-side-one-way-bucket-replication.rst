.. _minio-bucket-replication-serverside-oneway:

=============================================
Enable One-Way Server-Side Bucket Replication
=============================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1


The procedure on this page creates a new bucket replication rule for one-way synchronization of objects between MinIO buckets.

.. image:: /images/replication/active-passive-oneway-replication.svg
   :width: 450px
   :alt: Active-Passive Replication synchronizes data from a source MinIO cluster to a remote MinIO cluster.
   :align: center

- To configure replication between arbitrary S3-compatible services, use :mc-cmd:`mc mirror`.

- To configure two-way "active-active" replication between MinIO clusters, see :ref:`minio-bucket-replication-serverside-twoway`.

- To configure multi-site "active-active" replication between MinIO clusters, see :ref:`minio-bucket-replication-serverside-multi`

.. seealso::

   - Use the :mc-cmd:`mc replicate edit` command to modify an existing replication rule.

   - Use the :mc-cmd:`mc replicate edit` command with the :mc-cmd:`--state "disable" <mc replicate edit --state>` flag to disable an existing replication rule.

   - Use the :mc-cmd:`mc replicate rm` command to remove an existing replication rule.

.. _minio-bucket-replication-serverside-oneway-requirements:

Requirements
------------

.. _minio-bucket-replication-serverside-oneway-permissions:

Required Permissions
~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common-replication.rst
   :start-after: start-replication-required-permissions
   :end-before: end-replication-required-permissions

Replication Requires Matching Object Encryption Settings
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common-replication.rst
   :start-after: start-replication-encrypted-objects
   :end-before: end-replication-encrypted-objects

Replication Requires MinIO Deployments
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common-replication.rst
   :start-after: start-replication-minio-only
   :end-before: end-replication-minio-only

Replication Requires Versioning
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common-replication.rst
   :start-after: start-replication-requires-versioning
   :end-before: end-replication-requires-versioning

Replication Requires Matching Object Locking State
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common-replication.rst
   :start-after: start-replication-requires-object-locking
   :end-before: end-replication-requires-object-locking

Considerations
--------------

Replication of Existing Objects
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports automatically replicating existing objects in a bucket.

MinIO requires explicitly enabling replication of existing objects using the :mc-cmd:`mc replicate add --replicate` or :mc-cmd:`mc replicate edit --replicate` and including the ``existing-objects`` replication feature flag. This procedure includes the required flags for enabling replication of existing objects.

Replication of Delete Operations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports replicating S3 ``DELETE`` operations onto the target bucket. Specifically, MinIO can replicate versioning :s3-docs:`Delete Markers <versioning-workflows.html>` and the deletion of specific versioned objects:

- For delete operations on an object, MinIO replication also creates the delete marker on the target bucket.

- For delete operations on versions of an object, MinIO replication also deletes those versions on the target bucket.

MinIO requires explicitly enabling replication of delete operations using the :mc-cmd:`mc replicate add --replicate` or :mc-cmd:`mc replicate edit --replicate`. This procedure includes the required flags for enabling replication of delete operations and delete markers.

MinIO does *not* replicate delete operations resulting from the application of :ref:`lifecycle management expiration rules <minio-lifecycle-management-expiration>`.

See :ref:`minio-replication-behavior-delete` for more complete documentation.

Multi-Site Replication
~~~~~~~~~~~~~~~~~~~~~~

MinIO supports configuring multiple remote targets per bucket or bucket prefix. For example, you can configure a bucket to replicate data to two or more remote MinIO deployments, where one deployment is a 1:1 copy (replication of all operations including deletions) and another is a full historical record (replication of only non-destructive write operations).

This procedure documents one-way replication to a single remote MinIO deployment. You can repeat this tutorial for multiple remote targets for a single bucket.

Procedure
---------

This procedure uses the :ref:`aliases <alias>` ``SOURCE`` and ``REMOTE`` to reference each MinIO deployment being configured for replication. Replace these values with the appropriate alias for your target MinIO deployments.

This procedure assumes each alias corresponds to a user with the :ref:`necessary replication permissions <minio-bucket-replication-serverside-oneway-permissions>`.

1) Create the Replication Remote Target
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc admin bucket remote add` command to create a replication target for the destination cluster. MinIO supports *one* remote target per destination bucket. You cannot create multiple remote targets for the same destination bucket.

.. code-block:: shell
   :class: copyable

   mc admin bucket remote add SOURCE/BUCKET \
      https://ReplicationRemoteUser:LongRandomSecretKey@HOSTNAME/BUCKET \
      --service "replication"
      [--sync]

- Replace ``BUCKET`` with the name of the bucket on the ``SOURCE`` deployment to use as the replication source. Replace ``SOURCE`` with the :ref:`alias <alias>` of the MinIO deployment on which you are configuring replication.

- Replace ``HOSTNAME`` with the URL of the ``REMOTE`` cluster.

- Replace ``BUCKET`` with the name of the bucket on the ``REMOTE`` deployment to use as the replication destination.

- Include the :mc-cmd:`~mc admin bucket remote add --sync` option to enable synchronous replication. Omit the option to use the default of asynchronous replication.  See the reference documentation for :mc-cmd:`mc admin bucket remote add` for more information on synchronous vs asynchronous replication before using this parameter.

The command returns an ARN similar to the following:

.. code-block:: shell

   Role ARN = 'arn:minio:replication::<UUID>:BUCKET'

Copy the ARN string for use in the next step.

2) Create a New Bucket Replication Rule
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc replicate add` command to add the new server-side
replication rule to the source MinIO cluster. 

.. code-block:: shell
   :class: copyable

   mc replicate add SOURCE/BUCKET \
      --remote-bucket 'arn:minio:replication::<UUID>:BUCKET' \
      --replicate "delete,delete-marker,existing-objects"

- Replace ``BUCKET`` with the name of the bucket on the ``SOURCE`` deployment to use as the replication source. Replace ``SOURCE`` with the :ref:`alias <alias>` of the MinIO deployment on which you are configuring replication. The name *must* match the bucket specified when creating the remote target in the previous step.

- Replace the ``--remote-bucket`` value with the ARN returned in the previous step. Ensure you specify the ARN created on the ``SOURCE`` deployment. You can use :mc-cmd:`mc admin bucket remote ls` to list all remote ARNs configured on the deployment.

- The ``--replicate "delete,delete-marker,existing-objects"`` flag enables the following replication features:
  
  - :ref:`Replication of Deletes <minio-replication-behavior-delete>` 
  - :ref:`Replication of existing Objects <minio-replication-behavior-existing-objects>`
  
  See :mc-cmd:`mc replicate add --replicate` for more complete documentation. Omit these fields to disable replication of delete operations or replication of existing objects respectively.

Specify any other supported optional arguments for :mc-cmd:`mc replicate add`.

3) Validate the Replication Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc cp` to copy a new object to the source bucket. 

.. code-block:: shell
   :class: copyable

   mc cp ~/foo.txt SOURCE/BUCKET

Use :mc-cmd:`mc ls` to verify the object exists on the destination bucket:

.. code-block:: shell
   :class: copyable

   mc ls TARGET/BUCKET
