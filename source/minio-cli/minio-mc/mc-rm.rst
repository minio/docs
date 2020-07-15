=========
``mc rm``
=========

.. default-domain:: minio

.. contents:: On This Page
   :local:
   :depth: 1

.. mc:: mc rm

Description
-----------

.. start-mc-rm-desc

The :mc:`mc rm` command removes objects on a target S3-compatible service. 
To completely remove a bucket, use :mc:`mc rb` instead.

.. end-mc-rm-desc

Syntax
------

:mc:`~mc rm` has the following syntax:

.. code-block:: shell

   mc rm [FLAGS] TARGET [TARGET ...]

:mc:`~mc rm` supports the following arguments:

.. mc-cmd:: TARGET

   **REQUIRED**

   The full path to object to remove. 
   Specify the :mc:`alias <mc alias>` of a configured S3 service as the 
   prefix to the :mc-cmd-option:`~mc rm TARGET` path. 

   For example:

   .. code-block:: shell

      mc rm play/mybucket/object.txt play/mybucket/otherobject.txt

   If specifying the path to a bucket or bucket prefix, you **must** also
   specify the :mc-cmd-option:`~mc rm recursive` and :mc-cmd-option:`~mc rm
   force` arguments. For example:

   .. code-block:: shell

      mc rm --recursive --force play/mybucket/

      mc rm --recursive --force play/mybucket/myprefix

.. mc-cmd:: recursive, r
   :option:
   
   Recursively remove the contents of each :mc-cmd-option:`~mc rm TARGET`
   bucket or bucket prefix.

   If specifying :mc-cmd-option:`~mc rm recursive`, you **must** also
   specify :mc-cmd-option:`~mc rm force`.

   Mutually exclusive with :mc-cmd-option:`mc rm version-id`

.. mc-cmd:: force
   :option:

   Allows running :mc:`mc rm` with any of the following arguments:
   
   - :mc-cmd-option:`~mc rm recursive`
   - :mc-cmd-option:`~mc rm versions`
   - :mc-cmd-option:`~mc rm stdin`

.. mc-cmd:: dangerous
   :option:
   
   Allows running :mc:`mc rm` when the :mc-cmd:`~mc rm TARGET` specifies the
   root (all buckets) on the S3-compatible service.

.. mc-cmd:: version-id
   :option:

   Removes the specified version of the :mc-cmd:`~mc rm TARGET` object. Requires
   the bucket to have versioning enabled. Use :mc:`mc version` to enable bucket
   versioning.

   Mutually exclusive with any of the following flags:
   
   - :mc-cmd-option:`~mc rm versions`
   - :mc-cmd-option:`~mc rm rewind`
   - :mc-cmd-option:`~mc rm recursive`

.. mc-cmd:: versions
   :option:

   Removes all versions of the :mc-cmd:`~mc rm TARGET` object or
   object(s). Requires the bucket to have versioning enabled. Use 
   :mc:`mc version` to enable bucket versioning.

   Use :mc-cmd-option:`~mc rm rewind` and 
   :mc-cmd-option:`~mc rm versions` together to clear the
   object lock settings of all versions of the object or object(s) which
   existed at the specified duration prior to the current date. *or* at the
   specified date.

   Mutually exclusive with :mc-cmd-option:`~mc rm version-id`.

.. mc-cmd:: rewind
   :option:

   Removes the latest version of the object or object(s) which existed at either
   the specified duration prior to the current date *or* at a specific date.

   - For duration, specify a string in ``#d#hh#mm#ss`` format. For example:
      ``--rewind "1d2hh3mm4ss"``.

   - For a date in time, specify an ISO8601-formatted timestamp. For example:
      ``--rewind "2020.03.24T10:00"``.

   For example, to clear the object lock settings to the object or object(s)
   as they existed 30 days prior to the current date: ``--rewind "30d"``

   Use :mc-cmd-option:`~mc rm rewind` and :mc-cmd-option:`~mc rm versions`
   together to remove all versions of the object or object(s) which existed at
   the specified duration prior to the current date *or* at the specified date.

   Mutually exclusive with :mc-cmd-option:`~mc rm version-id`.

.. mc-cmd:: older-than
   :option:

   Remove object(s) older than the specified time limit. Specify a string
   in ``#d#hh#mm#ss`` format. For example: ``--older-than 1d2hh3mm4ss``.

      
   Defaults to ``0`` (all objects).

.. mc-cmd:: newer-than
   :option:

   Remove object(s) newer than the specified number of days.  Specify a
   string in ``#d#hh#mm#ss`` format. For example: 
   ``--newer-than 1d2hh3mm4ss``

   Defaults to ``0`` (all objects).

.. mc-cmd:: incomplete, I
   :option:

   Remove incomplete uploads for the specified object.

   If any :mc-cmd-option:`~mc rm TARGET` specifies a bucket, 
   you **must** also specify :mc-cmd-option:`~mc rm recursive`
   and :mc-cmd-option:`~mc rm force`.

.. mc-cmd:: fake
   :option:

   Perform a fake remove operation. Use this operation to perform 
   validate that the :mc:`mc rm` operation will only
   remove the desired objects or buckets.

.. mc-cmd:: stdin
   :option:

   Read object names or buckets from ``STDIN``.

.. mc-cmd:: encrypt-key
   :option:

   The encryption key to use for performing Server-Side Encryption with Client
   Keys (SSE-C). Specify comma seperated key-value pairs as ``KEY=VALUE,...``.
   
   - For ``KEY``, specify the S3-compatible service 
     :mc-cmd:`alias <mc alias>` and full path to the bucket, including any
     bucket prefixes. Separate the alias and bucket path with a forward slash 
     ``\``. For example, ``play/mybucket``

   - For ``VALUE``, specify the data key to use for encryption object(s) in
     the bucket or bucket prefix specified to ``KEY``.

   :mc-cmd-option:`~mc rm encrypt-key` can use the ``MC_ENCRYPT_KEY``
   environment variable for populating the list of encryption key-value
   pairs as an alternative to specifying them on the command line.

Behavior
--------

Deleting Bucket Contents
~~~~~~~~~~~~~~~~~~~~~~~~

Using :mc:`mc rm` to remove all contents in a bucket does not delete the bucket
itself. Any configurations associated to the bucket remain in place, such as
:mc-cmd-option:`default object lock settings <mc retention set default>`.

To completely remove a bucket, use :mc:`mc rb` instead of :mc:`mc rm`.

Examples
--------

Remove a Single Object
~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

.. code-block:: shell
   :class: copyable

   mc rm play/mybucket/myobject.txt

Recursively Remove a Bucket's Contents
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

.. code-block:: shell
   :class: copyable
   
   mc rm --recursive --force play/mybucket

Remove All Incomplete Upload Files for an Object
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

.. code-block:: shell
   :class: moveable

    mc rm --incomplete play/mybucket/myobject.1gig

Remove Objects Older Than Specified Time Period
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. include:: /includes/play-alias-available.rst
   :start-after: play-alias-only
   :end-before: end-play-alias-only

.. code-block:: shell
   :class: moveable

   mc rm --recursive --force --older-than 1d2h30m play/mybucket



