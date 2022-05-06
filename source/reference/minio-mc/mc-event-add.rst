.. _minio-mc-event-add:

================
``mc event add``
================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc event add

Syntax
------

.. start-mc-event-add-desc

The :mc:`mc event add` command adds event notification triggers to a bucket.

.. end-mc-event-add-desc

MinIO automatically sends triggered events to the configured 
:ref:`notification target <minio-bucket-notifications>`.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command creates a new event notification trigger for
      all ``PUT`` and ``DELETE`` operations for the ``mydata`` bucket on the
      ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc event add --event "put,delete" myminio/mydata arn:aws:sqs::primary:target

      The specified ARN corresponds to a configured 
      :ref:`bucket notification target <minio-bucket-notifications>` on the
      ``myminio`` deployment.

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] event add \
                          [--event "string"]  \
                          [--ignore-existing] \
                          [--prefix "string"] \
                          [--suffix "string"] \
                          ALIAS               \
                          ARN


      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS

   *Required* The MinIO :ref:`alias <alias>` and bucket to 
   which the command adds the new event notification. For example:

   .. code-block:: shell

      mc event add play/mybucket

.. mc-cmd:: ARN

   *Required* The :aws-docs:`Amazon Resource Name (ARN)
   <general/latest/gr/aws-arns-and-namespaces>` of the notification target.

   The MinIO server outputs an ARN for each configured 
   notification target at server startup. See 
   :ref:`Bucket Notifications <minio-bucket-notifications>` for more
   information.

.. mc-cmd:: --event
   

   *Optional* The event(s) for which MinIO generates bucket notifications. 

   Supports the following values:

   - ``put``
   - ``get``
   - ``delete``
 
   Specify multiple value using a comma ``,`` delimiter. 

   Defaults to ``put,delete,get``.

   See :ref:`mc-event-supported-events` for a detailed list of S3 events
   associated to each of the supported values.

.. mc-cmd:: ignore-existing, p
   

   *Optional* Directs MinIO to ignore applying the specified event
   triggers if an existing matching trigger exists.

.. mc-cmd:: --prefix
   

   *Optional* The bucket prefix in which the specified 
   :mc-cmd:`~mc event add --event` can trigger a bucket notification.

   For example, given a :mc-cmd:`~mc event add ALIAS` of ``play/mybucket``
   and a :mc-cmd:`~mc event add --prefix` of ``photos``, only events in
   ``play/mybucket/photos`` trigger bucket notifications.

   Omit to trigger the event for all prefixes and objects in the bucket.

.. mc-cmd:: --suffix
   

   *Optional* The bucket suffix in which the specified 
   :mc-cmd:`~mc event add --event` can trigger a bucket notification. 

   For example, given a :mc-cmd:`~mc event add ALIAS` of ``play/mybucket``
   and a :mc-cmd:`~mc event add --suffix` of ``.jpg``, only events in
   ``play/mybucket/*.jpg`` trigger bucket notifications.

   Omit to trigger the event for all objects regardless of suffix.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Add an Event Notification to a Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. tab-set::

   .. tab-item:: Example

      The following command adds a new event notification trigger for all
      S3 ``PUT``, ``GET``, and ``DELETE`` operations on a bucket. The command
      assumes the MinIO deployment has at least one configured 
      :ref:`bucket notification target <minio-bucket-notifications>`:

      .. code-block:: shell
         :class: copyable

         mc event add myminio/mydata arn:minio:sqs::primary:webhook

   .. tab-item:: Syntax

      .. code-block:: shell
         :class: copyable

         mc event add ALIAS ARN

      - Replace ``ALIAS`` with the :ref:`alias <alias>` of the MinIO 
        deployment and the bucket on which to add the bucket notification event.
        For example:

        ``myminio/mydata``

      - Replace ``ARN`` with the notification target 
        :mc-cmd:`ARN <mc event add ARN>`.


Behavior
--------

.. _mc-event-supported-events:

Supported Bucket Events
~~~~~~~~~~~~~~~~~~~~~~~

The following table lists the supported :mc-cmd:`mc event add` values and their
corresponding :ref:`S3 events <minio-bucket-notifications-event-types>`:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Supported Value
     - Corresponding S3 Events

   * - ``put``
     - | :data:`s3:ObjectCreated:CompleteMultipartUpload`
       | :data:`s3:ObjectCreated:Copy`
       | :data:`s3:ObjectCreated:DeleteTagging`
       | :data:`s3:ObjectCreated:Post`
       | :data:`s3:ObjectCreated:Put`
       | :data:`s3:ObjectCreated:PutLegalHold`
       | :data:`s3:ObjectCreated:PutRetention`
       | :data:`s3:ObjectCreated:PutTagging`

   * - ``get``
     - | :data:`s3:ObjectAccessed:Head`
       | :data:`s3:ObjectAccessed:Get`
       | :data:`s3:ObjectAccessed:GetRetention`
       | :data:`s3:ObjectAccessed:GetLegalHold`

   * - ``delete``
     - | :data:`s3:ObjectRemoved:Delete`
       | :data:`s3:ObjectRemoved:DeleteMarkerCreated`

   * - ``replica``
     - | :data:`s3:Replication:OperationCompletedReplication`
       | :data:`s3:Replication:OperationFailedReplication`
       | :data:`s3:Replication:OperationMissedThreshold`
       | :data:`s3:Replication:OperationNotTracked`
       | :data:`s3:Replication:OperationReplicatedAfterThreshold`

   * - ``ilm``
     - | :data:`s3:ObjectTransition:Failed`
       | :data:`s3:ObjectTransition:Complete`
       | :data:`s3:ObjectRestore:Post`
       | :data:`s3:ObjectRestore:Completed`

For more complete documentation on the listed S3 events, see 
:s3-docs:`S3 Supported Event Types
<NotificationHowTo.html#notification-how-to-event-types-and-destinations>`.

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
