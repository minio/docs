.. _minio-mc-event-remove:

===============
``mc event rm``
===============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc event remove
.. mc:: mc event rm

Syntax
------

.. start-mc-event-remove-desc

The :mc:`mc event rm` command removes event notification triggers on a
bucket.

.. end-mc-event-remove-desc

The :mc:`mc event remove` command has equivalent functionality to :mc:`mc event rm`.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command removes a configured event notifications for the
      specified :ref:`bucket notification target <minio-bucket-notifications>`
      for the ``mydata`` bucket on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc event rm myminio/mydata arn:aws:sqs::primary:target

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] event remove        \
                          [--event "string"]  \
                          [--force]           \
                          [--prefix "string"] \
                          [--suffix "string"] \
                          ALIAS               \
                          [ARN]

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


.. code-block:: shell

   mc [GLOBALFLAGS] event remove [FLAGS] ALIAS ARN

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS

   *Required* The S3 service :ref:`alias <alias>` and bucket from
   which the command removes the event notification. For example:

   .. code-block:: shell

      mc event add play/mybucket

.. mc-cmd:: ARN

   *Required* The :aws-docs:`Amazon Resource Name (ARN)
   <IAM/latest/UserGuide/reference-arns>` of the notification target.

   The MinIO server outputs an ARN for each configured
   notification target at server startup. See
   :ref:`minio-bucket-notifications` for more
   information.

.. mc-cmd:: --event


   *Optional* The event(s) to remove. Specify multiple events using a comma
   ``,`` delimiter. See :ref:`mc-event-supported-events` for supported events.

   Defaults to removing all events on the :mc-cmd:`~mc event rm ALIAS`
   bucket with the :mc-cmd:`~mc event rm ARN` notification target.

.. mc-cmd:: --force


   *Optional* Removes all events on the :mc-cmd:`~mc event rm ALIAS` bucket
   with the :mc-cmd:`~mc event rm ARN` notification target.

.. mc-cmd:: --prefix


   *Optional* The bucket prefix in which the command removes bucket
   notifications.

   For example, given a :mc-cmd:`~mc event rm ALIAS` of
   ``play/mybucket`` and a :mc-cmd:`~mc event rm --prefix` of
   ``photos``, the command only removes bucket notifications in
   ``play/mybucket/photos``.

.. mc-cmd:: --suffix


   *Optional* The bucket suffix in which the command removes bucket
   notifications.

   For example, given a :mc-cmd:`~mc event rm ALIAS` of
   ``play/mybucket`` and a :mc-cmd:`~mc event rm --suffix` of
   ``.jpg``, the command only removes bucket notifications in
   ``play/mybucket/*.jpg``.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Remove Event Notifications from a Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. tab-set::

   .. tab-item:: Example

      The following command removes all event notification triggers on a bucket.
      The command assumes the MinIO deployment has at least one configured
      :ref:`bucket notification target <minio-bucket-notifications>`:

      .. code-block:: shell
         :class: copyable

         mc event rm myminio/mydata arn:minio:sqs::primary:webhook

   .. tab-item:: Syntax

      .. code-block:: shell
         :class: copyable

         mc event rm ALIAS ARN

      - Replace ``ALIAS`` with the :ref:`alias <alias>` of the MinIO
        deployment on which to add the bucket notification event. For example:

        ``myminio/mydata``

      - Replace ``ARN`` with the notification target
        :mc-cmd:`ARN <mc event add ARN>`.

Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
