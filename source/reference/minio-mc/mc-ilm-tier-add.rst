.. _minio-mc-ilm-tier-add:

===================
``mc ilm tier add``
===================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc ilm tier add

.. versionchanged:: RELEASE.2022-12-24T15-21-38Z

   :mc:`mc ilm tier add` replaces ``mc admin tier add``.

Description
-----------

.. start-mc-ilm-tier-add-desc

The :mc:`mc ilm tier add` command creates a new remote storage tier to a supported storage services.

.. end-mc-ilm-tier-add-desc

See :ref:`Object Transition <minio-lifecycle-management-tiering>` for a complete list.

Supported S3 Services
~~~~~~~~~~~~~~~~~~~~~

:mc:`mc ilm tier add` supports *only* the following S3-compatible services as a remote target for object tiering:

- MinIO
- Amazon S3
- Google Cloud Storage
- Azure Blob Storage

Permissions
~~~~~~~~~~~

MinIO requires the following administrative permissions on the cluster in which you create remote tiers for object transition lifecycle management rules:

- :policy-action:`admin:SetTier`
- :policy-action:`admin:ListTier`

For example, the following policy provides permission for configuring object transition lifecycle management rules on any bucket in the cluster: 

.. literalinclude:: /extra/examples/LifecycleManagementAdmin.json
   :language: json
   :class: copyable

Syntax
------

.. tab-set::

   .. tab-item:: EXAMPLE

      The following example creates a new remote tier called ``WARM-MINIO-TIER`` on the ``myminio`` deployment.
      The command creates a tier for a remote MinIO deployment located at the hostname ``https://warm-minio.com``.
      
      .. code-block:: shell
         :class: copyable

          mc ilm tier add minio myminio WARM-MINIO-TIER                     \
                                        --endpoint https://warm-minio.com   \                       
                                        --access-key ACCESSKEY              \
                                        --secret-key SECRETKEY              \
                                        --bucket mybucket                   \
                                        --prefix myprefix/ 

      Lifecycle management rules on the ``myminio`` deployment can use the new tier to transition objects into the remote location's ``myprefix/`` prefix in the ``mybucket`` bucket.

   .. tab-item:: SYNTAX
   
      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc ilm tier add TIER_TYPE                    \
                         TARGET                       \
                         TIER_NAME                    \
                         --bucket value               \
                         [--endpoint string]          \
                         [--region string]            \
                         [--access-key value^]        \
                         [--secret-key value^]        \
                         [--use-aws-role^]            \
                         [--account-name value^]      \
                         [--account-key value^]       \
                         [--credentials-file value^]  \
                         [--prefix value]             \
                         [--storage-class value]

      **^Note:** Each supported storage vendor authenticates with different methods.
      The flags to use for authentication vary by storage vendor.
      See details under :mc-cmd:`~mc ilm tier add TIER_TYPE` below. 

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


Parameters
~~~~~~~~~~

The command accepts the following arguments:

.. mc-cmd:: TIER_TYPE
   :required:

   The Cloud Service Provider storage backend ("Tier") to which MinIO transitions objects. 
   Specify *one* of the following supported values:

   .. list-table::
      :stub-columns: 1
      :width: 100%
      :widths: 30 70

      * - ``minio``
        - Use a remote MinIO deployment as the storage backend for the new Tier.

          Requires also specifying the following parameters:

          - :mc-cmd:`~mc ilm tier add --access-key`
          - :mc-cmd:`~mc ilm tier add --secret-key`

      * - ``s3``
        - Use AWS S3 as the storage backend for the new Tier.

          Requires also specifying the following parameters:

          - :mc-cmd:`~mc ilm tier add --access-key`
          - :mc-cmd:`~mc ilm tier add --secret-key`

      * - ``azure``
        - Use :abbr:`Azure (Microsoft Azure)` Blob Storage as the storage backend for the new Tier.

          Requires also specifying the following parameters:

          - :mc-cmd:`~mc ilm tier add --account-name`
          - :mc-cmd:`~mc ilm tier add --account-key`
         
      * - ``gcs`` 
        - Use :abbr:`GCP (Google Cloud Platform)` Cloud Storage as the storage backend for the new Tier.

          Requires also specifying the following parameter:

          - :mc-cmd:`~mc ilm tier add --credentials-file`

.. mc-cmd:: TARGET
   :required:

   The :mc-cmd:`alias <mc alias>` of a configured MinIO deployment on which the command creates the new remote tier.
   You can then create new rules with :mc:`mc ilm rule add` specifying the new remote tier.
      
.. mc-cmd:: TIER_NAME
   :required:

   The name to associate with the new remote tier. 
   The name **must** be unique across all configured tiers on the MinIO cluster.

   You **must** specify the tier in all-caps, e.g. ``WARM_TIER``.
   
.. mc-cmd:: --endpoint
   :optional:

   The URL endpoint for the S3 or MinIO storage. 
   The URL endpoint **must** resolve to the provider specified to :mc-cmd:`~mc ilm tier add TIER_TYPE`. 

   Required for ``s3`` or ``minio`` tier types.
   This option has no effect for any other value of ``TIER_TYPE``.

.. mc-cmd:: --access-key
   :optional:
      
   The access key for a user on the remote ``S3`` or ``minio`` tier types. 
   The user must have permission to perform read/write/list/delete operations on the remote bucket or bucket prefix.
      
   Required if :mc-cmd:`~mc ilm tier add TIER_TYPE` is ``s3`` or ``minio``. 
   This option has no effect for any other value of ``TIER_TYPE``.

.. mc-cmd:: --secret-key
   :optional:

   The secret key for a user on the remote ``s3`` or ``minio`` tier types.

   Required if :mc-cmd:`~mc ilm tier add TIER_TYPE` is ``s3`` or ``minio``. 
   This option has no effect for any other value of ``TIER_TYPE``.

.. mc-cmd:: --account-name
   :optional:

   The account name for a user on the remote Azure tier. 
   The user must have permission to perform read/write/list/delete operations on the remote bucket or bucket prefix.
      
   Required if :mc-cmd:`~mc ilm tier add TIER_TYPE` is ``azure``. 
   This option has no effect for any other value of ``TIER_TYPE``.

   MinIO does *not* support changing the account name associated to an Azure remote tier. 
   Azure storage backends are tied to the account, such that changing the account would change the storage backend and prevent access to any objects transitioned to the original account/backend.

.. mc-cmd:: --account-key
   :optional:

   The account key for the :mc-cmd:`~mc ilm tier add --account-name` associated to the remote Azure tier.

   Required if :mc-cmd:`~mc ilm tier add TIER_TYPE` is ``azure``. 
   This option has no effect for any other value of ``TIER_TYPE``.

.. mc-cmd:: --credentials-file
   :optional:

   The `credential file <https://cloud.google.com/docs/authentication/getting-started>`__ for a user on the remote Google Cloud Storage tier. 
   The user must have permission to perform read/write/list/delete operations on the remote bucket or bucket prefix.
      
   Required if :mc-cmd:`~mc ilm tier add TIER_TYPE` is ``gcs``. 
   This option has no effect for any other value of ``TIER_TYPE``.

.. mc-cmd:: --bucket
   :required:

   The bucket on the remote tier to which MinIO transitions objects.

   For ``azure`` remote tiers, this value corresponds to the :azure-docs:`Container name <storage/blobs/storage-blobs-introduction#containers>`

.. mc-cmd:: --prefix
   :optional:

   The prefix path for the specified :mc-cmd:`~mc ilm tier add --bucket` to which MinIO transitions objects.

   Omit this field to transition objects into the bucket root.

.. mc-cmd:: --storage-class
   :optional:

   The storage class to apply to objects transitioned by MinIO to the remote bucket.
   The specified storage class varies depending on the ``TIER_TYPE``.
   MinIO object transition *requires* the remote storage class to support immediate retrieval (e.g. no rehydration or manual intervention required).
   
   Select the tab corresponding to the ``TIER_TYPE`` to view the recommended storage classes:

   .. tab-set::

      .. tab-item:: minio

         - ``STANDARD`` *Recommended*
         - ``REDUCED``

      .. tab-item:: s3

         - ``STANDARD``
         - ``STANDARD_IA``
         - ``ONEZONE_IA``

      .. tab-item:: gcs

         - ``STANDARD``
         - ``NEARLINE``
         - ``COLDLINE``

      .. tab-item:: azure 
         
         - ``Hot``
         - ``Cool``

   If omitted, objects use the default storage class defined for the remote bucket.

.. mc-cmd:: --region
   :optional:

   The S3 backend region for the specified :mc-cmd:`~mc ilm tier add TIER_TYPE`, such as ``us-west-1``.

   This option only applies if :mc-cmd:`~mc ilm tier add TIER_TYPE` is ``s3`` or ``minio``. 
   This option has no effect for any other value of ``TIER_TYPE``.
      
.. mc-cmd:: --use-aws-role
   :optional:

   Use the access permission for the locally configured :iam-docs:`AWS Role <id_roles.html>`.

   This option only applies if :mc-cmd:`~mc ilm tier add TIER_TYPE` is ``s3`` or ``minio``.
   This option has no effect for any other value of ``TIER_TYPE``.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Configure a Tier to Transition Objects to a MinIO Deployment
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following example creates a new tier on a local deployment that a configured rule can use to transition objects to a separate, remote MinIO deployment.

.. code-block:: shell
   :class: copyable

   mc ilm tier add minio myminio WARM-MINIO-TIER --endpoint https://warm-minio.com \                       
        --access-key ACCESSKEY --secret-key SECRETKEY --bucket mybucket --prefix myprefix/  

This command creates a new tier called ``WARM-MINIO-TIER`` for a ``minio`` type of remote storage on the ``myminio`` deployment.

- The remote MinIO storage is located at ``https://warm-minio.com``.
- The command includes credentials for a user with read, write, list, and delete privileges to the bucket and prefix.
- The tier transitions objects to the ``mybucket`` bucket and the ``myprefix`` prefix on the remote MinIO storage.

Configure a Tier to Transition Objects to an Azure Blob Storage Location
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following example creates a new tier on a local deployment that a configured rule can use to transition objects to Azure Blob Storage.

.. code-block:: shell
   :class: copyable

   mc ilm tier add azure myminio AZTIER --account-name ACCOUNT-NAME --account-key ACCOUNT-KEY \            
        --bucket myazurebucket --prefix myazureprefix/                                                         
                                                        

This command creates a new tier called ``AZTIER`` for an ``azure`` type of remote storage on the ``myminio`` deployment.

- The remote Azure storage is accessed by the provided account name and key.
- The tier transitions objects to the ``myazurebucket`` bucket and the ``myazureprefix`` prefix on the Azure storage.

Configure a Tier to Transition Objects to Google Cloud Storage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following example creates a new tier on a local deployment that a configured rule can use to transition objects to Google Cloud Storage.

.. code-block:: shell
   :class: copyable

    mc ilm tier add gcs myminio GCSTIER --credentials-file /path/to/credentials.json \                      
        --bucket mygcsbucket  --prefix mygcsprefix/                                                            

This command creates a new tier called ``GCSTIER`` for a ``gcs`` type of remote storage on the ``myminio`` deployment.

- The remote GCS storage is accessed by the provided credentials file.
- The tier transitions objects to the ``mygcsbucket`` bucket and the ``mygcsprefix`` prefix on the GCS storage.

Configure a Tier to Transition Objects to Amazon Simple Storage Service (S3)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following example creates a new tier on a local deployment that a configured rule can use to transition objects to a STANDARD storage on S3.

.. code-block:: shell
   :class: copyable

    mc ilm tier add s3 myminio S3TIER --endpoint https://s3.amazonaws.com \                                 
        --access-key ACCESSKEY --secret-key SECRETKEY --bucket mys3bucket --prefix mys3prefix/ \               
        --storage-class "STANDARD" --region us-west-2                                                             

This command creates a new tier called ``S3TIER`` for a ``s3`` type of remote storage on the ``myminio`` deployment.

- The S3 storage is located at the provided endpoint.
- The remotes S3 storage is accessed by the provided access key and secret key.
- The tier transitions objects to the ``mys3bucket`` bucket and the ``mys3prefix`` prefix on the GCS storage.
- The tier utilizes S3 ``STANDARD`` storage class located in the ``us-west-2`` S3 region.

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility


Required Permissions
--------------------

For permissions required to add a tier, refer to the :ref:`required permissions <minio-mc-ilm-tier-permissions>` on the parent command.