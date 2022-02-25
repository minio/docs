=================
``mc admin tier``
=================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin tier

Description
-----------

.. start-mc-admin-tier-desc

The :mc:`mc admin tier` command configures a remote supported S3-compatible
service for supporting MinIO 
:ref:`Lifecycle Management: Object Transition ("Tiering")
<minio-lifecycle-management-expiration>`. 

.. end-mc-admin-tier-desc

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only

Supported S3 Services
~~~~~~~~~~~~~~~~~~~~~

:mc:`mc admin tier` supports *only* the following S3-compatible services
as a remote target for object tiering:

- Amazon S3
- Google Cloud Storage
- Azure Blob Storage

Required Permissions
~~~~~~~~~~~~~~~~~~~~

MinIO requires the following permissions scoped to to the bucket or buckets 
for which you are creating lifecycle management rules.

- :policy-action:`s3:PutLifecycleConfiguration`
- :policy-action:`s3:GetLifecycleConfiguration`

MinIO also requires the following administrative permissions on the cluster
in which you are creating remote tiers for object transition lifecycle
management rules:

- :policy-action:`admin:SetTier`
- :policy-action:`admin:ListTier`

For example, the following policy provides permission for configuring object
transition lifecycle management rules on any bucket in the cluster:.

.. literalinclude:: /extra/examples/LifecycleManagementAdmin.json
   :language: json
   :class: copyable

Transition Permissions
++++++++++++++++++++++

Object transition lifecycle management rules require additional permissions
on the remote storage tier. Specifically, MinIO requires the remote
tier credentials provide read, write, list, and delete permissions.

For example, if the remote storage tier implements AWS IAM policy-based
access control, the following policy provides the necessary permission
for transitioning objects into and out of the remote tier:

.. literalinclude:: /extra/examples/LifecycleManagementUser.json
   :language: json
   :class: copyable

Modify the ``Resource`` for the bucket into which MinIO tiers objects.

Defer to the documentation for the supported tiering targets for more complete
information on configuring users and permissions to support MinIO tiering:

- :aws-docs:`Amazon S3 Permissions <service-authorization/latest/reference/list_amazons3.html#amazons3-actions-as-permissions>`
- `Google Cloud Storage Access Control <https://cloud.google.com/storage/docs/access-control>`__
- `Authorizing access to data in Azure storage <https://docs.microsoft.com/en-us/azure/storage/common/storage-auth?toc=/azure/storage/blobs/toc.json>`__


Syntax
------

.. mc-cmd:: add
   :fullpath:

   Creates a new remote storage tier for transitioning objects using MinIO
   lifecycle management rules. 
   
   .. important::

      MinIO does not support removing remote storage tiers. Ensure the 
      storage backend supports the intended workload *prior* to 
      adding it as a remote tier target. 
   
   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc admin tier add TIER_TYPE TARGET TIER_NAME [FLAGS]

   The command accepts the following arguments:

   .. mc-cmd:: TIER_TYPE

      *Required*

      The Cloud Service Provider storage backend ("Tier") to which MinIO
      transitions objects. Specify *one* of the following supported values:

      .. list-table::
         :stub-columns: 1
         :width: 100%
         :widths: 30 70

         * - ``s3``
           - Use AWS S3 *or* a remote MinIO deployment as the storage
             backend for the new Tier.

             Requires specifying the following additional options:

             - :mc-cmd:`~mc admin tier add access-key`
             - :mc-cmd:`~mc admin tier add secret-key`

         * - ``azure``
           - Use :abbr:`Azure (Microsoft Azure)` Blob Storage as the storage
             backend for the new Tier.

             Requires specifying the following additional options:

             - :mc-cmd:`~mc admin tier add account-name`
             - :mc-cmd:`~mc admin tier add account-key`
         
         * - ``gcs`` 
           - Use :abbr:`GCP (Google Cloud Platform)` Cloud Storage as the
             storage backend for the new Tier.

             Requires specifying the following additional option:

             - :mc-cmd:`~mc admin tier add credentials-file`

   .. mc-cmd:: TARGET

      *Required*

      The :mc-cmd:`alias <mc alias>` of a configured MinIO deployment on which
      the command creates the new remote tier.
      
   .. mc-cmd:: TIER_NAME

      *Required*

      The name to associate with the new remote tier. The name *must*
      be unique across all configured tiers on the MinIO cluster.

      You **must** specify the tier in all-caps, e.g. ``WARM_TIER``.
   
   .. mc-cmd:: endpoint
      

      *Required*
      
      The URL endpoint for the cloud service provider. The URL endpoint
      *must* resolve to the provider specified to
      :mc-cmd:`~mc admin tier add TIER_TYPE`. 

   .. mc-cmd:: access-key
      

      *Required*
      
      The access key for a user on the remote S3 tier. The user must
      have permission to perform read/write/list/delete operations on the 
      remote bucket or bucket prefix.
      
      Required if :mc-cmd:`~mc admin tier add TIER_TYPE` is ``s3``. 
      This option has no effect for any other value of ``TIER_TYPE``.

   .. mc-cmd:: secret-key
      

      *Required*
      
      The secret key for a user on the remote S3 tier.

      Required if :mc-cmd:`~mc admin tier add TIER_TYPE` is ``s3``. 
      This option has no effect for any other value of ``TIER_TYPE``.

   .. mc-cmd:: account-name
      

      *Required*
      
      The account name for a user on the remote Azure tier. The user
      must have permission to perform read/write/list/delete operations on the
      remote bucket or bucket prefix.
      
      Required if :mc-cmd:`~mc admin tier add TIER_TYPE` is ``azure``. 
      This option has no effect for any other value of ``TIER_TYPE``.

      MinIO does *not* support changing the account name associated to an Azure
      remote tier. Azure storage backends are tied to the account, such that
      changing the account would change the storage backend and prevent access
      to any objects transitioned to the original account/backend.

   .. mc-cmd:: account-key
      

      *Required*
      
      The account key for the :mc-cmd:`~mc admin tier add account-name` 
      associated to the remote Azure tier.

      Required if :mc-cmd:`~mc admin tier add TIER_TYPE` is ``azure``. 
      This option has no effect for any other value of ``TIER_TYPE``.

   .. mc-cmd:: credentials-file
      

      *Required*
      
      The `credential file
      <https://cloud.google.com/docs/authentication/getting-started>`__ for a
      user on the remote GCS tier. The user must have permission to perform
      read/write/list/delete operations on the remote bucket or bucket prefix.
      
      Required if :mc-cmd:`~mc admin tier add TIER_TYPE` is ``gcs``. 
      This option has no effect for any other value of ``TIER_TYPE``.

   .. mc-cmd:: bucket
      

      *Required*
      
      The bucket on the remote tier to which MinIO transitions objects.

   .. mc-cmd:: prefix
      

      *Optional*
      
      The prefix path for the specified :mc-cmd:`~mc admin tier add bucket`
      to which MinIO transitions objects.

      Omit this field to transition objects into the bucket root.

   .. mc-cmd:: storage-class
      

      *Optional*

      The AWS storage class to use for objects transitioned by 
      MinIO. MinIO supports only the following storage classes:

      - ``STANDARD``
      - ``REDUCED_REDUNDANCY``

      Defaults to ``S3_STANDARD`` if omitted. 

      This option only applies if :mc-cmd:`~mc admin tier add TIER_TYPE` is 
      ``s3``. This option has no effect for any other value of ``TIER_TYPE``.

   .. mc-cmd:: region
      

      *Optional*

      The S3 backend region for the specified 
      :mc-cmd:`~mc admin tier add TIER_TYPE`, such as ``us-west-1``.

      This option only applies if :mc-cmd:`~mc admin tier add TIER_TYPE` is 
      ``s3``. This option has no effect for any other value of ``TIER_TYPE``.
      
.. mc-cmd:: edit
   :fullpath:

   Modify or remove a remote storage tier from a MinIO cluster. Remote
   storage tiers support transitioning objects using MinIO lifecycle
   management rules.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc admin tier edit TARGET TIER_NAME [FLAGS]

   The command accepts the following arguments:

   .. mc-cmd:: TARGET

      *Required*

      The :mc-cmd:`alias <mc alias>` of a configured MinIO deployment.

   .. mc-cmd:: TIER_NAME

      *Required*

      The name of the remote tier the command modifies. The value
      corresponds to the :mc-cmd:`mc admin tier add TIER_NAME` specified
      when creating the remote tier.

   .. mc-cmd:: access-key
      

      *Optional*
      
      The access key for a user on the remote S3 tier. The user must
      have permission to perform read/write/list/delete operations on the 
      remote bucket or bucket prefix.

      This option only applies to remote storage tiers with 
      :mc-cmd:`~mc admin tier add TIER_TYPE` is ``s3``. 
      This option has no effect for any other ``TIER_TYPE``.

   .. mc-cmd:: secret-key
      

      *Optional*
      
      The secret key for a user on the remote S3 tier.

      This option only applies to remote storage tiers with 
      :mc-cmd:`~mc admin tier add TIER_TYPE` is ``s3``. 
      This option has no effect for any other ``TIER_TYPE``.

   .. mc-cmd:: account-key
      

      *Required*

      The account key for a user on the remote Azure tier.
      Use this option to rotate the credentials for the
      :mc-cmd:`~mc admin tier add account-name` 
      associated to the remote tier.

      This option only applies to remote storage tiers with 
      :mc-cmd:`~mc admin tier add TIER_TYPE` is ``azure``. 
      This option has no effect for any other ``TIER_TYPE``.

   .. mc-cmd:: credentials-file
      

      *Required*
      
      The credential file for a user on the remote GCS tier. The user must have
      permission to perform read/write/list/delete operations on the remote bucket
      or bucket prefix.
      
      This option only applies to remote storage tiers with 
      :mc-cmd:`~mc admin tier add TIER_TYPE` is ``gcs``. 
      This option has no effect for any other ``TIER_TYPE``.
   
.. mc-cmd:: ls
   :fullpath:

   List all remote storage tiers on a MinIO cluster. Remote storage tiers
   support transitioning objects using MinIO lifecycle management rules.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc admin tier ls TARGET [FLAGS]

   The command accepts the following arguments:

   .. mc-cmd:: TARGET

      *Required*

      The :mc-cmd:`alias <mc alias>` of a configured MinIO deployment.
