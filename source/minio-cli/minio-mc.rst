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
support for both filesystems and Amazon S3-compatible cloud storage services
(AWS Signature v2 and v4).

:mc-cmd:`mc` has the following syntax:

.. code-block:: shell

   mc [FLAGS] COMMAND [COMMAND FLAGS | -h] [ARGUMENTS...] ALIAS

.. _mc-install:

Quickstart
----------

1) Install ``mc``
~~~~~~~~~~~~~~~~~

Install the :program:`mc` command line tool onto the host machine. Click
the tab that corresponds to the host machine operating system or environment:

.. include:: /includes/minio-mc-installation.rst

2) Add an S3-Compatible Service
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

.. tabs::

   .. tab:: MinIO Server

      .. code-block:: shell
         :class: copyable

         mc alias set myminio https://minioserver.example.net ACCESS_KEY SECRET KEY

   .. tab:: AWS S3 Storage

      .. code-block:: shell
         :class: copyable

         mc alias set myS3 https://s3.amazon.com/endpoint ACCESS_KEY SECRET KEY

   .. tab:: Google Cloud Storage

      .. code-block:: shell
         :class: copyable

         mc alias set myGCS https://storage.googleapis.com/endpoint ACCESS_KEY SECRET KEY

3) Test the Connection
~~~~~~~~~~~~~~~~~~~~~~

Use the :mc-cmd:`mc info` command to test the connection to
the newly added MinIO deployment:

.. code-block:: shell
   :class: copyable

   mc info myminio

The command returns information on the S3 service if successful. If
unsuccessful, check each of the following:

- The host machine has connectivity to the S3 service URL (i.e. using ``ping``
  or ``traceroute``).

- The specified ``ACCESSKEY`` and ``SECRETKEY`` correspond to a user on the
  S3 service. The user must have permission to perform actions on the
  service. 
  
  For MinIO deployments, see :ref:`minio-auth-authz-overview`
  for more information on user access permissions. For other S3-compatible
  services, defer to the documentation for that service.

.. _minio-mc-commands:

Command Quick Reference
-----------------------

The following table lists :mc-cmd:`mc` commands:

.. list-table::
   :header-rows: 1
   :widths: 25 75
   :width: 100%

   * - Command
     - Description

   * - :mc:`mc alias`
     - .. include:: /minio-cli/minio-mc/mc-alias.rst
          :start-after: start-mc-alias-desc
          :end-before: end-mc-alias-desc
     
   * - :mc:`mc cat`
     - .. include:: /minio-cli/minio-mc/mc-cat.rst
          :start-after: start-mc-cat-desc
          :end-before: end-mc-cat-desc
     
   * - :mc:`mc cp`
     - .. include:: /minio-cli/minio-mc/mc-cp.rst
          :start-after: start-mc-cp-desc
          :end-before: end-mc-cp-desc
     
   * - :mc:`mc diff`
     - .. include:: /minio-cli/minio-mc/mc-diff.rst
          :start-after: start-mc-diff-desc
          :end-before: end-mc-diff-desc
     
   * - :mc:`mc encrypt`
     - .. include:: /minio-cli/minio-mc/mc-encrypt.rst
          :start-after: start-mc-encrypt-desc
          :end-before: end-mc-encrypt-desc
     
   * - :mc:`mc event`
     - .. include:: /minio-cli/minio-mc/mc-event.rst
          :start-after: start-mc-event-desc
          :end-before: end-mc-event-desc
     
   * - :mc:`mc find`
     - .. include:: /minio-cli/minio-mc/mc-find.rst
          :start-after: start-mc-find-desc
          :end-before: end-mc-find-desc
     
   * - :mc:`mc head`
     - .. include:: /minio-cli/minio-mc/mc-head.rst
          :start-after: start-mc-head-desc
          :end-before: end-mc-head-desc
     
   * - :mc:`mc ilm`
     - .. include:: /minio-cli/minio-mc/mc-ilm.rst
          :start-after: start-mc-ilm-desc
          :end-before: end-mc-ilm-desc
     
   * - :mc:`mc legalhold`
     - .. include:: /minio-cli/minio-mc/mc-legalhold.rst
          :start-after: start-mc-legalhold-desc
          :end-before: end-mc-legalhold-desc
     
   * - :mc:`mc lock`
     - Deprecated since 
       :release:`RELEASE.2020-09-18T00-13-21Z`. Use :mc:`mc retention`.

   * - :mc:`mc ls`
     - .. include:: /minio-cli/minio-mc/mc-ls.rst
          :start-after: start-mc-ls-desc
          :end-before: end-mc-ls-desc
     
   * - :mc:`mc mb`
     - .. include:: /minio-cli/minio-mc/mc-mb.rst
          :start-after: start-mc-mb-desc
          :end-before: end-mc-mb-desc
     
   * - :mc:`mc mirror`
     - .. include:: /minio-cli/minio-mc/mc-mirror.rst
          :start-after: start-mc-mirror-desc
          :end-before: end-mc-mirror-desc
     
   * - :mc:`mc mv`
     - .. include:: /minio-cli/minio-mc/mc-mv.rst
          :start-after: start-mc-mv-desc
          :end-before: end-mc-mv-desc
     
   * - :mc:`mc policy`
     - .. include:: /minio-cli/minio-mc/mc-policy.rst
          :start-after: start-mc-policy-desc
          :end-before: end-mc-policy-desc
     
   * - :mc:`mc rb`
     - .. include:: /minio-cli/minio-mc/mc-rb.rst
          :start-after: start-mc-rb-desc
          :end-before: end-mc-rb-desc
     
   * - :mc:`mc retention`
     - .. include:: /minio-cli/minio-mc/mc-retention.rst
          :start-after: start-mc-retention-desc
          :end-before: end-mc-retention-desc
     
   * - :mc:`mc rm`
     - .. include:: /minio-cli/minio-mc/mc-rm.rst
          :start-after: start-mc-rm-desc
          :end-before: end-mc-rm-desc
     
   * - :mc:`mc share`
     - .. include:: /minio-cli/minio-mc/mc-share.rst
          :start-after: start-mc-share-desc
          :end-before: end-mc-share-desc
     
   * - :mc:`mc sql`
     - .. include:: /minio-cli/minio-mc/mc-sql.rst
          :start-after: start-mc-sql-desc
          :end-before: end-mc-sql-desc
     
   * - :mc:`mc stat`
     - .. include:: /minio-cli/minio-mc/mc-stat.rst
          :start-after: start-mc-stat-desc
          :end-before: end-mc-stat-desc

   * - :mc:`mc tag`
     - .. include:: /minio-cli/minio-mc/mc-tag.rst
          :start-after: start-mc-tag-desc
          :end-before: end-mc-tag-desc
     
   * - :mc:`mc tree`
     - .. include:: /minio-cli/minio-mc/mc-tree.rst
          :start-after: start-mc-tree-desc
          :end-before: end-mc-tree-desc
     
   * - :mc:`mc update`
     - .. include:: /minio-cli/minio-mc/mc-update.rst
          :start-after: start-mc-update-desc
          :end-before: end-mc-update-desc
     
   * - :mc:`mc version`
     - .. include:: /minio-cli/minio-mc/mc-version.rst
          :start-after: start-mc-version-desc
          :end-before: end-mc-version-desc
     
   * - :mc:`mc watch`
     - .. include:: /minio-cli/minio-mc/mc-watch.rst
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
   :command:`mc ls` command:

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
   :command:`mc ls` command:

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
   :glob:

   /minio-cli/minio-mc/*




