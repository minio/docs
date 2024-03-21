.. _minio-client:

============
MinIO Client
============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 1

.. container:: extlinks-video

   - `Introduction to the MinIO Client (MC) Commands <https://www.youtube.com/watch?v=pukQgDdXfqA>`__
   - `Installing and Running MinIO on Linux <https://www.youtube.com/watch?v=74usXkZpNt8&list=PLFOIsHSSYIK1BnzVY66pCL-iJ30Ht9t1o>`__

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

.. _mc-client-versioning:

Version Alignment with MinIO Server
-----------------------------------

The MinIO Client releases separately from the MinIO Server.

For best functionality and compatibility, use a MinIO Client version released closely to your MinIO Server version. 
For example, a MinIO Client released the same day or later than your MinIO Server version.

You can install a version of the MinIO Client that is more recent than the MinIO Server version. 
However, if the MinIO Client version skews too far from the MinIO Server version, you may see increased warnings or errors as a result of the differences.
For example, while core S3 APIs around copying (:mc:`mc cp`) may remain unchanged, some features or flags may only be available or stable if the client and server versions are aligned.

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

Use the :mc:`mc alias set` command to add an Amazon S3-compatible service
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

Replace each argument with the required values.
If you omit the ``ACCESS_KEY`` and ``SECRET_KEY``, the command prompts you to enter those values in the CLI.

Each of the following tabs contains a provider-specific example:

.. tab-set::

   .. tab-item:: MinIO Server

      .. code-block:: shell
         :class: copyable

         mc alias set myminio https://minioserver.example.net ACCESS_KEY SECRET_KEY

   .. tab-item:: AWS S3 Storage

      .. code-block:: shell
         :class: copyable

         mc alias set myS3 https://s3.amazon.com/endpoint ACCESS_KEY SECRET_KEY

   .. tab-item:: Google Cloud Storage

      .. code-block:: shell
         :class: copyable

         mc alias set myGCS https://storage.googleapis.com/endpoint ACCESS_KEY SECRET_KEY

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

.. note:: 

   The MinIO Client also includes an administration extension for managing MinIO deployments. 
   See :mc:`mc admin` for more complete documentation.

   The below table does not include those commands.

.. list-table::
   :header-rows: 1
   :widths: 30 70
   :width: 100%

   * - Command
     - Description

   * - | :mc:`mc alias list`
       | :mc:`mc alias remove`
       | :mc:`mc alias set`
       | :mc:`mc alias import`
       | :mc:`mc alias export`
     - .. include:: /reference/minio-mc/mc-alias.rst
          :start-after: start-mc-alias-desc
          :end-before: end-mc-alias-desc
     
   * - | :mc:`mc anonymous get`
       | :mc:`mc anonymous get-json`
       | :mc:`mc anonymous links`
       | :mc:`mc anonymous list`
       | :mc:`mc anonymous set`
       | :mc:`mc anonymous set-json`
     - .. include:: /reference/minio-mc/mc-anonymous.rst
          :start-after: start-mc-anonymous-desc
          :end-before: end-mc-anonymous-desc
     
   * - | :mc:`mc batch describe`
       | :mc:`mc batch generate`
       | :mc:`mc batch list`
       | :mc:`mc batch start`
       | :mc:`mc batch status`
     - .. include:: /reference/minio-mc/mc-batch.rst
          :start-after: start-mc-batch-desc
          :end-before: end-mc-batch-desc

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

   * - :mc:`mc du`
     - .. include:: /reference/minio-mc/mc-du.rst
          :start-after: start-mc-du-desc
          :end-before: end-mc-du-desc
     
   * - | :mc:`mc encrypt clear`
       | :mc:`mc encrypt info`
       | :mc:`mc encrypt set`
     - .. include:: /reference/minio-mc/mc-encrypt.rst
          :start-after: start-mc-encrypt-desc
          :end-before: end-mc-encrypt-desc
     
   * - | :mc:`mc event add`
       | :mc:`mc event ls`
       | :mc:`mc event rm`
     - .. include:: /reference/minio-mc/mc-event.rst
          :start-after: start-mc-event-desc
          :end-before: end-mc-event-desc
     
   * - :mc:`mc find`
     - .. include:: /reference/minio-mc/mc-find.rst
          :start-after: start-mc-find-desc
          :end-before: end-mc-find-desc

   * - :mc:`mc get`
     - .. include:: /reference/minio-mc/mc-get.rst
          :start-after: start-mc-get-desc
          :end-before: end-mc-get-desc  

   * - :mc:`mc head`
     - .. include:: /reference/minio-mc/mc-head.rst
          :start-after: start-mc-head-desc
          :end-before: end-mc-head-desc
     
   * - | :mc:`mc idp ldap accesskey`
       | :mc:`mc idp ldap add`
       | :mc:`mc idp ldap disable`
       | :mc:`mc idp ldap enable`
       | :mc:`mc idp ldap info`
       | :mc:`mc idp ldap ls`
       | :mc:`mc idp ldap policy`
       | :mc:`mc idp ldap rm`
       | :mc:`mc idp ldap update`
     - .. include:: /reference/minio-mc/mc-idp-ldap.rst
          :start-after: start-mc-idp-ldap-desc
          :end-before: end-mc-idp-ldap-desc

   * - | :mc:`mc idp openid add`
       | :mc:`mc idp openid disable`
       | :mc:`mc idp openid enable`
       | :mc:`mc idp openid info`
       | :mc:`mc idp openid ls`
       | :mc:`mc idp openid rm`
       | :mc:`mc idp openid update`
     - .. include:: /reference/minio-mc/mc-idp-openid.rst
          :start-after: start-mc-idp-openid-desc
          :end-before: end-mc-idp-openid-desc

   * - | :mc:`mc idp ldap policy attach`
       | :mc:`mc idp ldap policy detach`
       | :mc:`mc idp ldap policy entities`
     - .. include:: /reference/minio-mc/mc-idp-ldap-policy.rst
          :start-after: start-mc-idp-ldap-policy-desc
          :end-before: end-mc-idp-ldap-policy-desc

   * - | :mc:`mc ilm restore`
       | :mc:`mc ilm rule add`
       | :mc:`mc ilm rule edit`
       | :mc:`mc ilm rule export`
       | :mc:`mc ilm rule import`
       | :mc:`mc ilm rule ls`
       | :mc:`mc ilm rule rm`
       | :mc:`mc ilm tier add`
       | :mc:`mc ilm tier check`
       | :mc:`mc ilm tier info`
       | :mc:`mc ilm tier ls`
       | :mc:`mc ilm tier rm`
       | :mc:`mc ilm tier update`
     - .. include:: /reference/minio-mc/mc-ilm.rst
          :start-after: start-mc-ilm-desc
          :end-before: end-mc-ilm-desc
     
   * - | :mc:`mc legalhold clear`
       | :mc:`mc legalhold info`
       | :mc:`mc legalhold set`
     - .. include:: /reference/minio-mc/mc-legalhold.rst
          :start-after: start-mc-legalhold-desc
          :end-before: end-mc-legalhold-desc

   * - | :mc:`mc license info`
       | :mc:`mc license register`
       | :mc:`mc license update`
     - .. include:: /reference/minio-mc/mc-license.rst
          :start-after: start-mc-license-desc
          :end-before: end-mc-license-desc

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

   * - :mc:`mc od`
     - .. include:: /reference/minio-mc/mc-od.rst
          :start-after: start-mc-od-desc
          :end-before: end-mc-od-desc

   * - :mc:`mc ping`
     - .. include:: /reference/minio-mc/mc-ping.rst
          :start-after: start-mc-ping-desc
          :end-before: end-mc-ping-desc  

   * - :mc:`mc pipe`
     - .. include:: /reference/minio-mc/mc-pipe.rst
          :start-after: start-mc-pipe-desc
          :end-before: end-mc-pipe-desc  

   * - :mc:`mc put`
     - .. include:: /reference/minio-mc/mc-put.rst
          :start-after: start-mc-put-desc
          :end-before: end-mc-put-desc  

   * - | :mc:`mc quota clear`
       | :mc:`mc quota info`
       | :mc:`mc quota set`
     - .. include:: /reference/minio-mc/mc-quota.rst
          :start-after: start-mc-quota-desc
          :end-before: end-mc-quota-desc  
     
   * - :mc:`mc rb`
     - .. include:: /reference/minio-mc/mc-rb.rst
          :start-after: start-mc-rb-desc
          :end-before: end-mc-rb-desc
     
   * - | :mc:`mc replicate add`
       | :mc:`mc replicate backlog`
       | :mc:`mc replicate export`
       | :mc:`mc replicate import`
       | :mc:`mc replicate ls`
       | :mc:`mc replicate resync`
       | :mc:`mc replicate rm`
       | :mc:`mc replicate status`
       | :mc:`mc replicate update`
     - .. include:: /reference/minio-mc/mc-replicate.rst
          :start-after: start-mc-replicate-desc
          :end-before: end-mc-replicate-desc
     
   * - | :mc:`mc retention clear`
       | :mc:`mc retention info`
       | :mc:`mc retention set`
     - .. include:: /reference/minio-mc/mc-retention.rst
          :start-after: start-mc-retention-desc
          :end-before: end-mc-retention-desc

   * - :mc:`mc rm`
     - .. include:: /reference/minio-mc/mc-rm.rst
          :start-after: start-mc-rm-desc
          :end-before: end-mc-rm-desc
     
   * - | :mc:`mc share download`
       | :mc:`mc share ls`
       | :mc:`mc share upload`
     - .. include:: /reference/minio-mc/mc-share.rst
          :start-after: start-mc-share-desc
          :end-before: end-mc-share-desc
     
   * - :mc:`mc sql`
     - .. include:: /reference/minio-mc/mc-sql.rst
          :start-after: start-mc-sql-desc
          :end-before: end-mc-sql-desc
     
   * - :mc:`mc stat`
     - .. include:: /reference/minio-mc/mc-stat.rst
          :start-after: start-mc-stat-desc
          :end-before: end-mc-stat-desc

   * - | :mc:`mc support callhome`
       | :mc:`mc support diag`
       | :mc:`mc support inspect`
       | :mc:`mc support perf`
       | :mc:`mc support profile`
       | :mc:`mc support proxy`
       | :mc:`mc support top api`
       | :mc:`mc support top disk`
       | :mc:`mc support top locks`
       | :mc:`mc support upload`
     - .. include:: /reference/minio-mc/mc-support.rst
          :start-after: start-mc-support-desc
          :end-before: end-mc-support-desc

   * - | :mc:`mc tag list`
       | :mc:`mc tag remove`
       | :mc:`mc tag set`
     - .. include:: /reference/minio-mc/mc-tag.rst
          :start-after: start-mc-tag-desc
          :end-before: end-mc-tag-desc
     
   * - :mc:`mc tree`
     - .. include:: /reference/minio-mc/mc-tree.rst
          :start-after: start-mc-tree-desc
          :end-before: end-mc-tree-desc
     
   * - :mc:`mc undo`
     - .. include:: /reference/minio-mc/mc-undo.rst
          :start-after: start-mc-undo-desc
          :end-before: end-mc-undo-desc

   * - :mc:`mc update`
     - .. include:: /reference/minio-mc/mc-update.rst
          :start-after: start-mc-update-desc
          :end-before: end-mc-update-desc
     
   * - | :mc:`mc version enable`
       | :mc:`mc version info`
       | :mc:`mc version suspend`
     - .. include:: /reference/minio-mc/mc-version.rst
          :start-after: start-mc-version-desc
          :end-before: end-mc-version-desc
     
   * - :mc:`mc watch`
     - .. include:: /reference/minio-mc/mc-watch.rst
          :start-after: start-mc-watch-desc
          :end-before: end-mc-watch-desc

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

.. _minio-mc-certificates:

Certificates
------------

The MinIO Client stores certificates and CAs for deployments to the following paths:

Linux, MacOS, and other Unix-like systems:

.. code-block:: shell

   ~/.mc/certs/ # certificates
   ~/.mc/certs/CAs/ # Certificate Authorities

Windows systems:

.. code-block:: shell

   C:\Users\[username]\mc\certs\ # certificates
   C:\Users\[username]\mc\certs\CAs\ # Certificate Authorities

When creating a new :ref:`alias <minio-mc-alias>`, the MinIO Client fetches the peer certificate, computes the public key fingerprint, and asks the user whether to accept the deployment's certificate.
If you decide to trust the certificate, the MinIO Client adds the certificate to the certificate authority path listed above.

.. note::

   In testing environments, you can bypass the certificate check for selected MinIO Client commands by passing the ``--insecure`` flag.

.. _minio-wildcard-matching:

Pattern Matching
----------------

Some commands and flags allow for pattern matching.
When enabled, a pattern can include include either of two wildcards for character replacement.
   
- ``*`` to represent a string of characters to match, either in the middle or end.
- ``?`` to represent a single character.

For example, refer to the following examples for wildcard uses and their results.

.. list-table::
   :header-rows: 1
   :widths: 40 30 30
   :width: 100%

   * - Pattern
     - Text
     - Match Result

   * - ``abc*``
     - ab
     - Match

   * - ``abc*``
     - abd
     - Not a match
  
   * - ``abc*c``
     - abcd
     - Match

   * - ``ab*??d``
     - abxxc
     - Match

   * - ``ab*??d``
     - abxc
     - Match

   * - ``ab??d``
     - abxc
     - Match

   * - ``ab??d``
     - abc
     - Match

   * - ``ab??d``
     - abcxdd
     - Not a match

.. _minio-mc-global-options:

Global Options
--------------

.. program:: mc

All :ref:`commands <minio-mc-commands>` support the following global options.
You can also define some of these options using :ref:`Environment Variables <minio-server-envvar-mc>`.

.. option:: --debug

   Enables verbose output to the console.

   For example, the following operation adds verbose output to the 
   :mc:`mc ls` command:

   .. code-block:: shell
      :class: copyable

      mc --debug ls play

   Alternatively, set the environment variable :envvar:`MC_DEBUG`.

.. option:: --config-dir

   The path to a ``JSON`` formatted configuration file that
   :program:`mc` uses for storing data. See :ref:`mc-configuration` for
   more information on how :program:`mc` uses the configuration file.

   Alternatively, set the environment variable :envvar:`MC_CONFIG_DIR`.

.. option:: --json

   Enables `JSON lines <http://jsonlines.org/>`_ formatted output to the
   console.

   For example, the following operation adds JSON Lines output to the 
   :mc:`mc ls` command:

   .. code-block:: shell
      :class: copyable

      mc --json ls play 

   Alternatively, set the environment variable :envvar:`MC_JSON`.

.. option:: --no-color

   Disables the built-in color theme for console output. Useful for dumb
   terminals.

   Alternatively, set the environment variable :envvar:`MC_NO_COLOR`.

.. option:: --quiet

   Suppresses console output. 

   Alternatively, set the environment variable :envvar:`MC_QUIET`.

.. option:: --insecure

   Disables TLS/SSL certificate verification. Allows TLS connectivity to 
   servers with invalid certificates. Exercise caution when using this
   option against untrusted S3 hosts.

   Alternatively, set the environment variable :envvar:`MC_INSECURE`.

.. option:: --version

   Displays the current version of :mc-cmd:`mc`. 

.. mc-cmd:: --help
   :optional:

   Displays a summary of command usage on the terminal.

.. toctree::
   :titlesonly:
   :hidden:
   
   /reference/minio-mc/minio-client-settings
   /reference/minio-mc/mc-alias
   /reference/minio-mc/mc-anonymous
   /reference/minio-mc/mc-batch
   /reference/minio-mc/mc-cat
   /reference/minio-mc/mc-cp
   /reference/minio-mc/mc-diff
   /reference/minio-mc/mc-du
   /reference/minio-mc/mc-encrypt
   /reference/minio-mc/mc-event
   /reference/minio-mc/mc-find
   /reference/minio-mc/mc-get
   /reference/minio-mc/mc-head
   /reference/minio-mc/mc-idp-ldap
   /reference/minio-mc/mc-idp-ldap-accesskey
   /reference/minio-mc/mc-idp-ldap-policy
   /reference/minio-mc/mc-idp-openid
   /reference/minio-mc/mc-ilm
   /reference/minio-mc/mc-legalhold
   /reference/minio-mc/mc-license
   /reference/minio-mc/mc-ls
   /reference/minio-mc/mc-mb
   /reference/minio-mc/mc-mirror
   /reference/minio-mc/mc-mv
   /reference/minio-mc/mc-od
   /reference/minio-mc/mc-ping
   /reference/minio-mc/mc-pipe
   /reference/minio-mc/mc-put
   /reference/minio-mc/mc-quota
   /reference/minio-mc/mc-rb
   /reference/minio-mc/mc-replicate
   /reference/minio-mc/mc-retention
   /reference/minio-mc/mc-rm
   /reference/minio-mc/mc-share
   /reference/minio-mc/mc-sql
   /reference/minio-mc/mc-stat
   /reference/minio-mc/mc-support
   /reference/minio-mc/mc-tag
   /reference/minio-mc/mc-tree
   /reference/minio-mc/mc-undo
   /reference/minio-mc/mc-update
   /reference/minio-mc/mc-version
   /reference/minio-mc/mc-watch
