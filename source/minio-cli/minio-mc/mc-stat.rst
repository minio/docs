===========
``mc stat``
===========

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc stat

Description
-----------

.. start-mc-stat-desc

The :mc:`mc stat` command displays information on objects contained in the
specified S3-compatible service bucket. :mc:`mc stat` has similar functionality
as the ``stat`` command when used on a filesystem path.

.. end-mc-stat-desc

Examples
--------

.. tabs::

   .. tab:: Single Object

      .. code-block:: shell
         :class: copyable

         mc stat ALIAS/PATH

      - Replace :mc-cmd:`ALIAS <mc stat TARGET>` with the 
        :mc:`alias <mc alias>` of the S3-compatible host.

      - Replace :mc-cmd:`PATH <mc stat TARGET>` with the path to the bucket
        or object on the S3-compatible host.

   .. tab:: Object(s) in Bucket

      Use :mc:`mc stat` with the :mc-cmd-option:`~mc stat recursive` option
      to apply the operation to all objects in the bucket:

      .. code-block:: shell
         :class: copyable

         mc stat --recursive ALIAS/PATH

      - Replace :mc-cmd:`ALIAS <mc stat TARGET>` with the 
        :mc:`alias <mc alias>` of the S3-compatible host.

      - Replace :mc-cmd:`PATH <mc stat TARGET>` with the path to the bucket
        or object on the S3-compatible host.


Syntax
------

:mc:`~mc stat` has the following syntax:

.. code-block:: shell
   :class: copyable

   mc stat [FLAGS] TARGET

:mc:`~mc stat` supports the following arguments:

.. mc-cmd:: TARGET

   The full path to an object or file.

   For objects on an S3-compatible service, specify the :mc:`alias <mc alias>`
   of a configured S3 service as the prefix to the :mc-cmd:`~mc stat TARGET`
   path. For example:

   .. code-block:: shell

      mc stat [FLAGS] play/mybucket

   If you specify a directory or bucket, you must also specify
   :mc-cmd-option:`mc stat recursive` to recursively apply the command to
   the contents of that directory or bucket.

.. mc-cmd:: recursive, r
   :option:

   Recursively :mc:`mc stat` the contents of 
   :mc-cmd:`~mc stat TARGET`.

.. mc-cmd:: encrypt-key
   :option:

   Encrypt or decrypt objects using server-side encryption with
   client-specified keys. Specify key-value pairs as ``KEY=VALUE``.
   
   - Each ``KEY`` represents a bucket or object. 
   - Each ``VALUE`` represents the data key to use for encrypting 
      object(s).

   Enclose the entire list of key-value pairs passed to 
   :mc-cmd-option:`~mc stat encrypt-key` in double quotes ``"``.

   :mc-cmd-option:`~mc stat encrypt-key` can use the ``MC_ENCRYPT_KEY``
   environment variable for retrieving a list of encryption key-value pairs
   as an alternative to specifying them on the command line.
