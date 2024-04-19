.. start-scanner-speed-config

You can adjust how MinIO balances the scanner performance with read/write operations using either the :envvar:`MINIO_SCANNER_SPEED` environment variable or the :mc-conf:`scanner speed <scanner.speed>` configuration setting.

.. end-scanner-speed-config


.. start-scanner-speed-values

MinIO utilizes the :ref:`scanner <minio-concepts-scanner>` for :ref:`bucket replication <minio-bucket-replication>`, :ref:`site replication <minio-site-replication-overview>`, :ref:`lifecycle management <minio-lifecycle-management>`, and :ref:`healing <minio-concepts-healing>` tasks.

Valid values include:

.. list-table::
   :stub-columns: 1
   :widths: 30 70
   :width: 100%
   
   * - ``fastest``
     - Removes scanner wait on read/write latency, allowing the scanner to operate at full-speed and IOPS consumption.
       This setting may result in reduced read and write performance.
   
   * - ``fast``
     - Sets a short scanner wait time on read/write latency, allowing the scanner to operate at a higher speed and IOPS consumption.
       This setting may result in reduced read and write performance.
   
   * - ``default``
     - Sets a moderate scanner wait time on read/write latency, allowing the scanner to operate at a balanced speed and IOPS consumption.
       This setting seeks to maintain read and write performance while allowing ongoing scanner activity. 
   
   * - ``slow``
     - Sets a medium scanner wait time on read/write latency, where the scanner operates at a reduced speed and IOPS consumption.
       This setting allows better read and write performance while reducing scanner performance.

       May impact scanner-dependent features, such as lifecycle management and replication.

   * - ``slowest``
     - Sets a large scanner wait time on read/write latency, where the scanner operates at a substantially lower speed and IOPS consumption.
       This setting prioritizes read and write operations at the potential cost of scanner operations.

       May impact scanner-dependent features, such as lifecycle management and replication.

.. end-scanner-speed-values