.. start-scanner-speed-config

You can adjust how MinIO balances the scanner performance with read/write operations using either the :envvar:`MINIO_SCANNER_SPEED` environment variable or the :mc-conf:`scanner speed <scanner.speed>` configuration setting.

.. end-scanner-speed-config


.. start-scanner-speed-values

MinIO utilizes the scanner for :ref:`bucket replication <minio-bucket-replication>`, :ref:`site replication <minio-site-replication-overview>`, and :ref:`lifecycle management <minio-lifecycle-management>` tasks.

Valid values include:

.. list-table::
   :stub-columns: 1
   :widths: 30 70
   :width: 100%
   
   * - ``fastest``
     - Removes wait time for scanner activity, maximizing scanner performance at the possible cost of some read or write performance.
   
   * - ``fast``
     - Adds a small wait time for scanner activity if MinIO notices a latency in read or write processes slight risk of some loss of read or write performance.
   
   * - ``default``
     - Adds a moderate wait time for scanner activity if MinIO notices a latency in any read or write processes.
       Provides a standard balance of maintaining read/write performance with ongoing scanner activity. 
   
   * - ``slow``
     - Adds an additional delay to scanner processes if MinIO notices a latency in any read or write operation in order to prioritize read/write performance at a slight cost of scanner performance.

   * - ``slowest``
     - Adds the greatest delay to scanner processes if MinIO notices a latency of any read or write operation in order to prioritize read/write performance at a greater cost of scanner performance.

.. end-scanner-speed-values