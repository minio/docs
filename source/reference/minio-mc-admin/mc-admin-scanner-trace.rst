==========================
``mc admin scanner trace``
==========================

.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. mc:: mc admin scanner trace

Description
-----------

.. start-mc-admin-scanner-trace-desc

The :mc-cmd:`mc admin scanner trace` command displays :ref:`scanner <minio-concepts-scanner>`-specific API operations occurring on the target MinIO deployment.

.. end-mc-admin-scanner-trace-desc

.. admonition:: Use ``mc admin`` on MinIO Deployments Only
   :class: note

   .. include:: /includes/facts-mc-admin.rst
      :start-after: start-minio-only
      :end-before: end-minio-only

.. tab-set::

   .. tab-item:: EXAMPLE

      The following example returns a list of API operations related to the scanner on the ``myminio`` deployment.

      .. code-block:: shell
         :class: copyable

         mc admin scanner trace myminio

   .. tab-item:: SYNTAX

      The command has the following syntax:

      .. code-block:: shell
         :class: copyable

         mc admin scanner trace ALIAS
                                [--filter-request]            \
                                [--filter-response]           \
                                [--filter-size <value>]       \
                                [--funcname <value>]          \
                                [--node <value>]              \
                                [--path <value>]              \
                                [--response-duration <value>] \
                                [--verbose, -v]

      .. include:: /includes/common-minio-mc.rst
         :start-after: start-minio-syntax
         :end-before: end-minio-syntax

Parameters
~~~~~~~~~~

.. mc-cmd:: ALIAS
   :required:

   The :ref:`alias <alias>` of the MinIO deployment for which to display :ref:`scanner <minio-concepts-scanner>` API operations.

.. mc-cmd:: --filter-request
   :optional:

   Trace scanner operations or calls with request size greater than the specified :mc-cmd:`~mc admin scanner trace --filter-size` value.

   **Must** be used with :mc-cmd:`~mc admin scanner trace --filter-size` flag.

.. mc-cmd:: --filter-response
   :optional:

   Trace scanner operations or calls with response size greater than the specified :mc-cmd:`~mc admin scanner trace --filter-size` value.

   **Must** be used with :mc-cmd:`~mc admin scanner trace --filter-size` flag.

.. mc-cmd:: --filter-size
   :optional:

   Filter output to request sizes or response sizes greater than the specified size.

   Must be used with either :mc-cmd:`~mc admin scanner trace --filter-request` or :mc-cmd:`~mc admin scanner trace --filter-response` flag.

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
   :optional:

   Returns calls for the entered function name.

.. mc-cmd:: --node
   :optional:

   Returns calls for the specified server.

.. mc-cmd:: --path
   :optional:

   Returns calls for the specified path.

.. mc-cmd:: --response-duration
   :optional:

   Trace calls with response duration greater than the specified value.

.. mc-cmd:: --verbose, -v
   :optional:

   Returns verbose output.


Global Flags
~~~~~~~~~~~~

.. include:: /includes/common-minio-mc.rst
   :start-after: start-minio-mc-globals
   :end-before: end-minio-mc-globals


Examples
--------

Monitor all scanner API operations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin scanner trace` to monitor :ref:`scanner <minio-concepts-scanner>` API operations on the MinIO deployment at the alias ``myminio``:

.. code-block:: shell
   :class: copyable

   mc admin scanner trace myminio

Show scanner trace for a specific path
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin scanner trace` to monitor API operations for a the path ``my-bucket/my-prefix/*`` on the deployment at the ``myminio`` alias:

.. code-block:: shell
   :class: copyable
   
    mc admin scanner trace --path my-bucket/my-prefix/* myminio

Show scanner API operations for the ``scanObject`` function
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Monitor scanner activity for the ``scanObject function`` on the ``myminio`` deployment:

.. code-block:: shell
   :class: copyable

   mc admin scanner trace --funcname=scanner.ScanObject myminio 

Show scanner operation requests greater than ``1MB`` in size
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin scanner trace` to monitor requests larger than a ``1MB`` on the ``myminio`` deployment:

.. code-block:: shell
   :class: copyable

   mc admin scanner trace --filter-request --filter-size 1MB myminio

Show scanner operation responses greater than ``1MB`` in size
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin scanner trace` to monitor large response sizes:

.. code-block:: shell
   :class: copyable

    mc admin scanner trace --filter-response --filter-size 1MB myminio 

Show scanner operations that last longer than five milliseconds
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use :mc-cmd:`mc admin scanner trace` to monitor long operations:

.. code-block:: shell
   :class: copyable

    mc admin scanner trace --response-duration 5ms myminio
