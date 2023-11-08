==================
``mc admin trace``
==================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin trace

Description
-----------

.. start-mc-admin-trace-desc

The :mc-cmd:`mc admin trace` command displays API operations occurring on the target MinIO deployment.

.. end-mc-admin-trace-desc

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only

Examples
--------

Monitor All API operations
~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin trace` to monitor API operations on a MinIO deployment:

.. code-block:: shell
   :class: copyable

   mc admin trace -a ALIAS

- Replace :mc-cmd:`ALIAS <mc admin trace TARGET>` with the :mc-cmd:`alias <mc alias>` of the MinIO deployment.

See Calls that Return 503 Errors
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin trace` to monitor API operations that return a service unavailable 503 error:

.. code-block:: shell
   :class: copyable
   
   mc admin trace -v --status-code 503 ALIAS

- Replace :mc-cmd:`ALIAS <mc admin trace TARGET>` with the :mc-cmd:`alias <mc alias>` of the MinIO deployment.

See Console Trace for a Path
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin trace` to monitor activity for a specific path:

.. code-block:: shell
   :class: copyable

   mc admin trace --path my-bucket/my-prefix/* ALIAS

- Replace :mc-cmd:`ALIAS <mc admin trace TARGET>` with the :mc-cmd:`alias <mc alias>` of the MinIO deployment.
- Replace ``my-bucket/my-prefix/*`` with the bucket, prefix, and object name or wildcard you wish to trace.

See Console Trace for a Response Size Greater than 1Mb
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin trace` to monitor responses over a specific size:

.. code-block:: shell
   :class: copyable

   mc admin trace --filter-response --filter-size 1Mb ALIAS

- Replace :mc-cmd:`ALIAS <mc admin trace TARGET>` with the :mc-cmd:`alias <mc alias>` of the MinIO deployment.
- Replace ``1Mb`` with the desired response size.

See Console Trace for a Request Operation Durations Greater than 5ms
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin trace` to monitor long operations:

.. code-block:: shell
   :class: copyable

   mc admin trace --filter-duration --filter-size 5ms ALIAS

- Replace :mc-cmd:`ALIAS <mc admin trace TARGET>` with the :mc-cmd:`alias <mc alias>` of the MinIO deployment.

Syntax
------

:mc-cmd:`mc admin trace` has the following syntax:

.. code-block:: shell
   :class: copyable

   mc admin trace [FLAGS] TARGET

:mc-cmd:`mc admin trace` supports the following argument:

.. mc-cmd:: TARGET

   Specify the :mc:`alias <mc alias>` of a configured MinIO deployment for which to monitor API operations.

.. mc-cmd:: --all, a
   
   Returns all traffic on the MinIO deployment, including internode traffic between MinIO servers.

.. mc-cmd:: --call

   Traces only matching call types.
   For example, the following command only traces calls of the type ``scanner``.

   .. code-block:: shell

      mc admin trace --call scanner TARGET

   Valid call types include:

   - ``batch-replication``
   - ``bootstrap``
   - ``decommission``
   - ``ftp``
   - ``healing``
   - ``internal``
   - ``os``
   - ``rebalance``
   - ``replication-resync``
   - ``s3``
   - ``scanner``
   - ``storage``

   If not specified, MinIO returns call types of ``s3``.

.. mc-cmd:: --errors, e
   
   Returns failed API operations only.

.. mc-cmd:: --filter-request

   Trace calls with request size greater than the specified :mc-cmd:`~mc admin trace --filter-size` value.

   Must be used with :mc-cmd:`~mc admin trace --filter-size` flag.

.. mc-cmd:: --filter-response

   Trace calls with response size greater than the specified :mc-cmd:`~mc admin trace --filter-size` value.

   Must be used with :mc-cmd:`~mc admin trace --filter-size` flag.

.. mc-cmd:: --filter-size

   Size limit of a filtered call.

   Must be used with either :mc-cmd:`~mc admin trace --filter-request` or :mc-cmd:`~mc admin trace --filter-response` flag.

   Valid units include:

   .. list-table::
      :header-rows: 1
      :widths: 20 80
      :width: 100%
   
      * - Suffix
        - Unit Size
   
      * - ``k``
        - KB (Kilobyte, 1000 Bytes)
   
      * - ``m``
        - MB (Megabyte, 1000 Kilobytes)
   
      * - ``g``
        - GB (Gigabyte, 1000 Megabytes)
   
      * - ``t``
        - TB (Terrabyte, 1000 Gigabytes)
   
      * - ``ki``
        - KiB (Kibibyte, 1024 Bites)
   
      * - ``mi``
        - MiB (Mebibyte, 1024 Kibibytes)
   
      * - ``gi``
        - GiB (Gibibyte, 1024 Mebibytes)
   
      * - ``ti``
        - TiB (Tebibyte, 1024 Gibibytes)

.. mc-cmd:: --funcname

   Returns calls for the entered function name.

.. mc-cmd:: --method

   Returns call of the specified HTTP method.

.. mc-cmd:: --node

   Returns calls for the specified server.

.. mc-cmd:: --path

   Returns calls for the specified path.

.. mc-cmd:: --request-header

   Returns calls matching the supplied request header.

.. mc-cmd:: --request-query

   Returns calls matching the supplied request query parameter.
   This debug option should only be used at the direction of MinIO Support.

.. mc-cmd:: --response-duration

   Trace calls with response duration greater than the specified value.

.. mc-cmd:: --response-threshold

   Takes a time string as a value, such as ``5ms``.
   Returns only calls with a response time greater than the supplied threshold.

   If not specified, MinIO returns calls with a response time greater than 5ms.

.. mc-cmd:: --status-code

   Returns calls of the specified HTTP status code.

.. mc-cmd:: --stats

   Accumulate stats, such as name, count, duration, or errors.
   Accumulates up to 15 stat entries.

.. mc-cmd:: --verbose
   
   Returns verbose output.


Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals
