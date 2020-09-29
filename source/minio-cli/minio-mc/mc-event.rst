============
``mc event``
============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc event

Description
-----------

.. start-mc-event-desc

The :mc:`mc event` command supports adding, removing, and listing
the bucket event notifications.

MinIO automatically sends triggered events to the configured notification
targets. MinIO supports notification targets like AMQP, Redis, ElasticSearch,
NATS and PostgreSQL. See 
:doc:`MinIO Bucket Notifications </minio-features/bucket-notifications>`
for more information.

.. end-mc-event-desc

Syntax
------
  
:mc:`~mc event` has the following syntax:

.. code-block:: shell

   mc event COMMAND [COMMAND FLAGS | -h] [ARGUMENTS ...]

:mc:`~mc event` supports the following commands:

.. mc-cmd:: add

   Adds a new bucket event notification. For supported event types, see
   :ref:`mc-event-supported-events`. The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc event add TARGET ARN [FLAGS]

   .. mc-cmd:: TARGET
   
      *Required* The S3 service :mc:`alias <mc alias>` and bucket to 
      which the command adds the new event notification. Specify the
      :mc-cmd:`alias <mc alias>` of a configured S3 service as the prefix to
      the ``TARGET`` path. For example:

      .. code-block:: shell

         mc event add play/mybucket
   
   .. mc-cmd:: ARN

      *Required* The :aws-docs:`Amazon Resource Name (ARN)
      <general/latest/gr/aws-arns-and-namespaces>` of the notification target.

      The MinIO server outputs an ARN for each configured 
      notification target at server startup. See 
      :doc:`/minio-features/bucket-notifications` for more
      information.

   .. mc-cmd:: event
      :option:

      The event(s) for which MinIO generates bucket notifications. 
      Specify multiple events using a comma ``,`` delimiter. 
      See :ref:`mc-event-supported-events` for supported events.

      Defaults to ``put,delete, get``.
         
   .. mc-cmd:: prefix
      :option:

      The bucket prefix in which the specified :mc-cmd-option:`~mc event event`
      can trigger a bucket notification.

      For example, given a :mc-cmd:`~mc event TARGET` of ``play/mybucket`` and a 
      :mc-cmd-option:`~mc event prefix` of ``photos``, only events in 
      ``play/mybucket/photos`` trigger bucket notifications.

   .. mc-cmd:: suffix
      :option:

      The bucket suffix in which the specified :mc-cmd-option:`~mc event event`
      can trigger a bucket notification. 

      For example, given a :mc-cmd:`~mc event TARGET` of ``play/mybucket`` and a 
      :mc-cmd-option:`~mc event suffix` of ``.jpg``, only events in 
      ``play/mybucket/*.jpg`` trigger bucket notifications.

.. mc-cmd:: remove

   Removes an existing bucket event notification. The command has the
   following syntax:

   .. code-block:: shell
      :class: copyable

      mc event remove TARGET ARN [FLAGS]

   .. mc-cmd:: TARGET
   
      *Required* The S3 service :mc:`alias <mc alias>` and bucket from
      which the command removes the event notification. Specify the
      :mc-cmd:`alias <mc alias>` of a configured S3 service as the prefix to
      the ``TARGET`` path. For example:

      .. code-block:: shell

         mc event add play/mybucket
   
   .. mc-cmd:: ARN

      *Required* The :aws-docs:`Amazon Resource Name (ARN)
      <general/latest/gr/aws-arns-and-namespaces>` of the notification target.

      The MinIO server outputs an ARN for each configured 
      notification target at server startup. See 
      :doc:`/minio-features/bucket-notifications` for more information.

   .. mc-cmd:: force
      :option:
      
      Removes all events on the :mc-cmd:`~mc event TARGET` bucket with the
      :mc-cmd-option:`~mc event ARN` notification target.

   .. mc-cmd:: event
      :option:
      
      The event(s) to remove. Specify multiple events using a comma ``,``
      delimiter. See :ref:`mc-event-supported-events` for supported events.

      Defaults to removing all events on the :mc-cmd:`~mc event TARGET` bucket
      with the :mc-cmd-option:`~mc event ARN` notification target.

   .. mc-cmd:: prefix
      :option:

      The bucket prefix in which the command removes bucket notifications.

      For example, given a :mc-cmd:`~mc event TARGET` of ``play/mybucket`` and a
      :mc-cmd-option:`~mc event prefix` of ``photos``, the command only removes
      bucket notifications in ``play/mybucket/photos``.

   .. mc-cmd:: suffix
      :option:

      The bucket suffix in which the command removes bucket notifications. 

      For example, given a :mc-cmd:`~mc event TARGET` of ``play/mybucket`` and a 
      :mc-cmd-option:`~mc event suffix` of ``.jpg``, the command only removes
      bucket notifications in ``play/mybucket/*.jpg``.

.. mc-cmd:: list

   Lists bucket event notifications.

   The command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc event add TARGET ARN [FLAGS]

   :mc-cmd:`~mc alias list` supports the following arguments


   .. mc-cmd:: TARGET
   
      *Required* The S3 service :mc:`alias <mc alias>` and bucket to 
      which the command lists event notification. Specify the
      :mc-cmd:`alias <mc alias>` of a configured S3 service as the prefix to
      the ``TARGET`` path. For example:

      .. code-block:: shell

         mc event add play/mybucket
   
   .. mc-cmd:: ARN

      *Required* The :aws-docs:`Amazon Resource Name (ARN)
      <general/latest/gr/aws-arns-and-namespaces>` of the bucket resource.

      The MinIO server outputs an ARN for each configured 
      notification target at server startup. See 
      :doc:`/minio-features/bucket-notifications` for more information.

Behavior
--------

.. _mc-event-supported-events:

Supported Bucket Events
~~~~~~~~~~~~~~~~~~~~~~~

MinIO supports the following S3 events.

.. list-table::
   :header-rows: 1
   :widths: 20 80
   :width: 100%

   * - MinIO Alias
     - Corresponding S3 Event

   * - ``put``
     - ``s3:ObjectCreated:Put`` 

   * - ``completeMultipartUpload``
     - ``s3:ObjectCreated:CompleteMultipartUpload`` 

   * - ``head``
     - ``s3:ObjectAccessed:Head``

   * - ``post``
     - ``s3:ObjectCreated:Post``

   * - ``delete``
     - ``s3:ObjectRemoved:Delete``

   * - ``copy``
     - ``s3:ObjectCreated:Copy``

   * - ``get``
     - ``s3:ObjectAccessed:Get``

For more complete documentation on the listed S3 events, see 
:s3-docs:`S3 Supported Event Types
<NotificationHowTo.html#notification-how-to-event-types-and-destinations>`.

Examples
--------

Create a New Notification Event in Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

.. code-block:: shell
   :class: copyable

   mc event play/mybucket arn:minio:sqs::notification-target-name:notification-target \
     --event put,delete


Remove an Existing Notification Event in Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

.. code-block:: shell
   :class: copyable

   mc event play/mybucket arn:minio:sqs::notification-target-name:notification-target \
     --event put,delete


