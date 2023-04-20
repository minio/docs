.. start-replication-encrypted-objects

MinIO supports replication of objects encrypted using :ref:`SSE-KMS <minio-encryption-sse-kms>` and :ref:`SSE-S3 <minio-encryption-sse-s3>`:

- For objects encrypted using SSE-KMS, MinIO *requires* that the target bucket support SSE-KMS encryption of objects using the *same key names* used to encrypt objects on the source bucket.

- For objects encrypted using :ref:`SSE-S3 <minio-encryption-sse-s3>`, MinIO *requires* that the target bucket also support SSE-S3 encryption of objects regardless of key name.

As part of the replication process, MinIO *decrypts* the object on the source bucket and transmits the unencrypted object over the network. 
The destination MinIO deployment then re-encrypts the object using the encryption settings from the target. 
MinIO therefore *strongly recommends* :ref:`enabling TLS <minio-TLS>` on both source and destination deployments to ensure the safety of objects during transmission.

MinIO does *not* support replicating client-side encrypted objects (SSE-C).

.. end-replication-encrypted-objects

.. start-replication-minio-only

MinIO server-side replication only works between MinIO deployments. 
Both the source and destination deployments *must* run MinIO Server with matching versions. 

To configure replication between arbitrary S3-compatible services, use :mc:`mc mirror`.

.. end-replication-minio-only

.. start-replication-requires-versioning

MinIO relies on the immutability protections provided by :ref:`versioning <minio-bucket-versioning>` to support replication and resynchronization.

Use :mc-cmd:`mc version info` to validate the versioning status of both the source and remote buckets. 
Use the :mc-cmd:`mc version enable` command to enable versioning as necessary.

.. end-replication-requires-versioning

.. start-replication-requires-object-locking

MinIO supports replicating objects held under :ref:`WORM Locking <minio-object-locking>`. 
Both replication buckets *must* have object locking enabled for MinIO to replicate the locked object. 
For active-active configuration, MinIO recommends using the *same* retention rules on both buckets to ensure consistent behavior across sites.

You must enable object locking during bucket creation as per S3 behavior. 
You can then configure object retention rules at any time. 
Configure the necessary rules on the unhealthy target bucket *prior* to beginning this procedure.

.. end-replication-requires-object-locking

.. start-replication-required-permissions

Bucket replication requires specific permissions on the source and destination deployments to configure and enable replication rules. 

.. tab-set::

   .. tab-item:: Replication Admin

      The following policy provides permissions for configuring and enabling replication on a deployment. 

      .. literalinclude:: /extra/examples/ReplicationAdminPolicy.json
         :class: copyable
         :language: json

      - The ``"EnableRemoteBucketConfiguration"`` statement grants permission for creating a remote target for supporting replication.

      - The ``"EnableReplicationRuleConfiguration"`` statement grants permission for creating replication rules on a bucket. 
        The ``"arn:aws:s3:::*`` resource applies the replication permissions to *any* bucket on the source deployment. 
        You can restrict the user policy to specific buckets as-needed.

      The following code creates a :ref:`MinIO-managed user <minio-users>` with the necessary policy. Replace the ``TARGET``  with the :ref:`alias <alias>` of the MinIO deployment on which you are configuring replication:

      .. code-block:: shell
         :class: copyable

         wget -O - https://min.io/docs/minio/linux/examples/ReplicationAdminPolicy.json | \
         mc admin policy add TARGET ReplicationAdminPolicy /dev/stdin
         mc admin user add TARGET ReplicationAdmin LongRandomSecretKey
         mc admin policy set TARGET ReplicationAdminPolicy user=ReplicationAdmin

      MinIO deployments configured for :ref:`Active Directory/LDAP <minio-external-identity-management-ad-ldap>` or :ref:`OpenID Connect <minio-external-identity-management-openid>` user management should instead create a dedicated :ref:`access keys <minio-idp-service-account>` for bucket replication.

   .. tab-item:: Replication Remote User

      The following policy provides permissions for enabling synchronization of replicated data *into* the deployment.

      .. literalinclude:: /extra/examples/ReplicationRemoteUserPolicy.json
         :class: copyable
         :language: json

      - The ``"EnableReplicationOnBucket"`` statement grants permission for a remote target to retrieve bucket-level configuration for supporting replication operations on *all* buckets in the MinIO deployment. 
        To restrict the policy to specific buckets, specify those buckets as an element in the ``Resource`` array similar to ``"arn:aws:s3:::bucketName"``.

      - The ``"EnableReplicatingDataIntoBucket"`` statement grants permission for a remote target to synchronize data into *any* bucket in the MinIO deployment. 
        To restrict the policy to specific buckets, specify those buckets as an element in the ``Resource`` array similar to ``"arn:aws:s3:::bucketName/*"``.

      The following code creates a :ref:`MinIO-managed user <minio-users>` with the necessary policy. 
      Replace ``TARGET``  with the :ref:`alias <alias>` of the MinIO deployment on which you are configuring replication:

      .. code-block:: shell
         :class: copyable

         wget -O - https://min.io/docs/minio/linux/examples/ReplicationRemoteUserPolicy.json | \
         mc admin policy add TARGET ReplicationRemoteUserPolicy /dev/stdin
         mc admin user add TARGET ReplicationRemoteUser LongRandomSecretKey
         mc admin policy set TARGET ReplicationRemoteUserPolicy user=ReplicationRemoteUser

      MinIO deployments configured for :ref:`Active Directory/LDAP <minio-external-identity-management-ad-ldap>` or :ref:`OpenID Connect <minio-external-identity-management-openid>` user management should instead create a dedicated :ref:`access keys <minio-idp-service-account>` for bucket replication.

See :mc:`mc admin user`, :mc:`mc admin user svcacct`, and :mc:`mc admin policy` for more complete documentation on adding users, access keys, and policies to a MinIO deployment.

.. end-replication-required-permissions

.. start-replication-sync-vs-async

MinIO supports specifying either asynchronous (default) or synchronous replication for a given remote target.

With asynchronous replication, MinIO completes the originating ``PUT`` operation *before* placing the object into a :ref:`replication queue <minio-replication-process>`.
The originating client may therefore see a successful ``PUT`` operation *before* the object is replicated.
While this may result in stale or missing objects on the remote, it mitigates the risk of slow write operations due to replication load.

With synchronous replication, MinIO attempts to replicate the object *prior* to completing the originating ``PUT`` operation.
MinIO returns a successful ``PUT`` operation whether or not the replication attempt succeeds.
This reduces the risk of slow write operations at a possible cost of stale or missing objects on the remote location.

.. end-replication-sync-vs-async

.. start-mc-admin-replicate-what-replicates

Each MinIO deployment ("peer site") synchronizes the following changes across the other peer sites:

- Creation, modification, and deletion of buckets and objects, including

  - Bucket and Object Configurations
  - :ref:`Policies <minio-policy>`
  - :mc:`mc tag set`
  - :ref:`Locks <minio-object-locking>`, including retention and legal hold configurations
  - :ref:`Encryption settings <minio-encryption-overview>`

- Creation and deletion of IAM users, groups, policies, and policy mappings to users or groups (for LDAP users or groups)
- Creation of Security Token Service (STS) credentials for session tokens verifiable from the local ``root`` credentials
- Creation and deletion of :ref:`access keys <minio-mc-admin-user-svcacct>` (except those owned by the ``root`` user)

Site replication enables :ref:`bucket versioning <minio-bucket-versioning>` for all new and existing buckets on all replicated sites.

.. end-mc-admin-replicate-what-replicates

.. start-mc-admin-replicate-what-does-not-replicate

MinIO deployments in a site replication configuration do *not* replicate the creation or modification of the following items:

- :ref:`Bucket notifications <minio-bucket-notifications>`
- :ref:`Lifecycle management (ILM) configurations <minio-lifecycle-management>`
- :ref:`Site configuration settings <minio-mc-admin-config>`

.. end-mc-admin-replicate-what-does-not-replicate

.. start-mc-admin-replicate-load-balancing

When replicating to multi-node sites, use the URL or IP address of the site's load balancer, reverse proxy, or similar network control plane component which automatically routes requests to nodes in the deployment.

Using a single node for configuring site replication creates a single point of failure, where that node being offline results in replication failure.

.. end-mc-admin-replicate-load-balancing
