.. _minio-mc-event-list:

===============
``mc event ls``
===============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc event list
.. mc:: mc event ls

Syntax
------

.. start-mc-event-list-desc

The :mc:`mc event ls` command lists all event notification triggers for a
bucket.

.. end-mc-event-list-desc

The alias :mc:`mc event list` has equivalent functionality to :mc:`mc event ls`.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command lists all configured event notifications for the
      specified :ref:`bucket notification target <minio-bucket-notifications>`
      for the ``mydata`` bucket on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc event ls myminio myminio/mydata arn:aws:sqs::primary:target

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS]

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax


.. code-block:: shell

   mc [GLOBALFLAGS] event remove [FLAGS] ALIAS ARN

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS

   *Required* The S3 service :ref:`alias <alias>` and bucket to
   which the command lists event notification. For example:

   .. code-block:: shell

      mc event add play/mybucket

.. mc-cmd:: ARN

   *Required* The :aws-docs:`Amazon Resource Name (ARN)
   <IAM/latest/UserGuide/reference-arns>` of the bucket resource.

   The MinIO server outputs an ARN for each configured notification target at
   server startup. See
   :ref:`Bucket Notifications <minio-bucket-notifications>` for more
   information.




Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

List Event Notifications on a Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. tab-set::

   .. tab-item:: Example

      The following command lists all event notification triggers on a bucket.

      .. code-block:: shell
         :class: copyable

         mc event ls myminio/mydata

   .. tab-item:: Syntax

      .. code-block:: shell
         :class: copyable

         mc event ls ALIAS ARN

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
