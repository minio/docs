.. _minio-object-locking:
.. _minio-object-retention:

====================
MinIO Object Locking
====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. container:: extlinks-video

   - `Object locking and retention overview <https//youtu.be/Hk9Z-sltUu8?ref=docs>`__
   - `Object locking and retention lab <https//youtu.be/thNus-DL1u4?ref=docs>`__

Overview
--------

MinIO Object Locking ("Object Retention") enforces Write-Once Read-Many (WORM)
immutability to protect :ref:`versioned objects <minio-bucket-versioning>` from
deletion. MinIO supports both 
:ref:`duration based object retention <minio-object-locking-retention-modes>` 
and 
:ref:`indefinite legal hold retention <minio-object-locking-legalhold>`.

MinIO Object Locking provides key data retention compliance and meets
SEC17a-4(f), FINRA 4511(C), and CFTC 1.31(c)-(d) requirements as per 
`Cohasset Associates <https://min.io/cohasset?ref-docs>`__.

.. card-carousel:: 1

   .. card:: Bucket Without Locking

      .. image:: /images/retention/minio-versioning-delete-object.svg
         :alt: Deleting an Object
         :align: center
         :width: 600px

      MinIO versioning preserves the full history of object mutations. 
      However, applications can explicitly delete specific object versions.

   .. card:: Bucket With Locking

      .. image:: /images/retention/minio-object-locking.svg
         :alt: 30 Day Locked Objects
         :align: center
         :width: 600px

      Applying a default 30 Day WORM lock to objects in the bucket ensures
      a minimum period of retention and protection for all object versions.

   .. card:: Delete Operations in Locked Bucket

      .. image:: /images/retention/minio-object-locking-delete.svg
         :alt: Delete Operation in Locked Bucket
         :align: center
         :width: 600px

      :ref:`Delete operations <minio-object-delete>` follow normal behavior in 
      :ref:`versioned buckets <minio-bucket-versioning-delete>`, where MinIO
      creates a ``DeleteMarker`` for the object. However, non-Delete Marker 
      versions of the object remain under the retention rules and are protected 
      from any specific deletion or overwrite attempts.

   .. card:: Versioned Delete Operations in Locked Bucket

      .. image:: /images/retention/minio-object-locking-delete-version.svg
         :alt: Versioned Delete Operation in a Locked Bucket
         :align: center
         :width: 600px

      MinIO blocks any attempt to :ref:`delete <minio-object-delete>` a specific object version held under
      WORM lock. The earliest possible time after which a client may delete
      the version is when the lock expires.

MinIO object locking is 
:s3-docs:`feature and API compatible with AWS S3 <object-lock.html>`. 
This page summarizes Object Locking / Retention concepts as implemented by 
MinIO. See the AWS S3 documentation on
:s3-docs:`How S3 Object Lock works <object-lock.html>` for additional
resources.

You can only enable object locking during bucket creation as per 
:s3-docs:`S3 behavior <object-lock-overview.html#object-lock-bucket-config>`. 
You cannot enable object locking on a bucket created without locking
enabled. You can then configure object retention rules at any time.
Object locking requires :ref:`versioning <minio-bucket-versioning>` and
enables the feature implicitly.

.. _minio-bucket-locking-interactions-versioning:

Interaction with Versioning
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Objects held under WORM locked are immutable until the lock expires or is
explicitly lifted. Locking is per-object version, where each version is
independently immutable. 

If an application performs an unversioned delete operation on a locked object,
the operation produces a :ref:`delete marker <minio-bucket-versioning-delete>`.
Attempts to explicitly delete any WORM-locked object fail with an error. 
Delete Markers are *not* eligible for protection under WORM locking. 
See the S3 documentation on 
:s3-docs:`Managing delete markers and object lifecycles
<object-lock-managing.html#object-lock-managing-lifecycle>` for more 
information.

For example, consider the following bucket with 
:ref:`minio-object-locking-governance` locking enabled by default:

.. code-block:: shell

   $ mc ls --versions play/locking-guide

     [DATETIME]    29B 62429eb1-9cb7-4dc5-b507-9cc23d0cc691 v3 PUT data.csv
     [DATETIME]    32B 78b3105a-02a1-4763-8054-e66add087710 v2 PUT data.csv
     [DATETIME]    23B c6b581ca-2883-41e2-9905-0a1867b535b8 v1 PUT data.csv

Attempting to perform a delete on a *specific version* of ``data.csv`` fails
due to the object locking settings:

.. code-block:: shell

   $ mc rm --version-id 62429eb1-9cb7-4dc5-b507-9cc23d0cc691 play/data.csv

     Removing `play/locking-guide/data.csv` (versionId=62429eb1-9cb7-4dc5-b507-9cc23d0cc691).
     mc: <ERROR> Failed to remove `play/locking-guide/data.csv`. 
         Object, 'data.csv (Version ID=62429eb1-9cb7-4dc5-b507-9cc23d0cc691)' is 
         WORM protected and cannot be overwritten

Attempting to perform an unversioned delete on ``data.csv`` succeeds and creates
a new ``DeleteMarker`` for the object:

.. code-block:: shell

   $ mc rm play/locking-guide/data.csv

     [DATETIME]     0B acce329f-ad32-46d9-8649-5fe8bf4ec6e0 v4 DEL data.csv
     [DATETIME]    29B 62429eb1-9cb7-4dc5-b507-9cc23d0cc691 v3 PUT data.csv
     [DATETIME]    32B 78b3105a-02a1-4763-8054-e66add087710 v2 PUT data.csv
     [DATETIME]    23B c6b581ca-2883-41e2-9905-0a1867b535b8 v1 PUT data.csv

Interaction with Lifecycle Management
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MinIO :ref:`object expiration <minio-lifecycle-management-expiration>` 
respects any active object lock and retention settings for objects covered by
the expiration rule.

- For expiration rules operating on only the *current* object version, 
  MinIO creates a Delete Marker for the locked object.

- For expiration rules operating on *non-current object versions*, 
  MinIO can only expire the non-current versions *after* the retention period
  has passed *or* has been explicitly lifted (e.g. legal holds).

For example, consider the following bucket with 
:ref:`minio-object-locking-governance` locking enabled by default for 45 days:

.. code-block:: shell

   $ mc ls --versions play/locking-guide

     [7D]    29B 62429eb1-9cb7-4dc5-b507-9cc23d0cc691 v3 PUT data.csv
     [30D]    32B 78b3105a-02a1-4763-8054-e66add087710 v2 PUT data.csv
     [60D]    23B c6b581ca-2883-41e2-9905-0a1867b535b8 v1 PUT data.csv

Creating an expiration rule for *current* objects older than 7 days results in
a Delete Marker for the object:

.. code-block:: shell

   $ mc ls --versions play/locking-guide

     [0D]     0B acce329f-ad32-46d9-8649-5fe8bf4ec6e0 v4 DEL data.csv
     [7D]    29B 62429eb1-9cb7-4dc5-b507-9cc23d0cc691 v3 PUT data.csv
     [30D]    32B 78b3105a-02a1-4763-8054-e66add087710 v2 PUT data.csv
     [60D]    23B c6b581ca-2883-41e2-9905-0a1867b535b8 v1 PUT data.csv

However, an expiration rule for *non-current* objects older than 7 days would
only take effect *after* the configured WORM lock expires. Since the bucket
has a 45 day ``GOVERNANCE`` retention set, only the ``v1`` version of 
``data.csv`` is unlocked and therefore eligible for deletion.

Tutorials
---------

Create Bucket with Object Locking Enabled
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You must enable object locking during bucket creation as per S3 behavior.
You can create a bucket with object locking enabled using the MinIO Console,
the MinIO :mc:`mc` CLI, or using an S3-compatible SDK.

.. tab-set::

   .. tab-item:: MinIO Console
      :sync: console

      Select the :guilabel:`Buckets` section of the MinIO Console to access
      bucket creation and management functions. Select the bucket row from the
      list of buckets. You can use the :octicon:`search` :guilabel:`Search` bar
      to filter the list. 
      
      .. image:: /images/minio-console/console-bucket.png
         :width: 600px
         :alt: MinIO Console Bucket Management
         :align: center

      Click the :guilabel:`Create Bucket` button to open the bucket creation
      modal. Toggle the :guilabel:`Object Locking` selector to enable object
      locking on the bucket.

      .. image:: /images/minio-console/console-bucket-create-bucket-with-locking.png
         :width: 600px
         :alt: MinIO Console Bucket Management
         :align: center

   .. tab-item:: MinIO CLI
      :sync: cli

      Use the :mc:`mc mb` command with the :mc-cmd:`~mc mb --with-lock`
      option to create a bucket with object locking enabled:

      .. code-block:: shell
         :class: copyable

         mc mb --with-lock ALIAS/BUCKET

      - Replace ``ALIAS`` with the :mc:`alias <mc alias>` of a configured 
        MinIO deployment.

      - Replace ``BUCKET`` with the 
        :mc-cmd:`name <mc mb ALIAS>` of the bucket to create.

Configure Bucket-Default Object Retention
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can configure object locking rules ("object retention") using the 
MinIO Console, the MinIO :mc:`mc` CLI, or using an S3-compatible SDK. 

MinIO supports setting both bucket-default *and* per-object retention rules. 
The following examples set bucket-default retention. For per-object retention
settings, defer to the documentation for the ``PUT`` operation used by your
preferred SDK.

.. tab-set::

   .. tab-item:: MinIO Console
      :sync: console

      Select the :guilabel:`Buckets` section of the MinIO Console to access bucket creation and management functions. You can use the :octicon:`search` :guilabel:`Search` bar to filter the list. 
      
      .. image:: /images/minio-console/console-bucket.png
         :width: 600px
         :alt: MinIO Console Bucket Management
         :align: center

      Each bucket row has a :guilabel:`Manage` button that opens the management view for that bucket.

      .. image:: /images/minio-console/console-bucket-manage.png
         :width: 600px
         :alt: MinIO Console Bucket Management
         :align: center

      From the :guilabel:`Retention` section, select :guilabel:`Enabled`.
      This section is only visible for buckets created with object locking enabled.

      From the :guilabel:`Set Retention Configuration` modal, set the desired bucket default retention settings.

      - For :guilabel:`Retention Mode`, select either :ref:`COMPLIANCE <minio-object-locking-compliance>` or :ref:`GOVERNANCE <minio-object-locking-governance>`.

      - For :guilabel:`Duration`, select the retention duration units of :guilabel:`Days` or :guilabel:`Years`.

      - For :guilabel:`Retention Validity`, set the duration of time for which MinIO holds objects under the specified retention mode for the bucket.

   .. tab-item:: MinIO CLI
      :sync: cli

      Use the :mc:`mc retention set` command with the
      :mc-cmd:`--recursive <mc retention set --recursive>` and
      :mc-cmd:`--default <mc retention set --default>` options to set the
      default retention mode for a bucket:

      .. code-block:: shell
         :class: copyable

         mc retention set --recursive --default MODE DURATION ALIAS/BUCKET

      - Replace :mc-cmd:`MODE <mc retention set MODE>` with either either 
        :ref:`COMPLIANCE <minio-object-locking-compliance>` or 
        :ref:`GOVERNANCE <minio-object-locking-governance>`.

      - Replace :mc-cmd:`DURATION <mc retention set VALIDITY>` with the 
        duration for which the object lock remains in effect.

      - Replace :mc-cmd:`ALIAS <mc retention set ALIAS>` with the 
        :mc:`alias <mc alias>` of a configured MinIO deployment.

      - Replace :mc-cmd:`BUCKET <mc retention set ALIAS>` with the 
        name of the bucket on which to set the default retention rule.

Enable Legal Hold Retention
~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can enable or disable indefinite legal hold retention for an object using the MinIO Console, the MinIO :mc:`mc` CLI, or using an S3-compatible SDK. 

You can place a legal hold on an object already held under a :ref:`COMPLIANCE <minio-object-locking-compliance>` or :ref:`GOVERNANCE <minio-object-locking-governance>` lock. 
The object remains WORM locked under the legal hold even when the retention lock expires. 
You or another user with the necessary permissions must explicitly lift the legal hold to remove the WORM lock.

.. tab-set::

   .. tab-item:: MinIO Console
      :sync: console

      Select the :guilabel:`Buckets` section of the MinIO Console to access bucket creation and management functions. 
      You can use the :octicon:`search` :guilabel:`Search` bar to filter the list. 

      .. image:: /images/minio-console/console-bucket.png
         :width: 600px
         :alt: MinIO Console Bucket Management
         :align: center

      Each bucket row has a :guilabel:`Manage` button that opens the management view for that bucket.

      .. image:: /images/minio-console/console-object-browser.png
         :width: 600px
         :alt: MinIO Console Bucket Object Browser
         :align: center

      Browse to the object and select it to open the object details view. 
      Select the :guilabel:`Legal Hold` button to toggle the legal hold status of the object.

   .. tab-item:: MinIO CLI
      :sync: cli

      Use the :guilabel:`mc legalhold set` command to toggle the legal hold status on an object.

      .. code-block:: shell
         :class: copyable

         mc legalhold set ALIAS/PATH

      - Replace :mc-cmd:`ALIAS <mc legalhold set ALIAS>` with the 
        :mc:`alias <mc alias>` of a configured MinIO deployment.

      - Replace :mc-cmd:`PATH <mc legalhold set ALIAS>` with the 
        path to the object for which to enable the legal hold. 

.. _minio-object-locking-retention-modes:

Object Retention Modes
----------------------

MinIO implements the following 
:s3-docs:`S3 Object Locking Modes <object-lock-overview.html>`:

.. list-table::
   :header-rows: 1
   :widths: 40 60
   :width: 100%

   * - Mode
     - Summary

   * - :ref:`minio-object-locking-governance`
     - Prevents any operation that would mutate or modify the object or its
       locking settings by non-privileged users.
       
       Users with the :policy-action:`s3:BypassGovernanceRetention` permission
       on the bucket or object can modify the object or its locking settings.

       MinIO lifts the lock automatically after the configured retention rule
       duration has passed.

   * - :ref:`minio-object-locking-compliance`
     - Prevents any operation that would mutate or modify the object or its
       locking settings.
       
       No MinIO user can modify the object or its settings, including the
       :ref:`MinIO root <minio-users-root>` user.

       MinIO lifts the lock automatically after the configured retention rule
       duration has passed.

.. _minio-object-locking-governance:

GOVERNANCE Mode
~~~~~~~~~~~~~~~

An object under ``GOVERNANCE`` lock is protected from write operations by 
non-privileged users. 

``GOVERNANCE`` locked objects enforce managed-immutability for locked objects,
where users with the :policy-action:`s3:BypassGovernanceRetention` action can
modify the locked object, change the retention duration, or lift the lock
entirely. Bypassing ``GOVERNANCE`` retention also requires setting the 
``x-amz-bypass-governance-retention:true`` header as part of the request.

The MinIO ``GOVERNANCE`` lock is functionally identical to the 
:s3-docs:`S3 GOVERNANCE mode 
<object-lock-overview.html#object-lock-retention-modes>`.

.. _minio-object-locking-compliance:

COMPLIANCE Mode
~~~~~~~~~~~~~~~

An object under ``COMPLIANCE`` lock is protected from write operations by *all*
users, including the :ref:`MinIO root <minio-users-root>` user.

``COMPLIANCE`` locked objects enforce complete immutability for locked objects.
You cannot change or remove the lock before the configured retention
duration has passed.

The MinIO ``COMPLIANCE`` lock is functionally identical to the 
:s3-docs:`S3 GOVERNANCE mode 
<object-lock-overview.html#object-lock-retention-modes>`.

.. _minio-object-locking-legalhold:

Legal Hold
----------

An object under legal hold is protected from write operations by *all* 
users, including the :ref:`MinIO root <minio-users-root>` user. 

Legal holds are indefinite and enforce complete immutability for locked objects.
Only privileged users with the :policy-action:`s3:PutObjectLegalHold` permission can set or lift the legal hold.

Legal holds apply at the object level.
If you enable legal hold for a group of objects, such as the contents of a bucket, subsequently created objects in that bucket are not affected.

Legal holds are complementary to both :ref:`minio-object-locking-governance` and :ref:`minio-object-locking-compliance` retention settings. 
An object held under both legal hold *and* a ``GOVERNANCE/COMPLIANCE`` retention rule remains WORM locked until the legal hold is lifted *and* the rule expires.

For ``GOVERNANCE`` locked objects, the legal hold prevents mutating the object *even if* the user has the necessary privileges to bypass retention.
