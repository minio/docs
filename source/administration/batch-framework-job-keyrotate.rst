.. _minio-batch-framework-keyrotate-job:

==================
Batch Key Rotation
==================


.. default-domain:: minio

.. contents:: Table of Contents
   :local:
   :depth: 2

.. versionadded:: MinIO RELEASE.2023-04-07T05-28-58Z

The MinIO Batch Framework allows you to create, manage, monitor, and execute jobs using a YAML-formatted job definition file (a "batch file").
The batch jobs run directly on the MinIO deployment to take advantage of the server-side processing power without constraints of the local machine where you run the :ref:`MinIO Client <minio-client>`.

The ``keyrotate`` batch job type cycles the :ref:`sse-s3 or sse-kms keys <minio-sse-data-encryption>` for encrypted objects on a MinIO deployment.

The YAML configuration supports filters to restrict key rotation to a specific set of objects by creation date, tags, metadata, or kms key.
You can also define retry attempts or set a notification endpoint and token.

.. _minio-batch-framework-keyrotate-job-ref:

Key Rotate Batch Job Reference
------------------------------

.. versionadded:: MinIO RELEASE.2023-04-07T05-28-58Z 

Use the ``keyrotate`` job type to create a batch job that cycles the :ref:`sse-s3 or sse-kms keys <minio-sse-data-encryption>` for encrypted objects.

Required Fields
~~~~~~~~~~~~~~~

  .. list-table::
     :widths: 25 75
     :width: 100%

     * - ``type:`` 
       - Either ``sse-s3`` or ``sse-kms``.
     * - ``key:`` 
       - Only for use with the ``sse-kms`` type. 
         The key to use to unseal the key vault.
   
Optional Fields
~~~~~~~~~~~~~~~

For **flag based filters**

.. list-table::
   :widths: 25 75
   :width: 100%

   * - ``newerThan:`` 
     - A string representing a length of time in ``#d#h#s`` format.
       
       Keys rotate only for objects newer than the specified length of time.
       For example, ``7d``, ``24h``, ``5d12h30s`` are valid strings.
   * - ``olderThan:`` 
     - A string representing a length of time in ``#d#h#s`` format.
       
       Keys rotate only for objects older than the specified length of time.
   * - ``createdAfter:`` 
     - A date in ``YYYY-MM-DD`` format.
  
       Keys rotate only for objects created after the date.
   * - ``createdBefore:`` 
     - A date in ``YYYY-MM-DD`` format.
       
       Keys rotate only for objects created prior to the date.
   * - ``context:``
     - Only for use with the ``sse-kms`` type.
       The context within which to perform actions. 
   * - ``tags:``
     - Rotate keys only for objects with tags that match the specified ``key:`` and ``value:``.  
   * - ``metadata:``
     - Rotate keys only for objects with metadata that match the specified ``key:`` and ``value:``.  
   * - ``kmskey:``
     - Rotate keys only for objects with a KMS key-id that match the specified value.  
       This is only applicable for the ``sse-kms`` type. 

For **notifications**

.. list-table::
   :widths: 25 75
   :width: 100%

   * - ``endpoint:`` 
     - The predefined endpoint to send events for notifications.
   * - ``token:`` 
     - An optional JSON Web Token (JWT) to access the ``endpoint``.

For **retry attempts**

If something interrupts the job, you can define a maximum number of retry attempts.
For each retry, you can also define how long to wait between attempts.

.. list-table::
   :widths: 25 75
   :width: 100%

   * - ``attempts:`` 
     - Number of tries to complete the batch job before giving up.
   * - ``delay:`` 
     - The amount of time to wait between each attempt.

Sample YAML Description File for a ``keyrotate`` Job Type
---------------------------------------------------------

Use :mc:`mc batch generate` to create a basic ``keyrotate`` batch job for further customization:

.. literalinclude:: /includes/code/keyrotate.yaml
   :language: yaml