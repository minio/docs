==========================
``mc admin bucket remote``
==========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin bucket remote

.. versionchanged:: RELEASE.2022-12-24T15-21-38Z

   - ``mc admin bucket remote add`` replaced by :mc-cmd:`mc replicate add`
   - ``mc admin bucket remote update`` replaced by :mc-cmd:`mc replicate update`
   - ``mc admin bucket remote rm`` replaced by :mc-cmd:`mc replicate rm`
   - ``mc admin bucket remote ls`` replaced by :mc-cmd:`mc replicate ls`

Description
-----------

.. start-mc-admin-bucket-remote-desc

The :mc-cmd:`mc admin bucket remote` command manages the ``ARN`` resources
for use with :mc-cmd:`bucket replication <mc replicate>`.

.. end-mc-admin-bucket-remote-desc

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only

Examples
--------

Add a New Replication Target
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin bucket remote add` to create a new replication target 
ARN for use with :mc:`mc replicate add`:

.. code-block:: shell
   :class: copyable

   mc admin bucket remote add SOURCE/BUCKET DESTINATION/BUCKET

- Replace :mc-cmd:`SOURCE <mc admin bucket remote add SOURCE>` with the
  :mc-cmd:`alias <mc alias>` of the MinIO deployment to use as the replication
  target. Replace ``BUCKET`` with the full path of the bucket into which MinIO
  replicates objects from the ``DESTINATION``.

- Replace :mc-cmd:`DESTINATION <mc admin bucket remote add DESTINATION>` with the
  :mc-cmd:`alias <mc alias>` of the MinIO deployment to use as the
  replication source. Replace ``BUCKET`` with the full path of the bucket from
  which MinIO replicates objects into the ``SOURCE``.

Remove an Existing Replication Target
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin bucket remote rm` to remove a replication target from a 
bucket:

.. code-block:: shell
   :class: copyable

   mc admin bucket remote rm SOURCE/BUCKET --arn ARN

- Replace :mc-cmd:`SOURCE <mc admin bucket remote rm SOURCE>` with the
  :mc-cmd:`alias <mc alias>` of the MinIO deployment being used as the
  replication source. Replace ``BUCKET`` with the full path of the bucket from
  which MinIO replicates objects.

- Replace :mc-cmd:`ARN <mc admin bucket remote rm ARN>` with the 
  ARN of the remote target. 

Removing the target halts all in-progress 
:mc-cmd:`bucket replication <mc replicate>` to the target.

.. _minio-retrieve-remote-bucket-targets:

Retrieve Configured Replication Targets
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin bucket remote ls` to list a bucket's configured
replication targets:

.. code-block:: shell
   :class: copyable

   mc admin bucket remote ls SOURCE/BUCKET

- Replace :mc-cmd:`SOURCE <mc admin bucket remote ls SOURCE>` with the
  :mc-cmd:`alias <mc alias>` of the MinIO deployment being used as the
  replication source. Replace ``BUCKET`` with the full path of the bucket from
  which MinIO replicates objects.

Syntax
------

.. mc-cmd:: add
   :fullpath:

   .. versionchanged:: RELEASE.2022-12-24T15-21-38Z

      - ``mc admin bucket remote add`` replaced by :mc-cmd:`mc replicate add`

   Adds a remote target to a bucket on a MinIO deployment. The
   command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc admin bucket remote add SOURCE DESTINATION --service "replication" [FLAGS]

   The command accepts the following arguments:

   .. mc-cmd:: SOURCE

      *Required*

      The full path to the bucket to which the command adds the remote target.
      Specify the :mc-cmd:`alias <mc alias>` of a configured MinIO deployment as
      the prefix to the bucket path. For example:

      .. code-block:: shell
         :class: copyable

         mc admin bucket remote add play/mybucket

   .. mc-cmd:: DESTINATION

      *Required*

      The target MinIO deployment and bucket.

      Specify the full URL to the destination MinIO deployment and bucket
      using the following format:

      .. code-block:: shell
         :class: copyable

         http(s)://ACCESSKEY:SECRETKEY@DESTHOSTNAME/DESTBUCKET

      - Replace ``ACCESSKEY`` with the access key for a user on the
         destination MinIO deployment.

      - Replace ``SECRETKEY`` with the secret key for a user on the
         destination MinIO deployment.

      - Replace ``DESTHOSTNAME`` with the hostname and port of the MinIO
         deployment (i.e. ``minio-server.example.net:9000``).

      - Replace ``DESTBUCKET`` with the bucket on the
         destination.

   .. mc-cmd:: --service

      *Required*

      Specify ``"replication"``.

   .. mc-cmd:: --region

      The region of the :mc-cmd:`~mc admin bucket remote add DESTINATION`. 

      Mutually exclusive with :mc-cmd:`~mc admin bucket remote add`

   .. mc-cmd:: --path

      The bucket path lookup supported by the destination server. Specify
      one of the following:

      - ``on``
      - ``off``
      - ``auto`` (Default)

      Mutually exclusive with 
      :mc-cmd:`~mc admin bucket remote add`

   .. mc-cmd:: --sync

      Enables synchronous replication, where MinIO attempts to replicate
      the object *prior* to returning the PUT object response. Synchronous 
      replication may increase the time spent waiting for PUT operations
      to return successfully.

      By default, :mc-cmd:`mc admin bucket remote add` operates in 
      asynchronous mode, where MinIO attempts replicating objects
      *after* returning the PUT object response.

.. mc-cmd:: ls
   :fullpath:

   .. versionchanged:: RELEASE.2022-12-24T15-21-38Z

      - ``mc admin bucket remote ls`` replaced by :mc-cmd:`mc replicate ls`

   Lists all remote targets associated to a bucket on the MinIO deployment. The
   command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc admin bucket remote ls SOURCE --service "replication"

   The command accepts the following arguments:

   .. mc-cmd:: SOURCE

      The full path to the bucket for which the command returns the configured
      remote targets. Specify the :mc-cmd:`alias <mc alias>` of a configured
      MinIO deployment as the prefix to the bucket path. For example:

      .. code-block:: shell
         :class: copyable

         mc admin bucket remote ls play/mybucket

   .. mc-cmd:: --service
      

      *Required*

      Specify ``"replication"``.


.. mc-cmd:: rm
   :fullpath:

   .. versionchanged:: RELEASE.2022-12-24T15-21-38Z

      - ``mc admin bucket remote rm`` replaced by :mc-cmd:`mc replicate rm`
   
   Removes a remote target for a bucket on the MinIO deployment. The
   command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc admin bucket remote rm SOURCE --arn ARN

   The command accepts the following arguments:

   .. mc-cmd:: SOURCE

      *Required*

      The full path to the bucket from which the command removes the 
      remote target. Specify the
      :mc-cmd:`alias <mc alias>` of a configured MinIO deployment as the
      prefix to the bucket path. For example:

      .. code-block:: shell
         :class: copyable

         mc admin bucket remote rm play/mybucket

   .. mc-cmd:: ARN
     

      *Required*

      The ``ARN`` of the remote target for which the command removes from the
      target bucket. Use :mc-cmd:`mc admin bucket remote ls` to list all remote
      targets and their associated ARNs for a specific bucket.

