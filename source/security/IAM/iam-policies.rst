.. _minio-policy:

========
Policies
========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

Overview
--------

A *policy* is a document that describes the resources and operations to which
a MinIO :ref:`user <minio-users>` or the members of a :ref:`group 
<minio-groups>` have access. 

MinIO uses Policy-Based Access Control (PBAC) to define the *authorized*
resources and operations to which a :ref:`user <minio-users>` or members of a
:ref:`group <minio-groups>` have access. 

MinIO by default *denies* access to any
resource or operation not explicitly allowed by a user's assigned or inherited
policies.

MinIO PBAC uses AWS IAM-compatible JSON
syntax for defining policies. For example, MinIO can use IAM policies designed
for use with AWS S3 or S3-compatible services.

The MinIO documentation makes a best-effort to cover IAM-specific behavior and
functionality. Consider deferring to the :iam-docs:`IAM documentation <>` for
more complete documentation on IAM, IAM policies, or IAM JSON syntax.

.. _minio-policy-built-in:

Built-In Policies
-----------------

MinIO provides the following built-in policies for assigning to 
:ref:`users <minio-users>` or :ref:`groups <minio-groups>`:

.. userpolicy:: readonly

   Grants read-only permissions for all buckets and objects on the MinIO server.

.. userpolicy:: readwrite

   Grants read and write permissions for all buckets and objects on the
   MinnIO server.

.. userpolicy:: diagnostics

   Grants permission to perform diagnostic actions on the MinIO server.

.. userpolicy:: writeonly

   Grants write-only permissions for all buckets and objects on the MinIO 
   server.

Use :mc-cmd:`mc admin policy set` to associate a policy to a 
user or group on a MinIO deployment.

.. _minio-policy-document:

Policy Document Structure
-------------------------

MinIO policy documents use the same schema as 
:aws-docs:`AWS IAM Policy <IAM/latest/UserGuide/access.html>` documents.

The following sample document provides a template for creating custom
policies for use with a MinIO deployment. For more complete documentation on IAM
policy elements, see the :aws-docs:`IAM JSON Policy Elements Reference
<IAM/latest/UserGuide/reference_policies_elements.html>`. 

.. code-block:: javascript
   :class: copyable

   {
      "Version" : "2012-10-17",
      "Statement" : [
         {
            "Effect" : "Allow",
            "Action" : [ "s3:<ActionName>", ... ],
            "Resource" : "arn:minio:s3:::*",
            "Condition" : { ... }
         },
         {
            "Effect" : "Deny",
            "Action" : [ "s3:<ActionName>", ... ],
            "Resource" : "arn:minio:s3:::*",
            "Condition" : { ... }
         }
      ]
   }

- For the ``Statement.Action`` array, specify one or more 
  :ref:`supported S3 actions <minio-policy-actions>`. MinIO deployments
  supports a subset of AWS S3 actions.

- For the ``Statement.Resource`` key, you can replace the ``*`` with 
  the specific bucket to which the policy statement should apply. 
  Using ``*`` applies the statement to all resources on the MinIO deployment.

- For the ``Statement.Condition`` key, you can specify one or more 
  :ref:`supported Conditions <minio-policy-conditions>`. MinIO
  deployments supports a subset of AWS S3 conditions.

.. _minio-policy-actions:

Supported S3 Policy Actions
---------------------------

MinIO policy documents support a subset of IAM 
:iam-docs:`S3 Action keys <list_amazons3.html#amazons3-actions-as-permissions>`. 

The following table lists the MinIO-supported policy action keys.

.. policy-action:: s3:*
   
   Selector for all supported S3 actions.

.. policy-action:: s3:AbortMultipartUpload
   
   Corresponds to the :s3-api:`s3:AbortMultipartUpload
   <API_AbortMultipartUpload.html>` IAM action.

.. policy-action:: s3:CreateBucket
   
   Corresponds to the :s3-api:`s3:CreateBucket <API_CreateBucket.html>` IAM
   action.

.. policy-action:: s3:DeleteBucket
   
   Corresponds to the :s3-api:`s3:DeleteBucket <API_DeleteBucket.html>` IAM
   action.

.. policy-action:: s3:ForceDeleteBucket
   
   Corresponds to the :s3-api:`s3:DeleteBucket <API_ForceDeleteBucket.html>`
   IAM action for operations with the ``x-minio-force-delete`` flag.

.. policy-action:: s3:DeleteBucketPolicy
   
   Corresponds to the :s3-api:`s3:DeleteBucketPolicy
   <API_DeleteBucketPolicy.html>` IAM action.

.. policy-action:: s3:DeleteObject
   
   Corresponds to the :s3-api:`s3:DeleteObject <API_DeleteObject.html>` IAM
   action.

.. policy-action:: s3:GetBucketLocation
   
   Corresponds to the :s3-api:`s3:GetBucketLocation
   <API_GetBucketLocation.html>` IAM action.

.. policy-action:: s3:GetBucketNotification
   
   Corresponds to the :s3-api:`s3:GetBucketNotification
   <API_GetBucketNotification.html>` IAM action.

.. policy-action:: s3:GetBucketPolicy
   
   Corresponds to the :s3-api:`s3:GetBucketPolicy <API_GetBucketPolicy.html>`
   IAM action.

.. policy-action:: s3:GetObject
   
   Corresponds to the :s3-api:`s3:GetObject <API_GetObject.html>` IAM action.

.. policy-action:: s3:HeadBucket
   
   Corresponds to the :s3-api:`s3:HeadBucket <API_HeadBucket.html>` IAM action.
       
  *This action is unused in MinIO.*

.. policy-action:: s3:ListAllMyBuckets
   
   Corresponds to the :s3-api:`s3:ListAllMyBuckets <API_ListAllMyBuckets.html>`
   IAM action.

.. policy-action:: s3:ListBucket
   
   Corresponds to the :s3-api:`s3:ListBucket <API_ListBucket.html>` IAM action.

.. policy-action:: s3:ListMultipartUploads
   
   Corresponds to the :s3-api:`s3:ListMultipartUploads
   <API_ListMultipartUploads.html>` IAM action.

.. policy-action:: s3:ListenNotification
  
   MinIO Extension for controlling API operations related to MinIO Bucket
   Notifications. 

   This action is **not** intended for use with other S3-compatible services.

.. policy-action:: s3:ListenBucketNotification

   MinIO Extension for controlling API operations related to MinIO Bucket
   Notifications. 

   This action is **not** intended for use with other S3-compatible services.

.. policy-action:: s3:ListParts
   
   Corresponds to the :s3-api:`s3:ListParts <API_ListParts.html>` IAM action.

.. policy-action:: s3:PutBucketLifecycle
   
   Corresponds to the :s3-api:`s3:PutBucketLifecycle
   <API_PutBucketLifecycle.html>` IAM action.

.. policy-action:: s3:GetBucketLifecycle
   
   Corresponds to the :s3-api:`s3:GetBucketLifecycle
   <API_GetBucketLifecycle.html>` IAM action.

.. policy-action:: s3:PutObjectNotification
   
   Corresponds to the :s3-api:`s3:PutObjectNotification
   <API_PutObjectNotification.html>` IAM action.

.. policy-action:: s3:PutBucketPolicy
   
   Corresponds to the :s3-api:`s3:PutBucketPolicy <API_PutBucketPolicy.html>`
   IAM action.

.. policy-action:: s3:PutObject
   
   Corresponds to the :s3-api:`s3:PutObject <API_PutObject.html>` IAM action.

.. policy-action:: s3:DeleteObjectVersion
   
   Corresponds to the :s3-api:`s3:DeleteObjectVersion
   <API_DeleteObjectVersion.html>` IAM action.

.. policy-action:: s3:DeleteObjectVersionTagging
   
   Corresponds to the :s3-api:`s3:DeleteObjectVersionTagging
   <API_DeleteObjectVersionTagging.html>`  IAM action.

.. policy-action:: s3:GetObjectVersion
   
   Corresponds to the :s3-api:`s3:GetObjectVersion
   <API_GetObjectVersion.html>`  IAM action.

.. policy-action:: s3:GetObjectVersionTagging
   
   Corresponds to the :s3-api:`s3:GetObjectVersionTagging
   <API_GetObjectVersionTagging.html>`  IAM action.

.. policy-action:: s3:PutObjectVersionTagging
   
   Corresponds to the :s3-api:`s3:PutObjectVersionTagging
   <API_PutObjectVersionTagging.html>`  IAM action.

.. policy-action:: s3:BypassGovernanceRetention
   
   Corresponds to the :s3-docs:`s3:BypassGovernanceRetention
   <object-lock-managing.html#object-lock-managing-bypass>` IAM action.

   This action applies to the following API operations on objects locked under
   :mc-cmd:`GOVERNANCE <mc retention set MODE>` retention mode:
  
   - ``PutObjectRetention`` 
   - ``PutObject`` 
   - ``DeleteObject``

.. policy-action:: s3:PutObjectRetention
   
   Corresponds to the :s3-api:`s3:PutObjectRetention
   <API_PutObjectRetention.html>`  IAM action.

.. policy-action:: s3:GetObjectRetention
   
   Corresponds to the :s3-api:`s3:GetObjectRetention
   <API_GetObjectRetention.html>` IAM action.

   This action applies to the following API operations on objects locked under
   any retention mode:

   - ``GetObject`` 
   - ``HeadObject``

.. policy-action:: s3:GetObjectLegalHold
   
   Corresponds to the :s3-api:`s3:GetObjectLegalHold
   <API_GetObjectLegalHold.html>` IAM action.

   This action applies to the following API operations on objects locked under
   legal hold:

   - ``GetObject``

.. policy-action:: s3:PutObjectLegalHold
   
   Corresponds to the :s3-api:`s3:PutObjectLegalHold
   <API_PutObjectLegalHold.html>` IAM action.

   This action applies to the following API operations on objects locked
   under legal hold:

   - ``PutObject``

.. policy-action:: s3:GetBucketObjectLockConfiguration
   
   Corresponds to the :s3-api:`s3:GetBucketObjectLockConfiguration
   <API_GetBucketObjectLockConfiguration.html>` IAM action.

.. policy-action:: s3:PutBucketObjectLockConfiguration
   
   Corresponds to the :s3-api:`s3:PutBucketObjectLockConfiguration 
   <API_PutBucketObjectLockConfiguration.html>` IAM action.

.. policy-action:: s3:GetBucketTagging
   
   Corresponds to the :s3-api:`s3:GetBucketTagging <API_GetBucketTagging.html>`
   IAM action.

.. policy-action:: s3:PutBucketTagging
   
   Corresponds to the :s3-api:`s3:PutBucketTagging <API_PutBucketTagging.html>`
   IAM action.

.. policy-action:: s3:Get
   
   Corresponds to the :s3-api:`s3:Get <API_Get.html>` IAM action.

.. policy-action:: s3:Put
   
   Corresponds to the :s3-api:`s3:Put <API_Put.html>` IAM action.

.. policy-action:: s3:Delete
   
   Corresponds to the :s3-api:`s3:Delete <API_Delete.html>` IAM action.

.. policy-action:: s3:PutBucketEncryption
   
   Corresponds to the :s3-api:`s3:PutBucketEncryption
   <API_PutBucketEncryption.html>` IAM action.

.. policy-action:: s3:GetBucketEncryption
   
   Corresponds to the :s3-api:`s3:GetBucketEncryption
   <API_GetBucketEncryption.html>` IAM action.

.. policy-action:: s3:PutBucketVersioning
   
   Corresponds to the :s3-api:`s3:PutBucketVersioning
   <API_PutBucketVersioning.html>` IAM action.

.. policy-action:: s3:GetBucketVersioning
   
   Corresponds to the :s3-api:`s3:GetBucketVersioning
   <API_GetBucketVersioning.html>` IAM action.

.. policy-action:: s3:GetReplicationConfiguration
   
   Corresponds to the :s3-api:`s3:GetReplicationConfiguration 
   <API_GetReplicationConfiguration.html>` IAM action.

.. policy-action:: s3:PutReplicationConfiguration
   
   Corresponds to the :s3-api:`s3:PutReplicationConfiguration
   <PutReplicationConfiguration.html>` IAM action.

.. policy-action:: s3:ReplicateObject
   
   Corresponds to the :s3-api:`s3:ReplicateObject <API_ReplicateObject.html>`
   IAM action.

.. policy-action:: s3:ReplicateDelete
   
   Corresponds to the :s3-api:`s3:ReplicateDelete <API_ReplicateDelete.html>`
   IAM action.

.. policy-action:: s3:ReplicateTags
   
   Corresponds to the :s3-api:`s3:ReplicateTags <API_ReplicateTags.html>` IAM
   action.

.. policy-action:: s3:GetObjectVersionForReplication
   
   Corresponds to the :s3-api:`s3:GetObjectVersionForReplication 
   <API_GetObjectVersionForReplication.html>` IAM action.


.. _minio-policy-mc-admin-actions:

``mc admin`` Policy Action Keys
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports the following actions for use with defining policies
for :mc-cmd:`mc admin` operations. These actions are *only* valid for
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

.. policy-action:: admin:CreatePolicy"

   Allows create policy permission

.. policy-action:: admin:DeletePolicy

   Allows delete policy permission

.. policy-action:: admin:GetPolicy

   Allows get policy permission

.. policy-action:: admin:AttachUserOrGroupPolicy

   Allows attaching a policy to a user/group

.. policy-action:: admin:ListUserPolicies

   Allows listing user policies

.. policy-action:: admin:SetBucketQuota

   Allows setting bucket quota

.. policy-action:: admin:GetBucketQuota

   Allows getting bucket quota

.. policy-action:: admin:SetBucketTarget

   Allows setting bucket target

.. policy-action:: admin:GetBucketTarget

   Allows getting bucket targets

.. _minio-policy-conditions:

Supported S3 Policy Condition Keys
----------------------------------

MinIO policy documents support IAM 
:iam-docs:`conditional statements <reference_policies_elements_condition.html>`. 

Each condition element consists of 
:iam-docs:`operators <reference_policies_elements_condition_operators.html>` 
and condition keys. MinIO supports a subset of IAM condition keys. For complete
information on any listed condition key, see the 
:iam-docs:`IAM Condition Element Documentation 
<reference_policies_elements_condition.html>`

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
- ``s3:x-amz-content-sha256``

The following table lists additional supported condition keys for specific
actions:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Action Key
     - Condition Keys

   * - :policy-action:`s3:GetObject`
     - | ``s3:x-amz-server-side-encryption``
       | ``s3:x-amz-server-side-encryption-customer-algorithm``

   * - :policy-action:`s3:ListBucket`
     - | ``s3:prefix``
       | ``s3:delimiter``
       | ``s3:max-keys``

   * - :policy-action:`s3:PutObject`
     - | ``s3:x-amz-copy-source`` 
       | ``s3:x-amz-server-side-encryption``
       | ``s3:x-amz-server-side-encryption-customer-algorithm``
       | ``s3:x-amz-metadata-directive``
       | ``s3:x-amz-storage-class``
       | ``s3:object-lock-retain-until-date``
       | ``s3:object-lock-mode``
       | ``s3:object-lock-legal-hold``

   * - :policy-action:`s3:PutObjectRetention`
     - | ``s3:x-amz-object-lock-remaining-retention-days``
       | ``s3:x-amz-object-lock-retain-until-date``
       | ``s3:x-amz-object-lock-mode``

   * - :policy-action:`s3:PutObjectLegalHold`
     - ``s3:object-lock-legal-hold``

   * - :policy-action:`s3:BypassGovernanceRetention`
     - | ``s3:object-lock-remaining-retention-days``
       | ``s3:object-lock-retain-until-date``
       | ``s3:object-lock-mode``
       | ``s3:object-lock-legal-hold``

   * - :policy-action:`s3:GetObjectVersion`
     - ``s3:versionid``

   * - :policy-action:`s3:GetObjectVersionTagging`
     - ``s3:versionid``

   * - :policy-action:`s3:DeleteObjectVersion`
     - ``s3:versionid``

   * - :policy-action:`s3:DeleteObjectVersionTagging`
     - ``s3:versionid``

``mc admin`` Policy Condition Keys
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports the following conditions for use with defining policies for
:mc-cmd:`mc admin` :ref:`actions <minio-policy-mc-admin-actions>`.

- ``aws:Referer``
- ``aws:SourceIp``
- ``aws:UserAgent``
- ``aws:SecureTransport``
- ``aws:CurrentTime``
- ``aws:EpochTime``

For complete information on any listed condition key, see the :iam-docs:`IAM
Condition Element Documentation <reference_policies_elements_condition.html>`

Creating Custom Policies
------------------------

Use the :mc-cmd:`mc admin policy add` command to add a policy to the MinIO
server. The policy *must* be a valid JSON document formatted according to
IAM policy specifications. For example:

.. code-block:: shell

   mc admin policy add myminio/ new_policy new_policy.json

Use the :mc-cmd:`mc admin policy set` command to associate a policy to a
:ref:`user <minio-users>` or :ref:`group <minio-groups>`.

.. code-block:: shell

   mc admin policy set myminio/ new_policy user=user_name

   mc admin policy set myminio/ new_policy group=group_name

.. note::

   ``myminio`` refers to the :mc-cmd:`alias <mc alias>` of an S3-compatible
   host configured for use with :program:`mc`. See :mc-cmd:`mc alias` for
   more information on aliases.