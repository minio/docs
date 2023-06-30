.. start-mc-limit-flags-desc

.. mc-cmd:: --limit-download
   :optional:

   Limit client-side download rates to no more than a specified rate in KiB/s, MiB/s, or GiB/s.
   This affects only the download to the local device running the MinIO Client.
   Valid units include: 
   
   - ``B`` for bytes
   - ``K`` for kilobytes
   - ``M`` for megabytes
   - ``G`` for gigabytes
   - ``T`` for terabytes
   - ``Ki`` for kibibytes
   - ``Mi`` for mibibytes
   - ``Gi`` for gibibytes
   - ``Ti`` for tebibytes

   For example, to limit download rates to no more than 1 GiB/s, use the following:

   .. code-block::

      --limit-download 1G

   If not specified, MinIO uses an unlimited download rate.

.. mc-cmd:: --limit-upload
   :optional:

   Limit client-side upload rates to no more than the specified rate in KiB/s, MiB/s, or GiB/s.
   This affects only the upload from the local device running the MinIO Client.
   Valid units include: 
   
   - ``B`` for bytes
   - ``K`` for kilobytes
   - ``M`` for megabytes
   - ``G`` for gigabytes
   - ``T`` for terabytes
   - ``Ki`` for kibibytes
   - ``Mi`` for mibibytes
   - ``Gi`` for gibibytes
   - ``Ti`` for tebibytes

   For example, to limit upload rates to no more than 1 GiB/s, use the following:

   .. code-block::

      --limit-upload 1G

   If not specified, MinIO uses an unlimited upload rate.

.. end-mc-limit-flags-desc