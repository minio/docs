

.. Root API Access

.. start-minio-data-compression-default-excluded-desc

.. list-table::
   :header-rows: 1
   :widths: 30 30 40
   :width: 100%

   * - Object Type
     - File Extension
     - Media (MIME) Type

   * - Audio
     -
     - ``audio/*``

   * - Video
     - | ``*.mp4``
       | ``*.mkv``
       | ``*.mov``
     - ``video/*``

   * - Image
     - | ``*.jpg``
       | ``*.png``
       | ``*.gif``
     - ``application/x-compress`` (LZW)

   * - 7ZIP Compressed
     - ``*.7z``
     -

   * - BZIP2 Compressed
     - ``*.bz2``
     - ``application/x-bz2``

   * - GZIP Compressed
     - ``*.gz``
     - ``application/x-gzip``

   * - RAR Compressed
     - ``*.rar``
     -

   * - LZMA Compressed
     - ``*.xz``
     - ``application/x-xz``

   * - ZIP Compressed
     - ``*.zip``
     - | ``application/zip``
       | ``application-x-zip-compressed``

.. end-minio-data-compression-default-excluded-desc

.. start-minio-data-compression-default-desc

+-----------------+--------------------------+
| File Extensions | Media (MIME) Types       |
+=================+==========================+
| ``.txt``        | ``text/*``               |
|                 |                          |
| ``.log``        | ``application/json``     |
|                 |                          |
| ``.csv``        | ``application/xml``      |
|                 |                          |
| ``.json``       | ``binary/octet-stream``  |
|                 |                          |
| ``.tar``        |                          |
|                 |                          |
| ``.xml``        |                          |
|                 |                          |
| ``.bin``        |                          |
+-----------------+--------------------------+

.. end-minio-data-compression-default-desc

.. start-minio-api-sync-events

Enables synchronous :ref:`bucket notifications <minio-bucket-notifications>`.

Specify ``on`` to direct MinIO to wait until the remote target returns success on receipt of an event before processing further events.

Defaults to ``off``, or asynchronous bucket notifications where MinIO does not wait for the remote target to return success on receipt of an event.

.. end-minio-api-sync-events
