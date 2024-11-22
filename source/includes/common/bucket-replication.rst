.. start-create-bucket-replication-rule-cli-desc

Use the :mc:`mc replicate add` command to add a new replication rule to each MinIO deployment.

.. code-block:: shell
   :class: copyable

   mc replicate add ALIAS/BUCKET \
      --remote-bucket 'https://USER:PASSWORD@HOSTNAME:PORT/BUCKET' \
      --replicate "delete,delete-marker,existing-objects"

- Replace ``ALIAS`` with the :ref:`alias <alias>` of the origin MinIO deployment.  
  The name *must* match the bucket specified when creating the remote target in the previous step.

- Replace ``BUCKET`` with the name of the bucket to replicate from on the origin deployment. 

- Replace the ``--remote-bucket`` to specify the remote MinIO deployment and bucket to which the ``ALIAS/BUCKET`` replicates.

  The ``USER:PASSWORD`` must correspond to a user on the remote deployment with the :ref:`necessary replication permissions <minio-bucket-replication-serverside-twoway-permissions>`.

  The ``HOSTNAME:PORT`` must resolve to a reachable MinIO instance on the remote deployment.
  The ``BUCKET`` must exist and otherwise meet all other :ref:`replication requirements <minio-bucket-replication-requirements>`.

- The ``--replicate "delete,delete-marker,existing-objects"`` flag enables the following replication features:
  
  - :ref:`Replication of Deletes <minio-replication-behavior-delete>` 
  - :ref:`Replication of existing Objects <minio-replication-behavior-existing-objects>`
  
  See :mc-cmd:`mc replicate add --replicate` for more complete documentation. 
  Omit any field to disable replication of that component.

Specify any other supported optional arguments for :mc:`mc replicate add`.

.. end-create-bucket-replication-rule-cli-desc

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
