.. _minio-policy:

=================
Access Management
=================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

Overview
--------

MinIO uses Policy-Based Access Control (PBAC) to define the authorized actions and resources to which an authenticated user has access. 
Each policy describes one or more :ref:`actions <minio-policy-actions>` and :ref:`conditions <minio-policy-conditions>` that outline the permissions of a :ref:`user <minio-users>` or :ref:`group <minio-groups>` of users.

MinIO PBAC is built for compatibility with AWS IAM policy syntax, structure, and behavior. 
The MinIO documentation makes a best-effort to cover IAM-specific behavior and functionality. 
Consider deferring to the :iam-docs:`IAM documentation <>` for more complete documentation on AWS IAM-specific topics.

The :mc:`mc admin policy` command supports creation and management of policies on the MinIO deployment. 
See the command reference for examples of usage.

Tag-Based Policy Conditions
---------------------------

.. versionchanged:: RELEASE.2022-10-02T19-29-29Z

   Policies can use conditions to limit a user's access only to objects with a specific tag.

   MinIO supports :s3-docs:`tag-based conditionals <tagging-and-policies.html>` for policies for :ref:`selected actions <minio-selected-conditional-actions>`.
   Use the ``s3:ExistingObjectTag/<key>`` in the ``Condition`` statement of the policy.

.. _minio-policy-built-in:

Built-In Policies
-----------------

MinIO provides the following built-in policies for assigning to 
:ref:`users <minio-users>` or :ref:`groups <minio-groups>`:

.. userpolicy:: consoleAdmin

   Grants complete access to all S3 and administrative API operations against
   all resources on the MinIO deployment. Equivalent to the following set of
   actions:

   - :policy-action:`s3:*`
   - :policy-action:`admin:*`

.. userpolicy:: readonly

   Grants read-only permissions on any object on the MinIO deployment. The GET
   action *must* apply to a specific object without requiring any listing.
   Equivalent to the following set of actions:

   - :policy-action:`s3:GetBucketLocation`
   - :policy-action:`s3:GetObject`

   For example, this policy specifically supports GET operations on objects at a
   specific path (e.g. ``GET play/mybucket/object.file``), such as:

   - :mc:`mc cp`
   - :mc:`mc stat`
   - :mc:`mc head`
   - :mc:`mc cat`

   The exclusion of listing permissions is intentional, as typical use cases
   do not intend for a "read-only" role to have complete discoverability
   (listing all buckets and objects) on the object storage resource.

.. userpolicy:: readwrite

   Grants read and write permissions for all buckets and objects on the
   MinIO server. Equivalent to :policy-action:`s3:*`.

.. userpolicy:: diagnostics

   Grants permission to perform diagnostic actions on the MinIO deployment. 
   Specifically includes the following actions:

   - :policy-action:`admin:ServerTrace`
   - :policy-action:`admin:Profiling`
   - :policy-action:`admin:ConsoleLog`
   - :policy-action:`admin:ServerInfo`
   - :policy-action:`admin:TopLocksInfo`
   - :policy-action:`admin:OBDInfo`
   - :policy-action:`admin:BandwidthMonitor`
   - :policy-action:`admin:Prometheus`

.. userpolicy:: writeonly

   Grants write-only permissions to any namespace (bucket and path to object)
   the MinIO deployment. The PUT action *must* apply to a specific object
   location without requiring any listing. 
   Equivalent to the :policy-action:`s3:PutObject` action.

Use :mc:`mc admin policy attach` to associate a policy to a 
user or group on a MinIO deployment.

For example, consider the following table of users. Each user is assigned
a :ref:`built-in policy <minio-policy-built-in>` or
a supported :ref:`action <minio-policy-actions>`. The table
describes a subset of operations a client could perform if authenticated
as that user:

.. list-table::
   :header-rows: 1
   :widths: 20 40 40
   :width: 100%

   * - User
     - Policy
     - Operations

   * - ``Operations``
     - | :userpolicy:`readwrite` on ``finance`` bucket
       | :userpolicy:`readonly` on ``audit`` bucket
     
     - | ``PUT`` and ``GET`` on ``finance`` bucket.
       | ``GET`` on ``audit`` bucket

   * - ``Auditing``
     - | :userpolicy:`readonly` on ``audit`` bucket
     - ``GET`` on ``audit`` bucket

   * - ``Admin``
     - :policy-action:`admin:*`
     - All :mc:`mc admin` commands.

Each user can access only those resources and operations which are *explicitly*
granted by the built-in role. MinIO denies access to any other resource or
action by default.

.. admonition:: ``Deny`` overrides ``Allow``
   :class: note

   MinIO follows the IAM policy evaluation rules where a ``Deny`` rule overrides
   ``Allow`` rule on the same action/resource. For example, if a user has an
   explicitly assigned policy with an ``Allow`` rule for an action/resource
   while one of its groups has an assigned policy with a ``Deny`` rule for that
   action/resource, MinIO would apply only the ``Deny`` rule. 

   For more information on IAM policy evaluation logic, see the IAM
   documentation on 
   :iam-docs:`Determining Whether a Request is Allowed or Denied Within an Account 
   <reference_policies_evaluation-logic.html#policy-eval-denyallow>`.

.. _minio-policy-document:

Policy Document Structure
-------------------------

MinIO policy documents use the same schema as 
:aws-docs:`AWS IAM Policy <IAM/latest/UserGuide/access.html>` documents.

The following sample document provides a template for creating custom
policies for use with a MinIO deployment. For more complete documentation on IAM
policy elements, see the :aws-docs:`IAM JSON Policy Elements Reference
<IAM/latest/UserGuide/reference_policies_elements.html>`.
The maximum size for a policy document is 2048 characters.

.. code-block:: javascript
   :class: copyable

   {
      "Version" : "2012-10-17",
      "Statement" : [
         {
            "Effect" : "Allow",
            "Action" : [ "s3:<ActionName>", ... ],
            "Resource" : "arn:aws:s3:::*",
            "Condition" : { ... }
         },
         {
            "Effect" : "Deny",
            "Action" : [ "s3:<ActionName>", ... ],
            "Resource" : "arn:aws:s3:::*",
            "Condition" : { ... }
         }
      ]
   }

- For the ``Statement.Action`` array, specify one or more :ref:`supported S3 API operations <minio-policy-actions>`. 

- For the ``Statement.Resource`` key, specify the bucket or bucket prefix to which to restrict the policy.
  You can use ``*`` and ``?`` wildcard characters as per the :s3-docs:`S3 Resource Spec <s3-arn-format.html>`.

  The ``*`` wildcard may result in unintended application of a policy to multiple buckets or prefixes based on the pattern match.
  For example, ``arn:aws:s3:::data*`` would match the buckets ``data``, ``data_private``, and ``data_internal``.
  Specifying only ``*`` as the resource key applies the policy to all buckets and prefixes on the deployment.

- For the ``Statement.Condition`` key, you can specify one or more :ref:`supported Conditions <minio-policy-conditions>`.

.. _minio-policy-actions:

Supported S3 Policy Actions
---------------------------

MinIO policy documents support a subset of IAM :iam-docs:`S3 Action keys <list_amazons3.html#amazons3-actions-as-permissions>`.
This section also includes any :ref:`condition keys <minio-policy-conditions>` supported by a specific action beyond the common set of supported keys.

The following actions control access to common S3 operations. 
The remaining subsections document actions for more advanced S3 operations:

.. policy-action:: s3:*
   
   Selector for *all* MinIO S3 operations. 
   Applying this action to a given resource allows the user to perform *any* S3 operation against that resource. 

.. policy-action:: s3:CreateBucket
   
   Controls access to the :s3-api:`CreateBucket <API_CreateBucket.html>` S3 API
   operation.

.. policy-action:: s3:DeleteBucket
   
   Controls access to the :s3-api:`DeleteBucket <API_DeleteBucket.html>` S3 API
   operation.

.. policy-action:: s3:ForceDeleteBucket
   
   Controls access to the :s3-api:`DeleteBucket <API_DeleteBucket.html>`
   S3 API operation for operations with the ``x-minio-force-delete`` flag.
   Required for removing non-empty buckets.

.. policy-action:: s3:GetBucketLocation
   
   Controls access to the :s3-api:`GetBucketLocation <API_GetBucketLocation.html>` S3 API operation.

.. policy-action:: s3:ListAllMyBuckets
   
   Controls access to the :s3-api:`ListBuckets <API_ListBuckets.html>` S3 API operation.

.. policy-action:: s3:DeleteObject
   
   Controls access to the :s3-api:`DeleteObject <API_DeleteObject.html>` S3 API operation.

.. policy-action:: s3:GetObject
   
   Controls access to the :s3-api:`GetObject <API_GetObject.html>` S3 API operation.

   Supports the following additional :ref:`condition keys <minio-policy-conditions>`:

   .. code-block:: shell

      s3:x-amz-server-side-encryption   
      s3:x-amz-server-side-encryption-customer-algorithm   
      s3:ExistingObjectTag/<key>   
      s3:versionid   

.. policy-action:: s3:ListBucket
   
   Controls access to the :s3-api:`ListObjectsV2 <API_ListObjectsV2.html>` S3 API operation.

   Supports the following additional :ref:`condition keys <minio-policy-conditions>`:

   .. code-block:: shell

      s3:prefix   
      s3:delimiter   
      s3:max-keys   

.. policy-action:: s3:PutObject
   
   Controls access to the :s3-api:`PutObject <API_PutObject.html>` S3 API operation.

   Supports the following additional :ref:`condition keys <minio-policy-conditions>`:

   .. code-block:: shell

      s3:x-amz-copy-source    
      s3:x-amz-server-side-encryption   
      s3:x-amz-server-side-encryption-customer-algorithm   
      s3:x-amz-metadata-directive   
      s3:x-amz-storage-class   
      s3:versionid   
      s3:object-lock-retain-until-date   
      s3:object-lock-mode   
      s3:object-lock-legal-hold   
      s3:RequestObjectTagKeys   
      s3:RequestObjectTag/<key>   

.. policy-action:: s3:PutObjectTagging

   Controls access to the :s3-api:`PutObjectTagging <API_PutObjectTagging.html>` S3 API operation.

   Supports the following additional :ref:`condition keys <minio-policy-conditions>`:

   .. code-block:: shell

      s3:versionid   
      s3:ExistingObjectTag/<key>   
      s3:RequestObjectTagKeys   
      s3:RequestObjectTag/<key>   

.. policy-action:: s3:GetObjectTagging

   Controls access to the :s3-api:`GetObjectTagging <API_GetObjectTagging.html>` S3 API operation.

   Supports the following additional :ref:`condition keys <minio-policy-conditions>`:

   .. code-block:: shell

     s3:versionid   
     s3:ExistingObjectTag/<key>   

.. policy-action:: s3:DeleteObjectTagging

   Controls access to the :s3-api:`DeleteObjectTagging <API_DeleteObjectTagging.html>` S3 API operation.

   Supports the following additional :ref:`condition keys <minio-policy-conditions>`:

   .. code-block:: shell

     s3:versionid   
     s3:ExistingObjectTag/<key>

Bucket Configuration
~~~~~~~~~~~~~~~~~~~~

.. policy-action:: s3:GetBucketPolicy
   
   Controls access to the :s3-api:`GetBucketPolicy <API_GetBucketPolicy.html>` S3 API operation.

.. policy-action:: s3:PutBucketPolicy
   
   Controls access to the :s3-api:`PutBucketPolicy <API_PutBucketPolicy.html>`
   S3 API operation.

.. policy-action:: s3:DeleteBucketPolicy
   
   Controls access to the :s3-api:`DeleteBucketPolicy <API_DeleteBucketPolicy.html>` S3 API operation.

.. policy-action:: s3:GetBucketTagging
   
   Controls access to the :s3-api:`GetBucketTagging <API_GetBucketTagging.html>`
   S3 API operation.

.. policy-action:: s3:PutBucketTagging
   
   Controls access to the :s3-api:`PutBucketTagging <API_PutBucketTagging.html>`
   S3 API operation.

   Supports the following additional :ref:`condition keys <minio-policy-conditions>`:

   .. code-block:: shell

      s3:RequestObjectTagKeys   
      s3:RequestObjectTag/<key>   

Multipart Upload
~~~~~~~~~~~~~~~~

.. policy-action:: s3:AbortMultipartUpload
   
   Controls access to the :s3-api:`AbortMultipartUpload <API_AbortMultipartUpload.html>` S3 API operation.

.. policy-action:: s3:ListMultipartUploadParts
   
   Controls access to the :s3-api:`ListParts <API_ListParts.html>` S3 API
   operation.

.. policy-action:: s3:ListBucketMultipartUploads
   
   Controls access to the :s3-api:`ListMultipartUploads <API_ListMultipartUploads.html>` S3 API operation.

Versioning and Retention
~~~~~~~~~~~~~~~~~~~~~~~~

.. policy-action:: s3:PutBucketVersioning
   
   Controls access to the :s3-api:`PutBucketVersioning <API_PutBucketVersioning.html>` S3 API operation.

.. policy-action:: s3:GetBucketVersioning
   
   Controls access to the :s3-api:`GetBucketVersioning <API_GetBucketVersioning.html>` S3 API operation.

.. policy-action:: s3:DeleteObjectVersion
   
   Controls access to the :s3-api:`DeleteObjectVersion <API_DeleteObjectVersion.html>` S3 API operation.

   Supports the following additional :ref:`condition keys <minio-policy-conditions>`:

   .. code-block:: shell

      s3:versionid   
      s3:ExistingObjectTag/<key>   


.. policy-action:: s3:ListBucketVersions

   Controls access to the :s3-api:`ListBucketVersions <API_ListBucketVersions.html>` S3 API operation.

   Supports the following additional :ref:`condition keys <minio-policy-conditions>`:

   .. code-block:: shell

      s3:prefix   
      s3:delimiter   
      s3:max-keys   
 
.. policy-action:: s3:PutObjectVersionTagging

   Controls access to the :s3-api:`PutObjectVersionTagging <API_PutObjectVersionTagging.html>` S3 API operation.

   Supports the following additional :ref:`condition keys <minio-policy-conditions>`:

   .. code-block:: shell

      s3:versionid   
      s3:ExistingObjectTag/<key>   
      s3:RequestObjectTagKeys   
      s3:RequestObjectTag/<key>   

.. policy-action:: s3:GetObjectVersionTagging

   Controls access to the :s3-api:`GetObjectVersionTagging <API_GetObjectVersionTagging.html>` S3 API operation.

   Supports the following additional :ref:`condition keys <minio-policy-conditions>`:

   .. code-block:: shell

      s3:versionid   
      s3:ExistingObjectTag/<key>

.. policy-action:: s3:DeleteObjectVersionTagging
   
   Controls access to the :s3-api:`DeleteObjectVersionTagging <API_DeleteObjectVersionTagging.html>`  S3 API operation.

   Supports the following additional :ref:`condition keys <minio-policy-conditions>`:

   .. code-block:: shell

      s3:versionid   
      s3:ExistingObjectTag/<key>   


.. policy-action:: s3:GetObjectVersion
   
   Controls access to the :s3-api:`GetObjectVersion <API_GetObjectVersion.html>`  S3 API operation.


   Supports the following additional :ref:`condition keys <minio-policy-conditions>`:

   .. code-block:: shell

      s3:versionid   
      s3:ExistingObjectTag/<key>   

.. policy-action:: s3:BypassGovernanceRetention
   
   Controls access to the following S3 API operations on objects locked under :mc-cmd:`GOVERNANCE <mc retention set MODE>` retention mode:
  
   - ``s3:PutObjectRetention`` 
   - ``s3:PutObject`` 
   - ``s3:DeleteObject`` 
   
   See the S3 documentation on :s3-docs:`s3:BypassGovernanceRetention <object-lock-managing.html#object-lock-managing-bypass>` for more information.

   Supports the following additional :ref:`condition keys <minio-policy-conditions>`:

   .. code-block:: shell

      s3:versionid   
      s3:object-lock-remaining-retention-days   
      s3:object-lock-retain-until-date   
      s3:object-lock-mode   
      s3:object-lock-legal-hold   
      s3:RequestObjectTagKeys   
      s3:RequestObjectTag/<key>   

.. policy-action:: s3:PutObjectRetention
   
   Controls access to the :s3-api:`PutObjectRetention <API_PutObjectRetention.html>`  S3 API operation.

   Required for any ``PutObject`` operation that specifies :ref:`retention metadata <minio-object-locking>`.

   Supports the following additional :ref:`condition keys <minio-policy-conditions>`:

   .. code-block:: shell

      s3:x-amz-server-side-encryption   
      s3:x-amz-server-side-encryption-customer-algorithm   
      s3:x-amz-object-lock-remaining-retention-days   
      s3:x-amz-object-lock-retain-until-date   
      s3:x-amz-object-lock-mode   
      s3:versionid   

.. policy-action:: s3:GetObjectRetention
   
   Controls access to the :s3-api:`GetObjectRetention <API_GetObjectRetention.html>` S3 API operation.

   Required for including :ref:`object locking metadata <minio-object-locking>` as part of the response to a ``GetObject`` or ``HeadObject`` operation.

   Supports the following additional :ref:`condition keys <minio-policy-conditions>`:

   .. code-block:: shell

      s3:x-amz-server-side-encryption   
      s3:x-amz-server-side-encryption-customer-algorithm   
      s3:versionid

.. policy-action:: s3:GetObjectLegalHold
   
   Controls access to the :s3-api:`GetObjectLegalHold <API_GetObjectLegalHold.html>` S3 API operation.

   Required for including :ref:`object locking metadata <minio-object-locking>` as part of the response to a ``GetObject`` or ``HeadObject`` operation.

.. policy-action:: s3:PutObjectLegalHold
   
   Controls access to the :s3-api:`PutObjectLegalHold <API_PutObjectLegalHold.html>` S3 API operation.

   Required for any ``PutObject`` operation that specifies :ref:`legal hold metadata <minio-object-locking>`.

   Supports the following additional :ref:`condition keys <minio-policy-conditions>`:

   .. code-block:: shell

      s3:x-amz-server-side-encryption   
      s3:x-amz-server-side-encryption-customer-algorithm   
      s3:object-lock-legal-hold   
      s3:versionid   

.. policy-action:: s3:GetBucketObjectLockConfiguration
   
   Controls access to the :s3-api:`GetObjectLockConfiguration <API_GetObjectLockConfiguration.html>` S3 API operation.

.. policy-action:: s3:PutBucketObjectLockConfiguration
   
   Controls access to the :s3-api:`PutObjectLockConfiguration <API_PutObjectLockConfiguration.html>` S3 API operation.

Bucket Notifications
~~~~~~~~~~~~~~~~~~~~

.. policy-action:: s3:GetBucketNotification
   
   Controls access to the :s3-api:`GetBucketNotification <API_GetBucketNotification.html>` S3 API operation.

.. policy-action:: s3:PutBucketNotification
   
   Controls access to the :s3-api:`PutBucketNotification <API_PutBucketNotification.html>` S3 API operation.

.. policy-action:: s3:ListenNotification
  
   MinIO Extension for controlling API operations related to MinIO Bucket Notifications. 

   This action is **not** intended for use with other S3-compatible services.

.. policy-action:: s3:ListenBucketNotification

   MinIO Extension for controlling API operations related to MinIO Bucket Notifications. 

   This action is **not** intended for use with other S3-compatible services.

Object Lifecycle Management
~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. policy-action:: s3:PutLifecycleConfiguration
   
   Controls access to the :s3-api:`PutLifecycleConfiguration <API_PutBucketLifecycleConfiguration.html>` S3 API operation.

.. policy-action:: s3:GetLifecycleConfiguration
   
   Controls access to the :s3-api:`GetLifecycleConfiguration <API_GetBucketLifecycleConfiguration.html>` S3 API operation.

Object Encryption
~~~~~~~~~~~~~~~~~

.. policy-action:: s3:PutEncryptionConfiguration
   
   Controls access to the :s3-api:`PutEncryptionConfiguration <API_PutBucketEncryption.html>` S3 API operation.

.. policy-action:: s3:GetEncryptionConfiguration
   
   Controls access to the :s3-api:`GetEncryptionConfiguration <API_GetBucketEncryption.html>` S3 API operation.

Bucket Replication
~~~~~~~~~~~~~~~~~~

.. policy-action:: s3:GetReplicationConfiguration
   
   Controls access to the :s3-api:`GetBucketReplication <API_GetBucketReplication.html>` S3 API operation.

.. policy-action:: s3:PutReplicationConfiguration
   
   Controls access to the :s3-api:`PutBucketReplication <PutBucketReplication.html>` S3 API operation.

.. policy-action:: s3:ReplicateObject

   MinIO Extension for controlling API operations related to :ref:`Server-Side Bucket Replication <minio-bucket-replication-serverside>`.

   Required for MinIO server-side replication.

   Supports the following additional :ref:`condition keys <minio-policy-conditions>`:

   .. code-block:: shell

     s3:versionid   
     s3:ExistingObjectTag/<key>   

.. policy-action:: s3:ReplicateDelete

   MinIO Extension for controlling API operations related to :ref:`Server-Side Bucket Replication <minio-bucket-replication-serverside>`.

   Required for synchronizing delete operations as part of MinIO server-side replication.
   
   Supports the following additional :ref:`condition keys <minio-policy-conditions>`:

   .. code-block:: shell

      s3:versionid   
      s3:ExistingObjectTag/<key>   

.. policy-action:: s3:ReplicateTags

   MinIO Extension for controlling API operations related to :ref:`Server-Side Bucket Replication <minio-bucket-replication-serverside>`.

   Required for MinIO server-side replication.
   
   Supports the following additional :ref:`condition keys <minio-policy-conditions>`:

   .. code-block:: shell

      s3:versionid   
      s3:ExistingObjectTag/<key>   

.. policy-action:: s3:GetObjectVersionForReplication

   MinIO Extension for controlling API operations related to :ref:`Server-Side Bucket Replication <minio-bucket-replication-serverside>`.

   Required for MinIO server-side replication.
   
   Supports the following additional :ref:`condition keys <minio-policy-conditions>`:

   .. code-block:: shell

      s3:versionid   
      s3:ExistingObjectTag/<key>   

.. _minio-policy-conditions:
.. _minio-selected-conditional-actions:

Supported S3 Policy Condition Keys
----------------------------------

MinIO policy documents support IAM :iam-docs:`conditional statements <reference_policies_elements_condition.html>`. 

Each condition element consists of :iam-docs:`operators <reference_policies_elements_condition_operators.html>` and condition keys. MinIO supports a subset of IAM condition keys. 
For complete information on any listed condition key, see the :iam-docs:`IAM Condition Element Documentation <reference_policies_elements_condition.html>`

MinIO supports the following condition keys for all supported 
:ref:`actions <minio-policy-actions>`:

- ``aws:Referer``
- ``aws:SourceIp``
- ``aws:UserAgent``
- ``aws:SecureTransport``
- ``aws:CurrentTime``
- ``aws:EpochTime``
- ``aws:PrincipalType``
- ``aws:userid``
- ``aws:username``
- ``x-amz-content-sha256``
- ``s3:signatureAge``

.. warning:: 

   The ``aws:Referer``, ``aws:SourceIp``, and ``aws.UserAgent`` keys may be easily spoofed and therefore pose a potential security risk.
   MinIO recommends only using these condition keys to *deny* access as a secondary security measure.
   
   **Never** use these three keys to grant access by themselves.

For additional keys supported by a specific S3 action, see the reference documentation for that action.

MinIO Extended Condition Keys
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO extends the S3 standard condition keys with the following extended key:

``sts:DurationSeconds``

   .. versionadded:: MinIO SERVER RELEASE.2024-02-06T21-36-22Z

   Specify a time in seconds to limit the duration of *all* Security Token Service credentials generated by :ref:`minio-sts-assumerolewithwebidentity`.

   This value overrides the ``DurationSeconds`` field specified to the client.

   For example:

   .. code-block:: json

      {
         "Version": "2012-10-17",
         "Statement": [
            {
                  "Effect": "Allow",
                  "Action": [
                     "sts:AssumeRoleWithWebIdentity"
                  ],
                  "Condition": {
                     "NumericLessThanEquals": {
                        "sts:DurationSeconds": "300"
                     }
                  }
            }
         ]
      }

.. _minio-policy-mc-admin-actions:

``mc admin`` Policy Action Keys
-------------------------------

MinIO supports the following actions for use with defining policies
for :mc:`mc admin` operations. These actions are *only* valid for
MinIO deployments and are *not* intended for use with other S3-compatible
services:

.. policy-action:: admin:*

   Selector for all admin action keys.

.. policy-action:: admin:Heal

   Allows heal command

.. policy-action:: admin:StorageInfo

   Allows listing server info

.. policy-action:: admin:DataUsageInfo

   Allows listing data usage info

.. policy-action:: admin:TopLocksInfo

   Allows listing top locks

.. policy-action:: admin:Profiling

   Allows profiling

.. policy-action:: admin:ServerTrace

   Allows listing server trace

.. policy-action:: admin:ConsoleLog

   Allows listing console logs on terminal

.. policy-action:: admin:KMSCreateKey

   Allows creating a new KMS master key

.. policy-action:: admin:KMSKeyStatus

   Allows getting KMS key status

.. policy-action:: admin:ServerInfo

   Allows listing server info

.. policy-action:: admin:OBDInfo

   Allows obtaining cluster on-board diagnostics

.. policy-action:: admin:ServerUpdate

   Allows MinIO binary update

.. policy-action:: admin:ServiceRestart

   Allows restart of MinIO service.

.. policy-action:: admin:ServiceStop

   Allows stopping MinIO service.

.. policy-action:: admin:ConfigUpdate

   Allows MinIO config management

.. policy-action:: admin:CreateUser

   Allows creating MinIO user

.. policy-action:: admin:DeleteUser

   Allows deleting MinIO user

.. policy-action:: admin:ListUsers

   Allows list users permission

.. policy-action:: admin:EnableUser

   Allows enable user permission

.. policy-action:: admin:DisableUser

   Allows disable user permission

.. policy-action:: admin:GetUser

   Allows GET permission on user info

.. policy-action:: admin:AddUserToGroup

   Allows adding user to group permission

.. policy-action:: admin:RemoveUserFromGroup

   Allows removing user to group permission

.. policy-action:: admin:GetGroup

   Allows getting group info

.. policy-action:: admin:ListGroups

   Allows list groups permission

.. policy-action:: admin:EnableGroup

   Allows enable group permission

.. policy-action:: admin:DisableGroup

   Allows disable group permission

.. policy-action:: admin:CreatePolicy

   Allows create policy permission

.. policy-action:: admin:DeletePolicy

   Allows delete policy permission

.. policy-action:: admin:GetPolicy

   Allows get policy permission

.. policy-action:: admin:AttachUserOrGroupPolicy

   Allows attaching a policy to a user/group

.. policy-action:: admin:ListUserPolicies

   Allows listing user policies

.. policy-action:: admin:CreateServiceAccount

   Allows creating MinIO Access Key

.. policy-action:: admin:UpdateServiceAccount

   Allows updating MinIO Access Key

.. policy-action:: admin:RemoveServiceAccount

   Allows deleting MinIO Access Key

.. policy-action:: admin:ListServiceAccounts

   Allows listing MinIO Access Key

.. policy-action:: admin:SetBucketQuota

   Allows setting bucket quota

.. policy-action:: admin:GetBucketQuota

   Allows getting bucket quota

.. policy-action:: admin:SetBucketTarget

   Allows setting bucket target

.. policy-action:: admin:GetBucketTarget

   Allows getting bucket targets

.. policy-action:: admin:SetTier

   Allows creating and modifying remote storage tiers using the 
   :mc:`mc ilm tier` commands.

.. policy-action:: admin:ListTier

   Allows listing configured remote storage tiers using the
   :mc:`mc ilm tier` commands.

.. policy-action:: admin:BandwidthMonitor

   Allows retrieving metrics related to current bandwidth consumption.

.. policy-action:: admin:Prometheus

   Allows access to MinIO :ref:`metrics <minio-metrics-and-alerts>`. 
   Only required if MinIO requires authentication for scraping metrics.

.. policy-action:: admin:ListBatchJobs

   Allows access to list the active batch jobs.

.. policy-action:: admin:DescribeBatchJobs

   Allows access to the see the definition details of a running batch job.

.. policy-action:: admin:StartBatchJob

   Allows user to begin a batch job run.

.. policy-action:: admin:CancelBatchJob

   Allows user to stop a batch job currently in process.
   
.. policy-action:: admin:Rebalance

   Allows access to start, query, or stop a rebalancing of objects across pools with varying free storage space.

``mc admin`` Policy Condition Keys
----------------------------------

MinIO supports the following conditions for use with defining policies for
:mc:`mc admin` :ref:`actions <minio-policy-mc-admin-actions>`.

- ``aws:Referer``
- ``aws:SourceIp``
- ``aws:UserAgent``
- ``aws:SecureTransport``
- ``aws:CurrentTime``
- ``aws:EpochTime``

For complete information on any listed condition key, see the :iam-docs:`IAM Condition Element Documentation <reference_policies_elements_condition.html>`.

Policy Variables
----------------

MinIO supports using policy variables for automatically substituting context from the authenticated user and/or the operation into the user's assigned policy or policies.
Use the ``${POLICYVARIABLE}`` format to specify the variable to the policy as part of the ``Condition`` or ``Resource`` definition.
MinIO policy variables function similarly to :iam-docs:`AWS IAM policy elements: Variables and tags <reference_policies_variables.html>`.

Each MinIO :ref:`identity provider <minio-authentication-and-identity-management>` supports its own set of policy variables:

- :ref:`minio-policy-variables-internal`
- :ref:`minio-policy-variables-oidc`
- :ref:`minio-policy-variables-ad-ldap`

.. _minio-policy-variables-internal:

MinIO Policy Variables
~~~~~~~~~~~~~~~~~~~~~~

The following table contains a list of recommended policy variables for use in authorizing :ref:`MinIO-managed users <minio-internal-idp>`:

.. list-table::
   :header-rows: 1
   :widths: 40 60
   :width: 100%

   * - Variable
     - Description

   * - :iam-docs:`aws:referrer <reference_policies_condition-keys.html#condition-keys-referer>`
     - The referrer in the HTTP header for the authenticated API call.

   * - :iam-docs:`aws:SourceIp <reference_policies_condition-keys.html#condition-keys-sourceip>`
     - The source IP in the HTTP header for the authenticated API call.

   * - :iam-docs:`aws:username <reference_policies_condition-keys.html#condition-keys-username>`
     - The name of the user associated with the authenticated API call.

For example, the following policy uses variables to substitute the authenticated user's username as part of the ``Resource`` field such that the user can only access those prefixes which match their username:

.. code-block:: json

   {
   "Version": "2012-10-17",
   "Statement": [
         {
            "Action": ["s3:ListBucket"],
            "Effect": "Allow",
            "Resource": ["arn:aws:s3:::mybucket"],
            "Condition": {"StringLike": {"s3:prefix": ["${aws:username}/*"]}}
         },
         {
            "Action": [
            "s3:GetObject",
            "s3:PutObject"
            ],
            "Effect": "Allow",
            "Resource": ["arn:aws:s3:::mybucket/${aws:username}/*"]
         }
      ]
   }

MinIO replaces the ``${aws:username}`` variable in the ``Resource`` field with the username.
MinIO then evaluates the policy and grants or revokes access to the requested API and resource.

.. _minio-policy-variables-oidc:

OpenID Policy Variables
~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/common/common-minio-oidc.rst
   :start-after: start-minio-oidc-policy-variables
   :end-before: end-minio-oidc-policy-variables

.. _minio-policy-variables-ad-ldap:

Active Directory / LDAP Policy Variables
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following table contains a list of supported policy variables for use in authorizing :ref:`AD/LDAP users <minio-external-identity-management-ad-ldap>`:

.. list-table::
   :header-rows: 1
   :widths: 40 60
   :width: 100%

   * - Variable
     - Description

   * - ``ldap:username``
     - The simple username (``name``) for the authenticated user.
         This is distinct from the user's DistinguishedName or CommonName.

   * - ``ldap:user``
     - The Distinguished Name used by the authenticated user.

   * - ``ldap:groups``
     - The Group Distinguished Name for the authenticated user.

For example, the following policy uses variables to substitute the authenticated user's ``name`` as part of the ``Resource`` field such that the user can only access those prefixes which match their name:

.. code-block:: json

   {
   "Version": "2012-10-17",
   "Statement": [
         {
            "Action": ["s3:ListBucket"],
            "Effect": "Allow",
            "Resource": ["arn:aws:s3:::mybucket"],
            "Condition": {"StringLike": {"s3:prefix": ["${ldap:username}/*"]}}
         },
         {
            "Action": [
            "s3:GetObject",
            "s3:PutObject"
            ],
            "Effect": "Allow",
            "Resource": ["arn:aws:s3:::mybucket/${ldap:username}/*"]
         }
      ]
   }

MinIO replaces the ``${ldap:username}`` variable in the ``Resource`` field with the value of the authenticated user's ``name``.
MinIO then evaluates the policy and grants or revokes access to the requested API and resource.
