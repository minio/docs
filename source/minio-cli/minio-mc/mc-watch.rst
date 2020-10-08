============
``mc watch``
============

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc watch

Description
-----------

.. start-mc-watch-desc

The :mc:`mc watch` command watches for events on the specified S3-compatible
service bucket or local filesystem path. For S3 services, use :mc:`mc event` to
configure bucket event notifications on S3-compatible services.

.. end-mc-watch-desc

Examples
--------

Watch for Events in a Bucket
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: shell
   :class: copyable

   mc watch --recursive ALIAS/PATH

- Replace :mc-cmd:`ALIAS <mc watch TARGET>` with the :mc:`alias <mc alias>`
  of the S3-compatible host.

- Replace :mc-cmd:`PATH <mc watch TARGET>` with the path to the bucket.

Syntax
------

:mc:`~mc watch` has the following syntax:

.. code-block:: shell
   :class: copyable

   mc watch [FLAGS] TARGET

:mc:`~mc watch` supports the following arguments:

   .. mc-cmd:: TARGET
   
      *Required* The S3 service :mc:`alias <mc alias>` and bucket *or* the local
      filesystem directory to watch for event notifications. Specify the
      :mc-cmd:`alias <mc alias>` of a configured S3 service as the prefix to the
      ``TARGET`` path. For example:

      .. code-block:: shell

         mc event add play/mybucket

   .. mc-cmd:: event
      :option:

      The event(s) to watch for. Specify multiple events using a comma ``,``
      delimiter. See :ref:`mc-event-supported-events` for supported events.

      Defaults to ``put,delete, get``.
         
   .. mc-cmd:: prefix
      :option:

      The bucket prefix in which to watch for the speciified 
      :mc-cmd-option:`~mc event event`.

      For example, given a :mc-cmd:`~mc event TARGET` of ``play/mybucket`` and a 
      :mc-cmd-option:`~mc event prefix` of ``photos``, only events in 
      ``play/mybucket/photos`` trigger bucket notifications.

   .. mc-cmd:: suffix
      :option:

      The bucket suffix in which to watch for the speciified 
      :mc-cmd-option:`~mc event event`.

      For example, given a :mc-cmd:`~mc event TARGET` of ``play/mybucket`` and a 
      :mc-cmd-option:`~mc event suffix` of ``.jpg``, only events in 
      ``play/mybucket/*.jpg`` trigger bucket notifications.

   .. mc-cmd:: recursive, r
      :option:

      Recursively watch for events in the specified 
      :mc-cmd:`~mc watch TARGET` bucket path or local directory.


   