.. start-create-replication-remote-targets-cli-desc

Use the :mc-cmd:`mc admin bucket remote add` command to create a replication target from each deployment to the appropriate bucket on the destination deployment. 
A bucket may have multiple remote targets to different target buckets.
No two targets can resolve from one bucket to the same remote bucket. 

.. code-block:: shell
   :class: copyable

   mc admin bucket remote add ALIAS/BUCKET                    \
      https://RemoteUser:Password@HOSTNAME/BUCKETDESTINATION  \
      --service "replication"

- Replace ``ALIAS`` with the :ref:`alias <alias>` of the MinIO deployment that acts as the origin for the replication.
- Replace ``BUCKET`` with the name of the bucket to replicate from on the origin deployment.
- Replacete ``RemoteUser`` with the user name that has the :ref:`necessary replication permissions <minio-bucket-replication-serverside-twoway-permissions>`
- Replace ``Password`` with the secret key for the ``RemoteUser``.
- Replace ``HOSTNAME`` with the URL of the destination deployment.
- Replace ``BUCKETDESTINATION`` with the name of the bucket to replicate to on the destination deployment.

The command returns an :abbr:`ARN <Amazon Resource Name>` similar to the following:

.. code-block:: shell

   Role ARN = 'arn:minio:replication::<UUID>:BUCKET'

Copy the ARN to use in the next step, noting the MinIO deployment.

.. end-create-replication-remote-targets-cli-desc

.. start-create-bucket-replication-rule-console-desc

A) Log in to the MinIO Console for the deployment
B) Select the :guilabel:`Manage` button for the bucket to replicate

   .. image:: /images/minio-console/console-bucket.png
      :width: 600px
      :alt: After a successful log in, the MinIO Console shows a list of buckets with options to manage or explore each bucket.
      :align: center

C) Select the :guilabel:`Replication` section

   .. image:: /images/minio-console/console-iam.png
      :width: 600px
      :alt: After selecting a bucket to manage, MinIO shows summary information about the bucket as well as a navigation list of pages for adjusting the bucket configuration.
      :align: center

D) Select :guilabel:`Add Replication Rule +`
E) Complete the requested information:
   
   .. list-table::
      :header-rows: 1
      :widths: 25 75
      :width: 100%

      * - Field
        - Description

      * - Priority
        - Enter a number value to indicate the order in which to process replication rules for the bucket.
          `1` indicates the highest importance.
   
      * - Target URL
        - The URL of the deployment to replicate data to.

      * - Use TLS
        - Leave the toggle in the :guilabel:`ON` position if the destination deployment uses TLS.
          Otherwise, move the toggle to the :guilabel:`OFF` position.

      * - Access Key
        - The user name to use on the destination deployment.
          The user must have write access to the bucket to replicate to.

      * - Secret Key 
        - The password for the provided **Access Key**.

      * - Target Bucket
        - The bucket at the destination to write the data to.
          The target bucket may have the same name as the origin bucket, depending on the destination bucket location.

      * - Region
        - The AWS resource region location of the destination deployment.

      * - Replication mode
        - Leave the default selection of **Asynchronous** to allow MinIO to replicate data after the write operation completes on the origin ment.
          Select **Synchronous** to attempt to complete the replication of the object during its write operation.
       
          While synchronous replication may result in more reliable synchronization between the origin and destination buckets, it may also increase the time of each write operation.

      * - Bandwidth
        - Specify the maximum amount of bandwidth the replication process can use while replicating data.
          Enter a number and select a data unit.

      * - Health Check Duration
        - The maximum length of time in seconds MinIO should spend verifying the health of the replicated data on the destination bucket.

      * - Storage Class
        - The class of storage to use on the destination deployment for the replicated data.
          Valid values are either ``STANDARD`` or ``REDUCED_REDUNDANCY``.

      * - Object Filters
        - Limit which objects to replicate from the bucket by :term:`Prefix` or **tags**.
          If you enter multiple tags, the objects must match all tag values.

      * - Metadata Sync
        - Leave selected to also replicate the object's metadata file.
          Otherwise, move the toggle to the :guilabel:`Off` position.

      * - Delete Markers
        - Leave selected to also replicate MinIO's indication that an object has been deleted and should also be marked deleted at the ation bucket.
          Otherwise, move the toggle to the :guilabel:`Off` position to prevent marking the object as deleted in the destination bucket.

      * - Deletes
        - Leave selected to allow replication of the deletion of versions of an object.
          Otherwise, move the toggle to the :guilabel:`Off` position to not replicate deletion of object versions.

F) Select :guilabel:`Save` to finish adding the replication rule

.. end-create-bucket-replication-rule-console-desc


.. start-create-bucket-replication-rule-cli-desc

Use the :mc:`mc replicate add` command to add a new replication rule to each MinIO deployment. 

.. code-block:: shell
   :class: copyable

   mc replicate add ALIAS/BUCKET \
      --remote-bucket 'arn:minio:replication::<UUID>:DESTINATIONBUCKET' \
      --replicate "delete,delete-marker,existing-objects"

- Replace ``ALIAS`` with the :ref:`alias <alias>` of the origin MinIO deployment.  
  The name *must* match the bucket specified when creating the remote target in the previous step.

- Replace ``BUCKET`` with the name of the bucket to replicate from on the origin deployment. 

- Replace the ``--remote-bucket`` value with the ARN for the destination bucket determined in the first step. 
  Ensure you specify the ARN created on the origin deployment. 
  You can use :mc-cmd:`mc admin bucket remote ls` to list all remote ARNs configured on the deployment.

- The ``--replicate "delete,delete-marker,existing-objects"`` flag enables the following replication features:
  
  - :ref:`Replication of Deletes <minio-replication-behavior-delete>` 
  - :ref:`Replication of existing Objects <minio-replication-behavior-existing-objects>`
  
  See :mc-cmd:`mc replicate add --replicate` for more complete documentation. 
  Omit any field to disable replication of that component.

Specify any other supported optional arguments for :mc:`mc replicate add`.

.. end-create-bucket-replication-rule-cli-desc

.. start-validate-bucket-replication-console-desc

A) Go to the :guilabel:`Buckets` section of the MinIO Console
   
   .. image:: /images/minio-console/console-bucket.png
      :width: 600px
      :alt: The default screen when logging into the MinIO Console. The screen shows a list of the buckets available in the Deployment with options to Manage or Browse the bucket contents.
      :align: center

B) Select the :guilabel:`Browse` button for the bucket you added replication to

   .. image:: /images/minio-console/console-object-browser.png
      :width: 600px
      :alt: The contents of a bucket display after selecting to Browse the MinIO bucket. Options including to Rewind, Refresh, or Upload contents.
      
C) Select the :guilabel:`Upload` button to add a new object to the bucket
D) Select :guilabel:`Upload File`
E) Use the interface to add a new object to the bucket
F) Go to the other deployment's console and select the destination bucket defined in the replication

.. end-validate-bucket-replication-console-desc

.. start-validate-bucket-replication-cli-desc

Use :mc:`mc cp` to copy a new object to the replicated bucket on one of the deployments. 

.. code-block:: shell
   :class: copyable

   mc cp ~/foo.txt ALIAS/BUCKET

Use :mc:`mc ls` to verify the object exists on the destination bucket:

.. code-block:: shell
   :class: copyable

   mc ls ALIAS/BUCKET

.. end-validate-bucket-replication-cli-desc