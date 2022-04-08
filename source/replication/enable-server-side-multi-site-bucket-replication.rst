.. _minio-bucket-replication-serverside-multi:

================================================
Enable Multi-Site Server-Side Bucket Replication
================================================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1


The procedure on this page configures automatic server-side bucket replication between multiple MinIO deployments. Multi-Site Active-Active replication builds on the :ref:`minio-bucket-replication-serverside-twoway` procedure with additional considerations required to ensure predictable replication behavior across all sites.

.. image:: /images/replication/active-active-multi-replication.svg
   :width: 600px
   :alt: Active-Active Replication synchronizes data between multiple remote deployments.
   :align: center

- To configure replication between arbitrary S3-compatible services, use :mc-cmd:`mc mirror`.

- To configure one-way "active-active" replication between two MinIO deployments, see :ref:`minio-bucket-replication-serverside-twoway`.

- To configure one-way "active-passive" replication between MinIO deployments, see :ref:`minio-bucket-replication-serverside-oneway`.

Multi-Site Active-Active replication configurations can span multiple racks, datacenters, or geographic locations. Complexity of configuring and maintaining multi-site configurations generally increase with the number of sites and size of each site. Enterprises looking to implement multi-site replication should consider leveraging `MinIO SUBNET <https://min.io/pricing?ref=docs>`__ support to access the expertise, planning, and engineering resources required for addressing that use case. 

.. seealso::

   - Use the :mc-cmd:`mc replicate edit` command to modify an existing replication rule.

   - Use the :mc-cmd:`mc replicate edit` command with the :mc-cmd:`--state "disable" <mc replicate edit --state>` flag to disable an existing replication rule.

   - Use the :mc-cmd:`mc replicate rm` command to remove an existing replication rule.

.. _minio-bucket-replication-serverside-multi-requirements:

Requirements
------------

Install and Configure ``mc`` with Access to Both Clusters.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This procedure uses :mc:`mc` for performing operations on both the source and destination MinIO cluster. Install :mc:`mc` on a machine with network access to both source and destination deployments. See the ``mc`` :ref:`Installation Quickstart <mc-install>` for instructions on downloading and installing ``mc``.

Use the :mc:`mc alias` command to create an alias for both MinIO deployments. Alias creation requires specifying an access key for a user on the cluster. This user **must** have permission to create and manage users and policies on the cluster. Specifically, ensure the user has *at minimum*:

- :policy-action:`admin:CreateUser`
- :policy-action:`admin:ListUsers`
- :policy-action:`admin:GetUser`
- :policy-action:`admin:CreatePolicy`
- :policy-action:`admin:GetPolicy`
- :policy-action:`admin:AttachUserOrGroupPolicy`

.. _minio-bucket-replication-serverside-multi-permissions:

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

Use Consistent Replication Settings
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports customizing the replication configuration to enable or disable the following replication behaviors:

- Replication of delete operations
- Replication of delete markers
- Replication of existing objects
- Replication of metadata-only changes

When configuring replication rules for a bucket, ensure that all MinIO deployments participating in multi-site replication use the *same* replication behaviors to ensure consistent and predictable synchronization of objects.

Replication of Existing Objects
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports automatically replicating existing objects in a bucket.

MinIO requires explicitly enabling replication of existing objects using the :mc-cmd:`mc replicate add --replicate` or :mc-cmd:`mc replicate edit --replicate` and including the ``existing-objects`` replication feature flag. This procedure includes the required flags for enabling replication of existing objects.

Replication of Delete Operations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports replicating delete operations onto the target bucket. Specifically, MinIO can replicate versioning :s3-docs:`Delete Markers <versioning-workflows.html>` and the deletion of specific versioned objects:

- For delete operations on an object, MinIO replication also creates the delete marker on the target bucket.

- For delete operations on versions of an object, MinIO replication also deletes those versions on the target bucket.

MinIO requires explicitly enabling replication of delete operations using the :mc-cmd:`mc replicate add --replicate` or :mc-cmd:`mc replicate edit --replicate`. This procedure includes the required flags for enabling replication of delete operations and delete markers.

MinIO does *not* replicate delete operations resulting from the application of :ref:`lifecycle management expiration rules <minio-lifecycle-management-expiration>`. Configure matching expiration rules for the bucket on all replication sites to ensure consistent application of object expiration.

Procedure
---------

This procedure requires repeating steps for each MinIO deployment participating in the multi-site replication configuration. Depending on the number of deployments, this procedure may require significant time and care in implementation. MinIO recommends reading through the procedure *before* attempting to implement the documented steps.

This procedure uses the placeholder ``ALIAS`` to reference the :ref:`alias <alias>` each MinIO deployment being configured for replication. Replace these values with the appropriate alias for each MinIO deployment.

This procedure assumes each alias corresponds to a user with the :ref:`necessary replication permissions <minio-bucket-replication-serverside-multi-permissions>`.

1) Create the Replication Remote Target
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc admin bucket remote add` command to create a replication target for the each deployment. MinIO supports *one* remote target per destination bucket. You cannot create multiple remote targets for the same destination bucket.

.. code-block:: shell
   :class: copyable

   mc admin bucket remote add ALIAS/BUCKET \
      https://ReplicationRemoteUser:LongRandomSecretKey@HOSTNAME/BUCKET \
      --service "replication"

- Replace ``BUCKET`` with the name of the bucket on the ``ALIAS`` deployment to use as the replication source. Replace ``ALIAS`` with the :ref:`alias <alias>` of the MinIO deployment on which you are configuring replication.

- Replace ``HOSTNAME`` with the URL of the  remote MinIO deployment.

- Replace ``BUCKET`` with the name of the bucket on the remote deployment to use as the replication destination.

The command returns an ARN similar to the following:

.. code-block:: shell

   Role ARN = 'arn:minio:replication::<UUID>:BUCKET'

Copy the ARN string for use in the next step, noting the MinIO deployment on which it was created.

Repeat these commands for each remote MinIO deployment participating in the multi-site replication configuration. For example, a multi-site replication configuration consisting of MinIO deployments ``Alpha``, ``Baker``, and ``Charlie`` would require repeating this step on each deployment for each remote. Specifically:

- The ``Alpha`` deployment would perform this step once for
  ``Baker`` and once for ``Charlie``. 

- The ``Baker`` deployment would perform this step once for ``Alpha`` and 
  once for ``Charlie``.

- The ``Charlie`` deployment would perform this step once for ``Baker`` and
  once for ``Alpha``.

2) Create a New Bucket Replication Rule
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc replicate add` command to add the new server-side
replication rule to the each MinIO deployment. 

.. code-block:: shell
   :class: copyable

   mc replicate add ALIAS/BUCKET \
      --remote-bucket 'arn:minio:replication::<UUID>:BUCKET' \
      --replicate "delete,delete-marker,existing-objects"

- Replace ``BUCKET`` with the name of the bucket on the ``ALIAS`` deployment to use as the replication source. Replace ``ALIAS`` with the :ref:`alias <alias>` of the MinIO deployment on which you are configuring replication.

- Replace the ``--remote-bucket`` value with the ARN returned in the previous step. Ensure you specify the ARN created on the ``ALIAS`` deployment. You can use :mc-cmd:`mc admin bucket remote ls` to list all remote ARNs configured on the deployment.

- The ``--replicate "delete,delete-marker,existing-objects"`` flag enables the following replication features:
  
  - :ref:`Replication of Deletes <minio-replication-behavior-delete>` 
  - :ref:`Replication of existing Objects <minio-replication-behavior-existing-objects>`
  
  See :mc-cmd:`mc replicate add --replicate` for more complete documentation. Omit these fields to disable replication of delete operations or replication of existing objects respectively.

Specify any other supported optional arguments for :mc-cmd:`mc replicate add`.

Repeat these commands for each remote MinIO deployment participating in the multi-site replication configuration. For example, a multi-site replication configuration consisting of MinIO deployments ``Alpha``, ``Baker``, and ``Charlie`` would require repeating this step on each deployment for each remote. Specifically:

- The ``Alpha`` deployment would perform this step once for
  ``Baker`` and once for ``Charlie``. 

- The ``Baker`` deployment would perform this step once for ``Alpha`` and 
  once for ``Charlie``.

- The ``Charlie`` deployment would perform this step once for ``Baker`` and
  once for ``Alpha``.

3) Validate the Replication Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc cp` to copy a new object the bucket on any of the deployments:

.. code-block:: shell
   :class: copyable

   mc cp ~/foo.txt ALIAS/BUCKET

Use :mc-cmd:`mc ls` to verify the object exists on each remote deployment:

.. code-block:: shell
   :class: copyable

   mc ls REMOTE/BUCKET

Repeat this test on each of the deployments by copying a new unique file and checking the other deployments for that file.

You can also use :mc-cmd:`mc stat` to check the file to check the current :ref:`replication stage <minio-replication-process>` of the object.
