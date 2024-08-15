.. _minio-mc-ilm-tier-update:

======================
``mc ilm tier update``
======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc ilm tier update

.. versionchanged:: RELEASE.2022-12-24T15-21-38Z

   :mc-cmd:`mc ilm tier update` replaces ``mc admin tier edit``.

Description
-----------

.. start-mc-ilm-tier-update-desc

The :mc:`mc ilm tier update` command modifies an existing configured remote tier. 

.. end-mc-ilm-tier-update-desc

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only

Supported S3 Services
~~~~~~~~~~~~~~~~~~~~~

:mc:`mc ilm tier` supports *only* the following S3-compatible services as a remote target for object tiering:

- MinIO
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

.. tab-set::

   .. tab-item:: EXAMPLE

      The following example updates the credentials for an existing remote tier called ``S3TIER`` on the ``myminio`` deployment.
      
      .. code-block:: shell
         :class: copyable

          mc ilm tier update myminio S3TIER --access-key ACCESS_KEY --secret-key SECRET_KEY  

      After running this command, lifecycle management rules on the ``myminio`` deployment use the tier's new credentials to transition objects into the remote location.
      Options not modified in the command maintain their existing configurations.

   .. tab-item:: SYNTAX
   
      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc ilm tier update TARGET                         \
                            TIER_NAME                      \
                            [--account-key value]          \
                            [--access-key value]           \
                            [--az-sp-tenant-id value]      \
                            [--az-sp-client-id value]      \
                            [--az-sp-client-secret value]  \
                            [--secret-key value]           \
                            [--use-aws-role]               \
                            [--credentials-file value] 

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

The command accepts the following arguments:
      
.. mc-cmd:: TARGET
   :required:

   The :mc-cmd:`alias <mc alias>` of a configured MinIO deployment.

.. mc-cmd:: TIER_NAME
   :required:

   The name of the remote tier the command modifies. 
   The value corresponds to the :mc-cmd:`mc ilm tier add TIER_NAME` specified when creating the remote tier.

.. mc-cmd:: --access-key
   :optional:
      
   The access key for a user on the remote S3 or MinIO tier. 
   The user must have permission to perform read/write/list/delete operations on the remote bucket or bucket prefix.

   This option only applies to remote storage tiers with :mc-cmd:`~mc ilm tier add TIER_TYPE` is ``s3`` or ``minio``. 
   This option has no effect for any other ``TIER_TYPE``.

.. mc-cmd:: --secret-key
   :optional:   

   The secret key for a user on the remote ``s3`` or ``minio`` tier.

   This option only applies to remote storage tiers with :mc-cmd:`~mc ilm tier add TIER_TYPE` is ``s3`` or ``minio``. 
   This option has no effect for any other ``TIER_TYPE``.

.. mc-cmd:: --use-aws-role
   :optional:

   Use the access permission for the locally configured :iam-docs:`AWS Role <id_roles.html>`.

   This option only applies if :mc-cmd:`~mc ilm tier add TIER_TYPE` is ``s3`` or ``minio``.
   This option has no effect for any other value of ``TIER_TYPE``.

.. mc-cmd:: --account-key
   :optional:
      
   The account key for a user on a remote Azure tier.

   **Required** for Azure tier types.
   
   Use this option to rotate the credentials for the :mc-cmd:`~mc ilm tier add --account-name` associated to the remote tier.

   This option only applies to remote storage tiers with :mc-cmd:`~mc ilm tier add TIER_TYPE` is ``azure``. 
   This option has no effect for any other type of login.

.. mc-cmd:: --az-sp-tenant-id
   :optional:

   .. versionadded:: mc RELEASE.2024-07-03T20-17-25Z 

   Directory ID for the Azure service principal account.

   This option only applies to remote storage tiers with :mc-cmd:`~mc ilm tier add TIER_TYPE` is ``azure``. 
   This option has no effect for any other type of login.

.. mc-cmd:: --az-sp-client-id
   :optional:

   .. versionadded:: mc RELEASE.2024-07-03T20-17-25Z 

   Client ID of the Azure service principal account.

   Requires :mc-cmd:`~mc ilm tier update --az-sp-client-secret`.

   This option only applies to remote storage tiers with :mc-cmd:`~mc ilm tier add TIER_TYPE` is ``azure``. 
   This option has no effect for any other type of login.

.. mc-cmd:: --az-sp-client-secret
   :optional:

   .. versionadded:: mc RELEASE.2024-07-03T20-17-25Z 

   The secret for the Azure service principal account.

   Requires :mc-cmd:`~mc ilm tier update --az-sp-client-id`.

   This option only applies to remote storage tiers with :mc-cmd:`~mc ilm tier add TIER_TYPE` is ``azure``. 
   This option has no effect for any other type of login.

.. mc-cmd:: --credentials-file
   :optional:
      
   **Required** for Google Cloud Storage tier types.
      
   The credential file for a user on the remote GCS tier. 
   The user must have permission to perform read/write/list/delete operations on the remote bucket or bucket prefix.
      
   This option only applies to remote storage tiers with :mc-cmd:`~mc ilm tier add TIER_TYPE` is ``gcs``. 
   This option has no effect for any other type of login.
   
Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Rotate Credentials for an S3 Remote Tier
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following example updates the credentials for an S3 remote tier called ``S3TIER`` on the ``myminio`` deployment.

.. code-block:: shell
   :class: copyable

   mc ilm tier update myminio S3TIER --access-key ACCESS_KEY --secret-key SECRET_KEY   

- Replace ``S3TIER`` with the name for your Amazon Simple Storage Solution tier.
- Replace ``ACCESS_KEY`` with the updated access key for your S3 storage.
- Replace ``SECRET_KEY`` with the updated secret key for the access key provided.

Rotate Credentials for an Azure Blob Storage Remote Tier
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following example updates the credentials for an Azure remote tier called ``AXTIER`` on the ``myminio`` deployment.

.. code-block:: shell
   :class: copyable

   mc ilm tier update myminio AZTIER --account-key ACCOUNT-KEY  

- Replace ``AZTIER`` with the name for your Azure tier.
- Replace ``ACCOUNT-KEY`` with the updated key for your Azure storage.

Rotate Credentials for a Google Cloud Storage Remote Tier
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following example updates the credentials for a Google Cloud Storage remote tier called ``GCSTIER`` on the ``myminio`` deployment.

.. code-block:: shell
   :class: copyable

    mc ilm tier update myminio GCSTIER --credentials-file /path/to/credentials.json    


- Replace ``GCSTIER`` with the name for your Google Cloud Storage tier.
- Replace ``/path/to/credentials.json`` with the path of the updated credential file to use to access the remote storage.


S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility

Required Permissions
--------------------

For permissions required to modify a tier, refer to the :ref:`required permissions <minio-mc-ilm-tier-permissions>` on the parent command.