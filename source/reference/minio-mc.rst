.. _minio-client:

=====================
MinIO Client (``mc``)
=====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. mc:: mc

The MinIO Client :mc-cmd:`mc` command line tool provides a modern alternative
to UNIX commands like ``ls``, ``cat``, ``cp``, ``mirror``, and ``diff`` with
support for both filesystems and Amazon S3-compatible cloud storage services.

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: minio-mc-s3-compatibility

:mc-cmd:`mc` has the following syntax:

.. code-block:: shell

   mc [GLOBALFLAGS] COMMAND --help

See :ref:`minio-mc-commands` for a list of supported commands.

.. admonition:: AGPLv3
   :class: note

   :program:`mc` is :minio-git:`AGPLv3 <mc/blob/master/LICENSE>` 
   licensed Free and Open Source (FOSS) software. 

   Applications integrating :program:`mc` may trigger AGPLv3 compliance
   requirements. `MinIO Commericla Licensing <https://min.io/pricing>`__
   is the best option for applications which trigger AGPLv3 obligations where
   open-sourcing the application is not an option.   

.. _mc-install:

Quickstart
----------

1) Install ``mc``
~~~~~~~~~~~~~~~~~

Install the :program:`mc` command line tool onto the host machine. Click
the tab that corresponds to the host machine operating system or environment:

.. include:: /includes/minio-mc-installation.rst

2) Create an Alias for the S3-Compatible Service
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. important::

   The following example temporarily disables the bash history to mitigate the
   risk of authentication credentials leaking in plain text. This is a basic
   security measure and does not mitigate all possible attack vectors. Defer to
   security best practices for your operating system for inputting sensitive
   information on the command line.

Use the :mc-cmd:`mc alias set` command to add an Amazon S3-compatible service
to the :mc-cmd:`mc` :ref:`configuration <mc-configuration>`.

.. code-block:: shell
   :class: copyable

   bash +o history
   mc alias set ALIAS HOSTNAME ACCESS_KEY SECRET_KEY
   bash -o history

- Replace ``ALIAS`` with a name to associate to the S3 service. 
  :mc-cmd:`mc` commands typically require ``ALIAS`` as an argument for
  identifying which S3 service to execute against.

- Replace ``HOSTNAME`` with the URL endpoint or IP address of the S3 service.

- Replace ``ACCESS_KEY`` and ``SECRET_KEY`` with the access and secret 
  keys for a user on the S3 service. 

Replace each argument with the required values. Specifying only the 
``mc config host add`` command starts an input prompt for entering the
required values.

Each of the following tabs contains a provider-specific example:

.. tab-set::

   .. tab-item:: MinIO Server

      .. code-block:: shell
         :class: copyable

         mc alias set myminio https://minioserver.example.net ACCESS_KEY SECRET KEY

   .. tab-item:: AWS S3 Storage

      .. code-block:: shell
         :class: copyable

         mc alias set myS3 https://s3.amazon.com/endpoint ACCESS_KEY SECRET KEY

   .. tab-item:: Google Cloud Storage

      .. code-block:: shell
         :class: copyable

         mc alias set myGCS https://storage.googleapis.com/endpoint ACCESS_KEY SECRET KEY

3) Test the Connection
~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc admin info` command to test the connection to
the newly added MinIO deployment:

.. code-block:: shell
   :class: copyable

   mc admin info myminio

The command returns information on the S3 service if successful. If
unsuccessful, check each of the following:

- The host machine has connectivity to the S3 service URL (i.e. using ``ping``
  or ``traceroute``).

- The specified ``ACCESSKEY`` and ``SECRETKEY`` correspond to a user on the
  S3 service. The user must have permission to perform actions on the
  service. 
  
  For MinIO deployments, see :ref:`minio-access-management`
  for more information on user access permissions. For other S3-compatible
  services, defer to the documentation for that service.

.. _minio-mc-commands:

Command Quick Reference
-----------------------

The following table lists :mc-cmd:`mc` commands:

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Command
     - Description

   * - | :mc:`mc alias set`
       | :mc:`mc alias remove`
       | :mc:`mc alias list`
     - The ``mc alias`` commands provide a convenient interface for
       managing the list of S3-compatible hosts that :mc-cmd:`mc` can connect to
       and run operations against.

       :mc-cmd:`mc` commands that operate on S3-compatible services *require*
       specifying an alias for that service.
     
   * - :mc:`mc cat`
     - .. include:: /reference/minio-mc/mc-cat.rst
          :start-after: start-mc-cat-desc
          :end-before: end-mc-cat-desc
     
   * - :mc:`mc cp`
     - .. include:: /reference/minio-mc/mc-cp.rst
          :start-after: start-mc-cp-desc
          :end-before: end-mc-cp-desc
     
   * - :mc:`mc diff`
     - .. include:: /reference/minio-mc/mc-diff.rst
          :start-after: start-mc-diff-desc
          :end-before: end-mc-diff-desc
     
   * - | :mc:`mc encrypt set`
       | :mc:`mc encrypt info`
       | :mc:`mc encrypt clear`
     - The ``mc encrypt`` command sets, updates, or disables the default bucket
       Server-Side Encryption (SSE) mode. MinIO automatically encrypts objects
       using the specified SSE mode.
     
   * - | :mc:`mc event add`
       | :mc:`mc event remove`
       | :mc:`mc event list`
     - The ``mc event`` command supports adding, removing, and listing
       the bucket event notifications.

       MinIO automatically sends triggered events to the configured notification
       targets. MinIO supports notification targets like AMQP (RabbitMQ), Redis,
       ElasticSearch, NATS and PostgreSQL. See :ref:`MinIO Bucket Notifications
       <minio-bucket-notifications>` for more information.
     
   * - :mc:`mc find`
     - .. include:: /reference/minio-mc/mc-find.rst
          :start-after: start-mc-find-desc
          :end-before: end-mc-find-desc
     
   * - :mc:`mc head`
     - .. include:: /reference/minio-mc/mc-head.rst
          :start-after: start-mc-head-desc
          :end-before: end-mc-head-desc
     
   * - | :mc:`mc ilm add`
       | :mc:`mc ilm ls`
       | :mc:`mc ilm edit`
       | :mc:`mc ilm rm`
       | :mc:`mc ilm export`
       | :mc:`mc ilm import`
     - The ``mc ilm`` command supports managing
       :ref:`object lifecycle management rules <minio-lifecycle-management>`
       on a MinIO deployment. 

       Use this command to set both :ref:`minio-lifecycle-management-tiering` 
       and :ref:`minio-lifecycle-management-expiration` rules on a bucket.
     
   * - | :mc:`mc legalhold set`
       | :mc:`mc legalhold info`
       | :mc:`mc legalhold clear`
     - The ``mc legalhold`` command sets, removes, or retrieves 
       the :ref:`Object Legal Hold (WORM) <minio-object-locking-legalhold>`
       settings for object(s).

   * - :mc:`mc ls`
     - .. include:: /reference/minio-mc/mc-ls.rst
          :start-after: start-mc-ls-desc
          :end-before: end-mc-ls-desc
     
   * - :mc:`mc mb`
     - .. include:: /reference/minio-mc/mc-mb.rst
          :start-after: start-mc-mb-desc
          :end-before: end-mc-mb-desc
     
   * - :mc:`mc mirror`
     - .. include:: /reference/minio-mc/mc-mirror.rst
          :start-after: start-mc-mirror-desc
          :end-before: end-mc-mirror-desc
     
   * - :mc:`mc mv`
     - .. include:: /reference/minio-mc/mc-mv.rst
          :start-after: start-mc-mv-desc
          :end-before: end-mc-mv-desc
     
   * - | :mc:`mc policy set`
       | :mc:`mc policy set-json`
       | :mc:`mc policy get`
       | :mc:`mc policy get-json`
       | :mc:`mc policy list`
       | :mc:`mc policy links`

     - The :mc:`mc policy` command supports setting or removing anonymous
       :ref:`policies <minio-policy>` to a bucket and its contents. Buckets with
       anonymous policies allow public access where clients can perform any
       action granted by the policy without :ref:`authentication
       <minio-authentication-and-identity-management>`.
     
   * - :mc:`mc rb`
     - .. include:: /reference/minio-mc/mc-rb.rst
          :start-after: start-mc-rb-desc
          :end-before: end-mc-rb-desc
     
   * - | :mc:`mc retention set`
       | :mc:`mc retention info`
       | :mc:`mc retention clear`

     - The :mc:`mc retention` command configures the 
       :ref:`Write-Once Read-Many (WORM) locking <minio-object-locking>`
       settings for an object or object(s) in a bucket. You can also set the
       default object lock settings for a bucket, where all objects without
       explicit object lock settings inherit the bucket default.

   * - | :mc:`mc replicate add`
       | :mc:`mc replicate edit`
       | :mc:`mc replicate ls`
       | :mc:`mc replicate status`
       | :mc:`mc replicate resync`
       | :mc:`mc replicate export`
       | :mc:`mc replicate import`
       | :mc:`mc replicate rm`

     - The :mc:`mc replicate <mc replicate add>` command configures and
       manages the :ref:`Server-Side Bucket Replication
       <minio-bucket-replication-serverside>` for a MinIO deployment, including
       :ref:`active-active replication configurations
       <minio-bucket-replication-serverside-twoway>` and
       :ref:`resynchronization <minio-replication-behavior-resync>`.
       
     
   * - :mc:`mc rm`
     - .. include:: /reference/minio-mc/mc-rm.rst
          :start-after: start-mc-rm-desc
          :end-before: end-mc-rm-desc
     
   * - | :mc:`mc share download`
       | :mc:`mc share upload`
       | :mc:`mc share list`
     - The :mc-cmd:`mc share download` and :mc-cmd:`mc share upload`
       commands generate presigned URLs for downloading and uploading
       objects to a MinIO bucket.
     
   * - :mc:`mc sql`
     - .. include:: /reference/minio-mc/mc-sql.rst
          :start-after: start-mc-sql-desc
          :end-before: end-mc-sql-desc
     
   * - :mc:`mc stat`
     - .. include:: /reference/minio-mc/mc-stat.rst
          :start-after: start-mc-stat-desc
          :end-before: end-mc-stat-desc

   * - | :mc:`mc tag set`
       | :mc:`mc tag remove`
       | :mc:`mc tag list`

     - The :mc:`mc tag` command adds, removes, and lists tags associated to
       a bucket or object.
     
   * - :mc:`mc tree`
     - .. include:: /reference/minio-mc/mc-tree.rst
          :start-after: start-mc-tree-desc
          :end-before: end-mc-tree-desc
     
   * - :mc:`mc update`
     - .. include:: /reference/minio-mc/mc-update.rst
          :start-after: start-mc-update-desc
          :end-before: end-mc-update-desc
     
   * - :mc:`mc version`
     - .. include:: /reference/minio-mc/mc-version.rst
          :start-after: start-mc-version-desc
          :end-before: end-mc-version-desc
     
   * - :mc:`mc watch`
     - .. include:: /reference/minio-mc/mc-watch.rst
          :start-after: start-mc-watch-desc
          :end-before: end-mc-watch-desc
     

:mc-cmd:`mc` also includes an administration extension for managing MinIO
deployments. See :mc-cmd:`mc admin` for more complete documentation.

.. _mc-configuration:

Configuration File
------------------

:mc-cmd:`mc` uses a ``JSON`` formatted configuration file used for storing
certain kinds of information, such as the :mc-cmd:`aliases <mc alias>` for 
each configured S3-compatible service.

For Linux and OSX, the default configuration file location is 
``~/.mc/config.json``.

For Windows, :mc-cmd:`mc` attempts to construct a default file path by trying
specific environment variables. If a variable is unset, :mc-cmd:`mc` moves 
to the next variable. If all attempts fail, :mc-cmd:`mc` returns an error.
The following list describes each possible file path location in the order
:mc-cmd:`mc` checks them:

#. ``HOME\.mc\config.json``
#. ``USERPROFILE\.mc\config.json``
#. ``HOMEDRIVE+HOMEPATH\.mc\config.json``

You can use the ``--config-dir``

.. _minio-mc-global-options:

Global Options
--------------

.. program:: mc

All :ref:`commands <minio-mc-commands>` support the following global options:

.. option:: --debug

   Enables verbose output to the console.

   For example, the following operation adds verbose output to the 
   :mc:`mc ls` command:

   .. code-block:: shell
      :class: copyable

      mc --debug ls play

.. option:: --config-dir

   The path to a ``JSON`` formatted configuration file that
   :program:`mc` uses for storing data. See :ref:`mc-configuration` for
   more information on how :program:`mc` uses the configuration file.

.. option:: --JSON

   Enables `JSON lines <http://jsonlines.org/>`_ formatted output to the
   console.

   For example, the following operation adds JSON Lines output to the 
   :mc:`mc ls` command:

   .. code-block:: shell
      :class: copyable

      mc --JSON ls play 

.. option:: --no-color

   Disables the built-in color theme for console output. Useful for dumb
   terminals.

.. option:: --quiet

   Suppresses console output. 

.. option:: --insecure

   Disables TLS/SSL certificate verification. Allows TLS connectivity to 
   servers with invalid certificates. Exercise caution when using this
   option against untrusted S3 hosts.

.. option:: --version

   Displays the current version of :mc-cmd:`mc`. 

.. toctree::
   :titlesonly:
   :hidden:
   
   /reference/minio-mc/mc-alias-set
   /reference/minio-mc/mc-alias-list
   /reference/minio-mc/mc-alias-remove
   /reference/minio-mc/mc-cat
   /reference/minio-mc/mc-cp
   /reference/minio-mc/mc-diff
   /reference/minio-mc/mc-encrypt-set
   /reference/minio-mc/mc-encrypt-info
   /reference/minio-mc/mc-encrypt-clear
   /reference/minio-mc/mc-event-add
   /reference/minio-mc/mc-event-list
   /reference/minio-mc/mc-event-remove
   /reference/minio-mc/mc-find
   /reference/minio-mc/mc-head
   /reference/minio-mc/mc-ilm-add
   /reference/minio-mc/mc-ilm-edit
   /reference/minio-mc/mc-ilm-ls
   /reference/minio-mc/mc-ilm-restore
   /reference/minio-mc/mc-ilm-rm
   /reference/minio-mc/mc-ilm-export
   /reference/minio-mc/mc-ilm-import
   /reference/minio-mc/mc-legalhold-set
   /reference/minio-mc/mc-legalhold-info
   /reference/minio-mc/mc-legalhold-clear
   /reference/minio-mc/mc-ls
   /reference/minio-mc/mc-mb
   /reference/minio-mc/mc-mirror
   /reference/minio-mc/mc-mv
   /reference/minio-mc/mc-policy-set
   /reference/minio-mc/mc-policy-get
   /reference/minio-mc/mc-policy-list
   /reference/minio-mc/mc-policy-links
   /reference/minio-mc/mc-policy-get-json
   /reference/minio-mc/mc-policy-set-json
   /reference/minio-mc/mc-rb
   /reference/minio-mc/mc-replicate-add
   /reference/minio-mc/mc-replicate-edit
   /reference/minio-mc/mc-replicate-ls
   /reference/minio-mc/mc-replicate-resync
   /reference/minio-mc/mc-replicate-rm
   /reference/minio-mc/mc-replicate-status
   /reference/minio-mc/mc-replicate-export
   /reference/minio-mc/mc-replicate-import
   /reference/minio-mc/mc-retention-set
   /reference/minio-mc/mc-retention-info
   /reference/minio-mc/mc-retention-clear
   /reference/minio-mc/mc-rm
   /reference/minio-mc/mc-share-download
   /reference/minio-mc/mc-share-upload
   /reference/minio-mc/mc-share-list
   /reference/minio-mc/mc-sql
   /reference/minio-mc/mc-stat
   /reference/minio-mc/mc-tag-set
   /reference/minio-mc/mc-tag-list
   /reference/minio-mc/mc-tag-remove
   /reference/minio-mc/mc-tree
   /reference/minio-mc/mc-update
   /reference/minio-mc/mc-version
   /reference/minio-mc/mc-watch
