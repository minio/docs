.. _minio-mc-replicate-diff:
.. _minio-mc-replicate-backlog:

=====================
``mc replicate backlog``
=====================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc replicate diff
.. mc:: mc replicate backlog

.. versionchanged:: mc.RELEASE.2023-07-18T21-05-38Z

   ``mc replicate diff`` has been renamed ``mc replicate backlog``.
   No functionality has changed.

Description
-----------

.. start-mc-replicate-backlog-desc

The :mc:`mc replicate backlog` shows a list of unreplicated new or deleted objects.

.. end-mc-replicate-backlog-desc

You can list the replication status of objects for a particular remote target.
To do so, you must have the ARN of the remote target.
You can use :ref:`retrieve the remote targets configured for a bucket <minio-retrieve-remote-bucket-targets>` to find the ARN.

Syntax
------

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command shows new or deleted objects in the ``notes`` bucket of the ``teamorange/projects`` prefix on the ``myminio`` alias that have not yet replicated to a specific remote target bucket.
      The remote target's ARN is ``arn:minio:replication::3bb8c736-4014-42c5-b3cb-d64e3ebaa75e:notes``.

      .. code-block:: shell
         :class: copyable

         mc replicate backlog myminio/notes/teamorange/projects --arn arn:minio:replication::3bb8c736-4014-42c5-b3cb-d64e3ebaa75e:notes

      If any new or deleted objects have not yet replicated, the command outputs something similar to the following:

      .. code-block:: shell

         [0001-01-01 00:00:00 UTC] [2022-10-06 17:18:59 UTC]          478efe49-aa9d-46ab-8268-45b70cc4c341 PUT agenda.docx
         [0001-01-01 00:00:00 UTC] [2022-10-06 17:18:15 UTC]          b283bf43-319f-455a-a779-3c2e669fad88 PUT budget-meeting.docx

      In the output, ``PUT`` corresponds to a new object.
      Deleted objects or versions would show ``DEL``.

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] replicate backlog   \
                          [--arn "string"]    \
                          TARGET

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: TARGET
   :required:

   The path to the alias, prefix, or object.

.. mc-cmd:: arn
   :optional:

   The ARN of the remote bucket to check for new or deleted objects that have not yet replicated.

   When specified, the command returns a list of any new or deleted objects that have not replicated to the remote target.
   If not specified, the command returns a list of new or deleted objects on the source deployment that have not replicated to any remote target.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals

Examples
--------

View Unreplicated Versions of Objects at a Prefix
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Display unreplicated ``PUT`` and ``DELETE`` actions for a prefix:

.. code-block:: shell
   :class: copyable

   mc replicate backlog myminio/mybucket/path/to/prefix

- Replace ``myminio/mybucket`` with the :mc-cmd:`~mc replicate add ALIAS` and
  full bucket path for which to create the replication configuration.

- Replace ``path/to/prefix`` with the prefix or object to use for the request.

If unreplicated objects exist, the output returns a list of the actions that created or removed objects at the prefix that have not replicated to a remote target:

.. code-block:: shell

   [0001-01-01 00:00:00 UTC] [2022-10-06 17:18:59 UTC]          478efe49-aa9d-46ab-8268-45b70cc4c341 PUT agenda.docx
   [0001-01-01 00:00:00 UTC] [2022-10-06 17:18:15 UTC]          b283bf43-319f-455a-a779-3c2e669fad88 PUT budget-meeting.docx

View Unreplicated Objects at a Specific Remote Target
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following :mc:`mc replicate backlog` command shows unreplicated objects at an alias/bucket/prefix path for a specific remote target:

.. code-block:: shell
   :class: copyable

   mc replicate backlog myminio/mybucket/path/to/prefix --arn <remote-arn>

- Replace ``myminio/mybucket`` with the :mc-cmd:`~mc replicate add ALIAS` and
  full bucket path for which to show unreplicated objects.

- Replace the ``path/to/prefix`` with the desired prefix or object path.

- Replace ``<remote-arn>`` with the resource number for a specific remote target.

If unreplicated objects exist, the output returns a list of the actions that created or removed objects that have not replicated to the remote target:

.. code-block:: shell

   [0001-01-01 00:00:00 UTC] [2022-10-06 17:18:59 UTC]          478efe49-aa9d-46ab-8268-45b70cc4c341 PUT agenda.docx
   [0001-01-01 00:00:00 UTC] [2022-10-06 17:18:15 UTC]          b283bf43-319f-455a-a779-3c2e669fad88 PUT budget-meeting.docx

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility
