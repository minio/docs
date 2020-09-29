==========================
``mc admin bucket remote``
==========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin bucket remote

Description
-----------

.. start-mc-admin-bucket remote-desc

The :mc-cmd:`mc admin bucket remote` command manages remote targets for 
supporting bucket replication.

.. end-mc-admin-bucket remote-desc

:mc-cmd:`mc admin bucket remote` creates the required ``ARN`` resource for
use with :mc-cmd:`mc replicate`.

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only

MinIO Deployments Only
~~~~~~~~~~~~~~~~~~~~~~

:mc-cmd:`mc admin bucket remote` only supports MinIO deployments for the source
and target. MinIO provides no support or guarantees for other S3-compatible
services.

Quick Reference
---------------

:mc-cmd:`mc admin bucket remote add play/mybucket target/mybucket <mc admin bucket remote add>`
   Adds a new remote target ``target/mybucket`` to ``play/mybucket``,
   where ``target`` and ``play`` are :mc-cmd:`aliases <mc alias>` for
   configured MinIO deployments.
   
   The command returns an ``ARN`` associated to the configured target.
   :mc-cmd:`mc replicate` requires the ``ARN`` to enable replication
   from a source bucket to a destination deployment and bucket.

:mc-cmd:`mc admin bucket remote ls play/mybucket  <mc admin bucket remote ls>`
   Lists all remote targets for ``play/mybucket``, where
   ``play`` is a :mc-cmd:`alias <mc alias>` for a configured MinIO deployment.

   The command returns an ``ARN`` associated to each configured remote target.
   :mc-cmd:`mc replicate` requires the ``ARN`` to enable replication
   from a source bucket to a destination deployment and bucket.

:mc-cmd:`mc admin bucket remote rm play/mybucket target/mybucket <mc admin bucket remote rm>`
   Removes the remote target ``target/mybucket`` from ``play/mybucket``,
   where ``target`` and ``play`` are :mc-cmd:`aliases <mc alias>` for
   configured MinIO deployments.

   Removing a remote target halts any in-progress bucket replication
   relying on that remote target's ARN. 

Syntax
------

:mc-cmd:`mc admin bucket remote` has the following syntax:

.. code-block:: shell
   :class: copyable

   mc admin bucket remote SUBCOMMAND [ARGUMENTS]

:mc-cmd:`mc admin bucket remote` supports the following subcommands:

.. mc-cmd:: add
   :fullpath:

   Adds a remote target to a bucket on the MinIO deployment. The
   command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc admin bucket add TARGET DESTINATION --service "replication" [ARGUMENTS]

   The command accepts the following arguments:

   .. mc-cmd:: TARGET

      The full path to the bucket to which the command adds the remote target.
      Specify the :mc-cmd:`alias <mc alias>` of a configured MinIO deployment as
      the prefix to the bucket path. For example:

      .. code-block:: shell
         :class: copyable

         mc admin bucket add play/mybucket

   .. mc-cmd:: DESTINATION

      The target MinIO deployment and bucket. Specify one of the two
      following formats:

      .. tabs::

         .. tab:: ``alias/bucket``

            Specify the :mc-cmd:`alias <mc alias>` of a configured MinIO
            deployment as the prefix and destination bucket name as the suffix
            using a forward slash ``/`` as a delimiter:

            .. code-block:: shell
               :class: copyable

               <alias>/<bucket>

         .. tab:: URL

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

            - Replace ``DESTBUCKET`` with the name of the bucket on the
              destination.

   .. mc-cmd:: region
      :option:

      The region of the :mc-cmd:`~mc admin bucket remote DESTINATION`. 

      Mutually exclusive with :mc-cmd-option:`~mc admin bucket remote path`

   .. mc-cmd:: path

      The bucket path lookup supported by the destination server. Specify
      one of the following:

      - ``on``
      - ``off``
      - ``auto`` (Default)

      Mutually exclusive with :mc-cmd-option:`~mc admin bucket remote region`

.. mc-cmd:: ls
   :fullpath:

   Lists all remote targets associated to a bucket on the MinIO deployment. The
   command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc admin bucket ls TARGET --service "replication"

   The command accepts the following arguments:

   .. mc-cmd:: TARGET

      The full path to the bucket for which the command returns the configured
      remote targets. Specify the :mc-cmd:`alias <mc alias>` of a configured
      MinIO deployment as the prefix to the bucket path. For example:

      .. code-block:: shell
         :class: copyable

         mc admin bucket ls play/mybucket


.. mc-cmd:: rm
   :fullpath:

   Removes a remote target for a bucket on the MinIO deployment. The
   command has the following syntax:

   .. code-block:: shell
      :class: copyable

      mc admin bucket rm TARGET --arn

   The command accepts the following arguments:

   .. mc-cmd:: TARGET

      The full path to the bucket for which the command <ACTION>. Specify the
      :mc-cmd:`alias <mc alias>` of a configured MinIO deployment as the
      prefix to the bucket path. For example:

      .. code-block:: shell
         :class: copyable

         mc admin bucket remove play/mybucket

   .. mc-cmd:: ARN
      :option:

      The ``ARN`` of the remote target for which the command removes from the
      target bucket. Use :mc-cmd:`mc admin bucket ls` to list all remote
      targets and their associated ARNs for a specific bucket.

