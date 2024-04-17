============
``mc watch``
============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc watch

Syntax
------

.. start-mc-watch-desc

The :mc:`mc watch` command watches for events on the specified MinIO bucket or
local filesystem path. For S3 services, use :mc:`mc event add` to configure
bucket event notifications on S3-compatible services.

.. end-mc-watch-desc

You can also use :mc:`mc watch` against a local filesystem directory to
produce similar results to running
the ``inotify -e modify,create,delete,move`` command.

.. tab-set::

   .. tab-item:: EXAMPLE

      The following command watches for 
      :ref:`events <mc-event-supported-events>` on any object or prefix in the 
      ``mydata`` bucket on the ``myminio`` MinIO deployment:

      .. code-block:: shell
         :class: copyable

         mc watch --recursive myminio/mydata

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc [GLOBALFLAGS] watch                \
                          [--event "string"]   \
                          [--prefix "string"]  \
                          [--recursive]        \
                          [--suffix "string"]  \
                          ALIAS

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS

   *Required* The :ref:`alias <alias>` of a MinIO deployment and the
   full path to the bucket to watch for configured events. For example:

   .. code-block:: shell

      mc watch myminio/mybucket

.. mc-cmd:: --event
   

   The event(s) to watch for. Specify multiple events using a comma ``,``
   delimiter. See :ref:`mc-event-supported-events` for supported events.

   Defaults to ``put,delete, get``.
      
.. mc-cmd:: --prefix
   

   The bucket prefix in which to watch for the specified 
   :mc-cmd:`~mc watch --event`.

   For example, given a :mc-cmd:`~mc watch ALIAS` of ``play/mybucket`` and a 
   :mc-cmd:`~mc watch --prefix` of ``photos``, only events in 
   ``play/mybucket/photos`` trigger bucket notifications.

.. mc-cmd:: --recursive, r
   

   Recursively watch for events in the specified 
   :mc-cmd:`~mc watch ALIAS` bucket path or local directory.

.. mc-cmd:: --suffix
   

   The bucket suffix in which to watch for the specified 
   :mc-cmd:`~mc watch --event`.

   For example, given a :mc-cmd:`~mc watch ALIAS` of ``play/mybucket`` and a 
   :mc-cmd:`~mc watch --suffix` of ``.jpg``, only events in 
   ``play/mybucket/*.jpg`` trigger bucket notifications.

Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-json-globals
   :end-before: end-minio-mc-json-globals

Examples
--------

Watch for Events in a Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: shell
   :class: copyable

   mc watch --recursive ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc watch ALIAS>` with the :mc:`alias <mc alias>`
  of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc watch ALIAS>` with the path to the bucket.


Behavior
--------

S3 Compatibility
~~~~~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-s3-compatibility
   :end-before: end-minio-mc-s3-compatibility

