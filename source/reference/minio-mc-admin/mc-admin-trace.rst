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

Use :mc-cmd:`mc admin trace` to monitory activity for a specific path:

.. code-block:: shell
   :class: copyable

   mc admin trace --path my-bucket/my-prefix/* ALIAS

- Replace :mc-cmd:`ALIAS <mc admin trace TARGET>` with the :mc-cmd:`alias <mc alias>` of the MinIO deployment.
- Replace ``my-bucket/my-prefix/*`` with the bucket, prefix, and object name or wildcard you wish to trace.

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

   - ``s3``
   - ``internal``
   - ``storage``
   - ``os``
   - ``scanner``
   - ``decommission``
   - ``healing``

.. mc-cmd:: --verbose
   
   Returns verbose output.

.. mc-cmd:: --errors, e
   
   Returns failed API operations only.

.. mc-cmd:: --response-threshold

   Takes a time string as a value, such as ``5ms``.
   Returns only calls with a response time greater than the supplied threshold.

.. mc-cmd:: --status-code

   Returns calls of the specified HTTP status code.

.. mc-cmd:: --method

   Returns call of the specified HTTP method.

.. mc-cmd:: --funcname

   Returns calls for the entered function name.

.. mc-cmd:: --path

   Returns calls for the specified path.

.. mc-cmd:: --node

   Returns calls for the specified server.

.. mc-cmd:: --request-header

   Returns calls matching the supplied request header.
