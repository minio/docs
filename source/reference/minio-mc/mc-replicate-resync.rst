.. _minio-mc-replicate-resync:

=======================
``mc replicate resync``
=======================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc replicate reset
.. mc:: mc replicate resync

Syntax
------

.. start-mc-replicate-resync-desc

The :mc:`mc replicate resync` command resynchronizes all objects in the
specified MinIO bucket to a remote :ref:`replication
<minio-bucket-replication-serverside>` target. 

.. end-mc-replicate-resync-desc

This command *requires* first configuring the remote bucket target using the
:mc-cmd:`mc admin bucket remote add` command. You must specify the resulting
remote ARN as part of running :mc:`mc replicate resync`.

This command supports rebuilding a MinIO deployment using an active-active
replication remote as the "backup" source. See the following tutorials
for more information on active-active replication:

- :ref:`minio-bucket-replication-serverside-twoway`
- :ref:`minio-bucket-replication-serverside-multi`

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command resynchronizes the content of the 
      ``mydata`` bucket on the ``myminio`` MinIO deployment to the remote
      MinIO deployment associated to the specified ``--remote-bucket``:

      .. code-block:: shell
         :class: copyable

         mc replicate resync start \
            --remote-bucket "arn:minio:replication::d3c086c7-1d64-40c2-954b-fe8222907033:mydata" \ 
            myminio/mydata

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] replicate resync start|status  \
                          --remote-bucket "string"       \
                          [--older-than "string"]        \
                          ALIAS

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :ref:`alias <alias>` of the MinIO deployment and full path to
   the bucket or bucket prefix which MinIO uses as the replication source. For
   example, the following command starts replication using the ``data``
   bucket on the MinIO deployment associated to the ``primary`` alias.

   .. code-block:: none

      mc replicate resync start primary/data --remote-bucket "ARN"

.. mc-cmd:: start
   :required:

   Starts the resynchronization procedure using the specified 
   :mc-cmd:`bucket <mc replicate resync ALIAS>` as the source and the
   :mc-cmd:`--remote-bucket <mc replicate resync --remote-bucket>` as the 
   remote target.

   Mutually exclusive with :mc:`mc replicate resync status`.

.. mc-cmd:: status
   :required:

   Returns the status of resynchronization on the specified 
   :mc-cmd:`bucket <mc replicate resync ALIAS>` to all remote targets.

   Include the :mc-cmd:`~mc replicate resync --remote-bucket` argument to
   filter the status output to only the specified remote target.

.. mc-cmd:: --remote-bucket
   :required:

   Specify the ARN for the destination deployment and bucket. 
   
   You can retrieve the ARN using :mc-cmd:`mc replicate ls` with the ``--json`` option.
   The ``rule.Destination.Bucket`` field contains the ARN for any given replication rule.

.. mc-cmd:: older-than
   :optional:

   Specify a duration in days where MinIO only resynchronizes
   objects older than the specified duration.

   Only valid with :mc:`mc replicate resync start`.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

Resynchronize Remote Replication Target from Source Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following :mc:`mc replicate resync` command resynchronizes all objects
on the specified source bucket to the remote target regardless of their
replication status:

.. code-block:: shell
   :class: copyable

   mc replicate resync start --remote-bucket "arn:minio:replication::UUID:data" primary/data

- Replace ``primary/data`` with the :mc-cmd:`~mc replicate add ALIAS` and
  full bucket path for which to create the replication configuration.

- Replace the :mc-cmd:`~mc replicate add --remote-bucket` value with the 
  ARN of the remote target. Use :mc-cmd:`mc admin bucket remote ls` to list
  all configured remote replication targets.

Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
